//
//  HTMLParser.h
//  htmlParsing
//
//  Created by User on 7/25/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const begin = @"<ul class=\"b-lists\"><li class=\"lists__li\">";
static NSString *const end = @"<i class=\"main-shd\"><i class=\"main-shd-i\">";

static NSString *const regex1 = @"\\<a href=\"(.*?)\\</a>";
static NSString *const regex2 = @"\\<li class=\"lists__li lists__li_head\">(.*?)\\</li>";

static NSString *const kHeaders = @"headers";
static NSString *const kChannels = @"channels";
static NSString *const kFreshNews = @"freshNews";

@interface HTMLParser : NSObject

- (NSDictionary *)parseHTML:(NSString *)htmlString;

@end
