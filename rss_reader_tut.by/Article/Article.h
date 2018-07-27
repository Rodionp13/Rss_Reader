//
//  Article.h
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *articleDescr;
@property(strong, nonatomic) NSURL *articleLink;
@property(strong, nonatomic) NSMutableDictionary *imageContentURLsAndNames;
@property(strong, nonatomic) NSMutableDictionary *videoContentURLsAndNames;

- (id)initWithTitle:(NSString *)title date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableDictionary *)images andVideoContent:(NSMutableDictionary *)videoContent;

@end
