//
//  Manager.m
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "APPManager.h"
#import "CDManager.h"
#import "Downloader.h"
#import "HTMLParser.h"
#import "MyXMLParser.h"
#import "Article.h"
#import "Channel.h"
#import "AppDelegate.h"

static NSString *const kChannelsLink = @"https://news.tut.by/rss.html";
static NSString *const kDownloadedData = @"DownloadedData";
static NSString *const kDataBaseData = @"DataBaseData";

@interface APPManager()
@property(strong, nonatomic) CDManager *cdManager;
@property(strong, nonatomic) HTMLParser *htmlParser;
@property(strong, nonatomic) NSArray *fetchedDataAfterXmlParsing;
@property(strong, nonatomic) ChannelMO *selectedChannel;
//Test
@property(strong, nonatomic) NSArray<ArticleMO*> *sortedArticles;
@property(strong, nonatomic) NSArray<Article*> *convertedArticlesFromDb;
//@property(strong, nonatomic) NSArray<Article*> *downloadedArticles;
@end

@implementation APPManager

- (CDManager *)cdManager {
    if(_cdManager != nil) {
        return _cdManager;
    }
    return [[CDManager alloc] init];
}

- (HTMLParser*)htmlParser {
    if(_htmlParser != nil) {
        return _htmlParser;
    }
    return [[HTMLParser alloc] init];
}

- (void)checkingForLoadingNews:(Article*)article complition:(void(^)(NSMutableArray*images))complitionBlock {
    NSMutableArray *urls = [article imageContentURLsAndNames];
    NSMutableArray *downloadedImages = [NSMutableArray array];
    __block int counter = 0;
    for(ImageContentURLAndNameMO *imageMO in urls) {
        NSString *strUrl = imageMO.imageUrl;
        NSURL *url = [NSURL URLWithString:strUrl];
        [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
            [downloadedImages addObject:destinationUrl];
            counter += 1;
        }];
    }
    if(counter == urls.count) {
    complitionBlock(downloadedImages);
    }
}



- (void)checkingForLoadingArticleContent:(NSURL*)urlForAllChannelsArticles {
    NSArray *sortedAtricles = [self prepareAndGetSortedArticlesDataFromDb:urlForAllChannelsArticles];
    self.sortedArticles = sortedAtricles;//set for future use
    NSLog(@"COUNT ARTICLES: %lu", sortedAtricles.count);
//    for(ArticleMO*artMO in sortedAtricles) {
//        NSLog(@"TITLE:%@", artMO.title);
//        NSArray *images = [artMO.imageContentURLsAndNames allObjects];
//        for(ImageContentURLAndNameMO *image in images) {
//            NSLog(@"IMAGE:%@\n", image.imageUrl);
//        }
//    }
    if(sortedAtricles.count != 0) {
        [self.cdManager convertArticlesMOinToArticlesObjects:sortedAtricles withComplitionBlock:^(NSMutableArray<Article *> *articlesArr) {
            [self.delegate complitionLoadingArticlesData:articlesArr];
            self.convertedArticlesFromDb = articlesArr;
            
            if([AppDelegate isNetworkAvailable]) {
                [self firstDownloadArticlesContent:urlForAllChannelsArticles];
            } else {NSLog(@"NO CONNECTION!");}
            }];
        
    } else {
        if([AppDelegate isNetworkAvailable]) {
            [self firstDownloadArticlesContent:urlForAllChannelsArticles];
        } else {NSLog(@"NO CONNECTION AND NO DATA IN PERSISTENT STORE!");}
    }
}

- (NSArray *)prepareAndGetSortedArticlesDataFromDb:(NSURL*)channelUrl {
    NSArray *selectedChannel = [self getSelectedChannelFromDb:channelUrl];
    if(![[selectedChannel lastObject] isKindOfClass:ChannelMO.class]) {NSAssert(errno, @"Wrong type of object(shoud be ChannelMO response from prepareAndGetArticlesDataFromDb:)");}
    ChannelMO *channel = (ChannelMO*)[selectedChannel lastObject];
    NSArray<ArticleMO*> *articles = [channel.articles allObjects];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedArticles = [articles sortedArrayUsingDescriptors:@[descriptor]];
    
    return sortedArticles;
}

- (NSArray *)getSelectedChannelFromDb:(NSURL*)channelUrl {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",kChannelUrlAtr,[channelUrl absoluteString]];
    NSArray *selectedChannel = [self.cdManager loadDataFromDBWithPredicate:predicate andDescriptor:nil forEntity:ChannelEnt];
    if(selectedChannel.count > 1) {NSAssert(errno, @"Count of Channel Array > 1 response from getSelectedChannelFromDb: method");}
    self.selectedChannel = [selectedChannel lastObject];
    return selectedChannel;
}

- (void)firstDownloadArticlesContent:(NSURL*)url {
    [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
        MyXMLParser *xmlParser = [[MyXMLParser alloc] initWithUrl:destinationUrl];
        xmlParser.delegate = self;
        if(![xmlParser.myXMLParser parse]) {NSAssert(errno, @"Some problems with parser!!!APPManager respone");} else {NSLog(@"PARSING STARTED APPManager response");}
    }];
}

//Delegate CallBack from MyXMlParse obj
- (void)getArticlesDataAfterXMlParsing:(NSArray *)fetchedXMlData {
    //Case When there are no objects in persistent Store
    if(self.sortedArticles.count == 0) {
    [self.delegate complitionLoadingArticlesData:fetchedXMlData.mutableCopy];
    [self.cdManager addNewArticlesToChannel:self.selectedChannel articlesToAdd:fetchedXMlData channelSetIsEmpty:YES];
    }
    //Case when there are some objects in persistent Store
    else {
        NSArray *converted = [NSArray arrayWithArray:self.convertedArticlesFromDb];
        [self compareDownloadedArticlesWithDataBaseArticles:fetchedXMlData dataBaseArticles:converted withComplitionBlock:^(NSArray *newArticles) {
            if(newArticles.count != 0) {
                NSMutableArray *mutArrDownloadedArticles = fetchedXMlData.mutableCopy;
                for(int i = 0; i < newArticles.count; i++) {
                    Article *article = newArticles[i];
                    [mutArrDownloadedArticles insertObject:article atIndex:0];
                }
                NSArray *arrToUpdate = [NSArray arrayWithArray:mutArrDownloadedArticles.copy];
                [self.delegate complitionLoadingArticlesData:arrToUpdate.mutableCopy];
                [self.cdManager addNewArticlesToChannel:self.selectedChannel articlesToAdd:newArticles channelSetIsEmpty:NO];
            }
        }];
    }
}

- (void)compareDownloadedArticlesWithDataBaseArticles:(NSArray*)downloadedArticles dataBaseArticles:(NSArray*)convertedAtricles withComplitionBlock:(void(^)(NSArray*newArticles))complition {
    NSMutableArray *newArticles = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        for(int i = 0; i < downloadedArticles.count; i++) {
            Article *downloadedArticle = downloadedArticles[i];
            NSString *articleLinkDownloaded = downloadedArticle.articleLink.absoluteString;
            NSLog(@"DLink:%@", articleLinkDownloaded);
            int countFlag = 0;
            
            for(int j = 0; j < convertedAtricles.count; j++) {
                Article *convertedArticle = convertedAtricles[j];
                NSString *articleLinkConverted = convertedArticle.articleLink.absoluteString;
                NSLog(@"CLink:%@", articleLinkConverted);
                BOOL isMatched = [articleLinkDownloaded isEqualToString:articleLinkConverted];
                
                if(isMatched == YES) {countFlag += 1; isMatched = NO; NSLog(@"YES");}
                
                if(countFlag == 0 && j == convertedAtricles.count - 1) {
                    [newArticles addObject:downloadedArticle];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complition(newArticles.copy);
        });
    });
}

- (void)checkingForLoadingChennelContent {
    NSURL *url = [NSURL URLWithString:kChannelsLink];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kChannelGroupAtr ascending:YES];
    NSArray *dataFromDB = [self.cdManager loadDataFromDBWithPredicate:nil andDescriptor:@[descriptor] forEntity:ChannelEnt];
//    NSLog(@"%lu == dataFromDb,\n%@", dataFromDB.count, [[dataFromDB lastObject] valueForKey:@"name"]);
    
    if(dataFromDB.count > 0) {// core data.count != 0 && networkConnection isAvailable
        NSDictionary *validChannelObjects = [self.cdManager parseMOinToObjects:dataFromDB];
        [self.delegate complitionLoadingChannelsData:validChannelObjects];
        
        if([AppDelegate isNetworkAvailable]) {
            APPManager *__weak weakSelf = self;
            [weakSelf firstDownloadChannelContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
                __block NSArray *newChannels;   APPManager *__strong strongSelf = weakSelf;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                newChannels = [strongSelf checkForNewDownloadedElements:[channelsAndHeaders valueForKey:kChannels]];
                    NSMutableArray *headers = [channelsAndHeaders valueForKey:kHeaders];
                    NSMutableArray *channels = [[channelsAndHeaders valueForKey:kChannels] arrayByAddingObjectsFromArray:newChannels].mutableCopy;
                    NSMutableArray *freshNews = [channelsAndHeaders valueForKey:kFreshNews];
                    [strongSelf.delegate complitionLoadingChannelsData:@{kHeaders:headers, kChannels:channels, kFreshNews:freshNews}];
                    //cdResponse
                    [strongSelf.cdManager addNewRecordsToDB:@{kHeaders:headers, kChannels:@[newChannels]}];//@[newChannels] as other data sourse comes as @[@[]];
                    //                NSLog(@"COUNT OF NEW CHANNELS = %lu", newChannels.count);
                });
            }];
           }
        
        } else if(dataFromDB.count == 0) {
            if([AppDelegate isNetworkAvailable]) {
            APPManager *__weak weakSelf = self;
            [weakSelf firstDownloadChannelContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
            APPManager *__strong strongSelf = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.delegate complitionLoadingChannelsData:channelsAndHeaders];
                [strongSelf.cdManager addNewRecordsToDB:channelsAndHeaders];
                });
              }];
            }
    }
}

- (void)firstDownloadChannelContent:(NSURL*)url withComplition:(void(^)(NSDictionary *channelsAndHeaders))complitionBlock {
    [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
        if(destinationUrl != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
            NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *channelsAndHeaders = [self.htmlParser parseHTML:resString];
            
            complitionBlock(channelsAndHeaders);
        } else {NSAssert(errno, @"Failed to load channels");}
    }];
}

- (NSArray *)checkForNewDownloadedElements:(NSArray*)groupChannels {
    NSMutableArray *newChannelsToAddinDb = [NSMutableArray array];
    
    for(int i = 0; i < groupChannels.count; i++) {
        NSArray *channelsForSpesifiedGroup = groupChannels[i];
        for(Channel *channel in channelsForSpesifiedGroup) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"url", channel.url];
            NSArray *oldChannels = [self.cdManager loadDataFromDBWithPredicate:predicate andDescriptor:nil forEntity:ChannelEnt];
            if(oldChannels.count > 1) {NSAssert(errno, @"there is more than one elem in Db %lu", oldChannels.count);}
            if(oldChannels.count == 0) {
                [newChannelsToAddinDb addObject:channel];
            } else {NSLog(@"CHANNEL is alraady in Db, %@", channel);}
        }
    }
    return newChannelsToAddinDb.copy;
}

@end
