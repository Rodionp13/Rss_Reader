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

//- (void)checkingForLoadingArticleContent:(NSURL*)urlForAllChannelsArticles {
//
//
//
//
//
//    [Downloader downloadTaskWith:urlForAllChannelsArticles handler:^(NSURL *destinationUrl) {
//        MyXMLParser *xmlParser = [[MyXMLParser alloc] initWithUrl:destinationUrl];
//        if(![xmlParser.myXMLParser parse]) {NSAssert(errno, @"Some problems with parser!!!APPManager respone");} else {NSLog(@"PARSING STARTED APPManager response");}
//    }];
//}

- (void)checkingForLoadingChennelContent {
    NSURL *url = [NSURL URLWithString:kChannelsLink];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kChannelGroup ascending:YES];
    NSArray *dataFromDB = [self.cdManager loadDataFromDBWithPredicate:nil andDescriptor:@[descriptor]];
    
    if(dataFromDB.count != 0) {// core data.count != 0 && networkConnection isAvailable
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
        
        } else {
            if([AppDelegate isNetworkAvailable]) {
            [self firstDownloadContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
                APPManager *__weak weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                APPManager *__strong strongSelf = weakSelf;
                [strongSelf.delegate complitionLoadingChannelsData:channelsAndHeaders];
                [strongSelf.cdManager addNewRecordsToDB:channelsAndHeaders];
                //WHy WHy Why not???????
                //[self.cdDelegate parseChannelsDataToChannelsMOAndAddRecordsToDB: channelsAndHeaders];
                });
              }];
            }
    }
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

@end
