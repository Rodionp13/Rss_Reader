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
#import "Article.h"
#import "Channel.h"

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

- (void)checkingForLoadingChennelContent {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:kChannelGroup ascending:YES];
    NSArray *dataFromDB = [self.cdManager loadDataFromDBWithPredicate:nil andDescriptor:@[descriptor]];
    if(dataFromDB.count != 0) {
        NSDictionary *validChannelObjects = [self.cdManager parseMOinToObjects:dataFromDB];
        [self.delegate complitionLoadingChannelsData:validChannelObjects];
        
//        [self firstDownloadContent:[NSURL URLWithString:kChannelsLink] withComplition:^(NSDictionary *channelsAndHeaders) {
//            
//        }];
        
        } else {
        NSURL *url = [NSURL URLWithString:kChannelsLink];
        [self firstDownloadContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate complitionLoadingChannelsData:channelsAndHeaders];
                [self.cdManager addNewRecordsToDB:channelsAndHeaders];
                //WHy WHy Why not???????
                //                [self.cdDelegate parseChannelsDataToChannelsMOAndAddRecordsToDB: channelsAndHeaders];
            });
        }];
    }
}

- (void)downloadContentAndUpdateDb:(NSURL*)url withComplition:(void(^)(NSDictionary *channelsAndHeaders))complitionBlock {
    [self firstDownloadContent:url withComplition:^(NSDictionary *channelsAndHeaders) {
        complitionBlock(channelsAndHeaders);
    }];
}

//- (NSArray*)compareDataFromDbAndDownloadedData:(NSDictionary*)dataToCompare {
//    NSMutableArray *result = [NSMutableArray array];
//    NSArray *downloaded = [dataToCompare valueForKey:kDownloadedData];
//    NSArray *dataBase = [dataToCompare valueForKey:kDataBaseData];
//    BOOL flag = NO;
//    int c = 0;
//    for(int i = 0; i < downloaded.count; i++) {
//        Channel *channel = [downloaded objectAtIndex:i];
//        for(int j = 0; j < dataBase.count; j++) {
//            ChannelMO *channelMO = [dataBase objectAtIndex:j];
//            if([[channel name] isEqualToString:[channelMO name]] && [[channel url] isEqualToString:[channelMO url]]) {
//                flag = YES;
//                c += 1;
//            }
//            if((i+1) == dataBase.count && c == 0) {
//                [result addObject:channel];
//            }
//        }
//    }
//    return result.copy;
//}

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





//check for CD objects
//    NSLog(@"%lu", dataFromDB.count);
//    for(ChannelMO *mo in dataFromDB) {
//        NSLog(@"%@", mo.channelGroup);
//    }
