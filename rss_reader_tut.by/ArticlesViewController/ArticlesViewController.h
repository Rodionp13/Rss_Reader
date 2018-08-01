//
//  ArticlesViewController.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelsViewController.h"
#import "AppDelegate.h"
#import "Article.h"
#import "ArticleCell.h"
#import "FirstCell.h"
#import "Downloader.h"

static NSString *const kItem = @"item";
static NSString *const kTitle = @"title";
static NSString *const kLink = @"link";
static NSString *const kDescription = @"description";
static NSString *const kMediaContent = @"media:content";
static NSString *const kPubDate = @"pubDate";
static NSString *const kVideoContent = @"video";

@interface ArticlesViewController : UIViewController 
@property(strong, nonatomic) NSString *stringUrl;

@end
