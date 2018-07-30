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

- (void)checkingForLoadingContent {
    NSArray *dataFromDB = [self.cdManager loadDataFromDBWithPredicate:nil];
    
    if(dataFromDB.count != 0) {
        
    } else {
        NSURL *url = [NSURL URLWithString:kChannelsLink];
        [self downloadContent:url withComplition:^{
            //cd Task
        }];
    }
}

- (void)downloadContent:(NSURL*)url withComplition:(void(^)(void))complitionBlock {
    [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
        if(destinationUrl != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
            NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *channelsAndHeaders = [self.htmlParser parseHTML:resString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate complitionLoadingChannelsData:channelsAndHeaders];
                
                //                    self.headers = [channelsAndHeaders valueForKey:kHeaders];
                //                    self.channels = [channelsAndHeaders valueForKey:kChannels];
                //                    self.freshNewsForAllArticles = [channelsAndHeaders valueForKey:kFreshNews];
                //                    [self.myTable reloadData];
            });
        } else {NSAssert(errno, @"Failed to load channels");}
    }];
}

- (NSArray<NSManagedObject*>*)parseChannelsDataToChannelsMO:(NSArray *)channelsData {
    for(int i = 0; i < channelsData.count; i++) {
        
    }
    return @[];
}



@end
