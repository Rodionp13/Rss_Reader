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

@interface APPManager() <MyXMLParseDelegate>
@property(strong, nonatomic) CDManager *cdManager;
@property(strong, nonatomic) HTMLParser *htmlParser;
@property(strong, nonatomic) NSArray *fetchedDataAfterXmlParsing;
@property(strong, nonatomic) ChannelMO *selectedChannel;
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

- (void)checkingForLoadingArticleContent:(NSURL*)urlForAllChannelsArticles {
//    NSArray *res = [self.cdManager loadDataFromDBWithPredicate:nil andDescriptor:nil];
//    NSLog(@"RELATIONSHIP RESULT\n%lu", res.count);
//    for(int i = 0; i < res.count; i++) {
//        ChannelMO *mo = res[i];
//        NSSet<ArticleMO*> *artMO = mo.articles;
//        NSLog(@"%lu", artMO.count);
//        NSLog(@"CHANNEL:%@", mo.name);
//        for(ArticleMO *art in artMO) {
//            NSLog(@"SCOUP%@\n%@", art.title, art.articleLink);
//        }
//        
//    }
    NSArray *sortedAtricles = [self prepareAndGetSortedArticlesDataFromDb:urlForAllChannelsArticles];
    if(sortedAtricles.count != 0) {
        [self.cdManager convertArticlesMOinToArticlesObjects:sortedAtricles withComplitionBlock:^(NSMutableArray<Article *> *articlesArr) {
            [self.delegate complitionLoadingArticlesData:articlesArr];
        }];
        //
        if([AppDelegate isNetworkAvailable]) {
            /*Than download data and compare it with CD data
             ........*/
        }
    } else if(sortedAtricles.count == 0) {
        [self firstDownloadArticlesContent:urlForAllChannelsArticles withComplitionBlock:^(NSMutableArray *articles) {
            //??? some response; for now don't know what exactcy it is to be...
        }];
        
    }
    
    
    
//    [Downloader downloadTaskWith:urlForAllChannelsArticles handler:^(NSURL *destinationUrl) {
//        MyXMLParser *xmlParser = [[MyXMLParser alloc] initWithUrl:destinationUrl];
//        xmlParser.delegate = self;
//        if(![xmlParser.myXMLParser parse]) {NSAssert(errno, @"Some problems with parser!!!APPManager respone");} else {NSLog(@"PARSING STARTED APPManager response");}
//    }];
}

- (void)firstDownloadArticlesContent:(NSURL*)url withComplitionBlock:(void(^)(NSMutableArray*articles))complitionBlock {
    [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
        MyXMLParser *xmlParser = [[MyXMLParser alloc] initWithUrl:destinationUrl];
        xmlParser.delegate = self;
        if(![xmlParser.myXMLParser parse]) {NSAssert(errno, @"Some problems with parser!!!APPManager respone");} else {NSLog(@"PARSING STARTED APPManager response");}
    }];
}

- (void)getArticlesDataAfterXMlParsing:(NSArray *)fetchedXMlData {
//    self.fetchedDataAfterXmlParsing = [NSArray arrayWithArray:fetchedXMlData];// USELESS for now
    [self.delegate complitionLoadingArticlesData:fetchedXMlData.mutableCopy];
    
    [self.cdManager addNewArticlesToChannel:self.selectedChannel articlesToAdd:fetchedXMlData];
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
    NSArray *selectedChannel = [self.cdManager loadDataFromDBWithPredicate:predicate andDescriptor:nil];
    if(selectedChannel.count > 1) {NSAssert(errno, @"Count of Channel Array > 1 response from getSelectedChannelFromDb: method");}
    self.selectedChannel = [selectedChannel lastObject];
    return selectedChannel;
}

//- (void)convertArticlesMOinToArticlesObjects:(NSArray<ArticleMO*>*)articlesMO withComplitionBlock:(void(^)(NSMutableArray<Article*>*articlesArr))complition {
//    NSMutableArray *articles = [NSMutableArray array];
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
//        for(int i = 0; i < articlesMO.count; i++) {
//            ArticleMO *artMO = articlesMO[i];
//
//            NSArray<ImageContentURLAndNameMO*> *imageContent = [artMO.imageContentURLsAndNames allObjects];
//            NSArray<VideoContentURLAndNameMO*> *videoContent = [artMO.videoContentURLsAndNames allObjects];
//            Article *article = [self getArticle:artMO images:imageContent videoContent:videoContent];
//            [articles addObject:article];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            complition(articles);
//        });
//    });
//}
//
//- (Article*)getArticle:(ArticleMO*)articleMO images:(NSArray*)images videoContent:(NSArray*)videoContent  {
//    UIImage *icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:articleMO.iconUrl]]];
//    Article *article = [[Article alloc] initWithTitle:articleMO.title iconUrlStr:articleMO.iconUrl icon:[UIImage imageNamed:@"rss"] date:articleMO.date description:articleMO.articleDescr link:articleMO.articleLink images:[images mutableCopy] andVideoContent:[videoContent mutableCopy]];
//    return article;
//}

- (void)checkingForLoadingChennelContent {
//    NSLog(@"COUNT AFTER DELETE = %lu", [self.cdManager deleteAllObjects]);
    
    NSURL *url = [NSURL URLWithString:kChannelsLink];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kChannelGroupAtr ascending:YES];
    NSArray *dataFromDB = [self.cdManager loadDataFromDBWithPredicate:nil andDescriptor:@[descriptor]];
    NSLog(@"%lu == dataFromDb,\n%@", dataFromDB.count, [[dataFromDB lastObject] valueForKey:@"name"]);
    
    if(dataFromDB.count > 0) {// core data.count != 0 && networkConnection isAvailable
        NSDictionary *validChannelObjects = [self.cdManager parseMOinToObjects:dataFromDB];
        [self.delegate complitionLoadingChannelsData:validChannelObjects];
        
        if([AppDelegate isNetworkAvailable]) {
            [self firstDownloadContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
                __block NSArray *newChannels;         APPManager *__weak weakSelf = self;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    APPManager *__strong strongSelf = weakSelf;
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
            [self firstDownloadContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
//                APPManager *__weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
//                APPManager *__strong strongSelf = weakSelf;
                [self.delegate complitionLoadingChannelsData:channelsAndHeaders];
                [self.cdManager addNewRecordsToDB:channelsAndHeaders];
//                NSLog(@"======= %lu", [[strongSelf.cdManager loadDataFromDBWithPredicate:nil andDescriptor:nil] count]);
                //WHy WHy Why not???????
                //[self.cdDelegate parseChannelsDataToChannelsMOAndAddRecordsToDB: channelsAndHeaders];
                });
              }];
            }
    }
}

- (void)firstDownloadContent:(NSURL*)url withComplition:(void(^)(NSDictionary *channelsAndHeaders))complitionBlock {
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
            NSArray *oldChannels = [self.cdManager loadDataFromDBWithPredicate:predicate andDescriptor:nil];
            if(oldChannels.count > 1) {NSAssert(errno, @"there is more than one elem in Db %lu", oldChannels.count);}
            if(oldChannels.count == 0) {
                [newChannelsToAddinDb addObject:channel];
            } else {NSLog(@"CHANNEL is alraady in Db, %@", channel);}
        }
    }
    return newChannelsToAddinDb.copy;
}

@end
