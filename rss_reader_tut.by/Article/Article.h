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
@property(strong, nonatomic) NSURL *iconUrl;
@property(strong, nonatomic) NSURL *originalIconUrl;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *articleDescr;
@property(strong, nonatomic) NSURL *articleLink;
@property(strong, nonatomic) NSMutableArray *imageContentURLsAndNames;
@property(strong, nonatomic) NSMutableArray *videoContentURLsAndNames;

- (id)initWithTitle:(NSString *)title iconUrlStr:(NSString *)iconUrlString iconPathComponent:(NSString *)iconPathComponent date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images andVideoContent:(NSMutableArray *)videoContent;

@end
