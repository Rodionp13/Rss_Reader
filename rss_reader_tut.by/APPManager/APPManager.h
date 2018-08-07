//
//  Manager.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyXMLParser.h"

@protocol APPManagerDelegate
@optional
- (void) complitionLoadingChannelsData:(NSDictionary *)channelsData;
- (void) complitionLoadingArticlesData:(NSMutableArray *)articlesData;
- (void) userAlert;
@end


@interface APPManager : NSObject <RLMyDelegate>
@property(weak, nonatomic) id <APPManagerDelegate> delegate;

- (void)checkingForLoadingChennelContent;
- (void)checkingForLoadingArticleContent:(NSURL*)urlForAllChannelsArticles;
- (void)checkingForLoadingNews:(Article*)article complition:(void(^)(NSMutableArray*images))complitionBlock;
@end
