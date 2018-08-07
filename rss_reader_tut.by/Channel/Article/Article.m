//
//  Article.m
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title iconUrl:(NSURL *)iconUrl date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images {
    self = [super init];
    
    if(self) {
        _title = title;
        _iconUrl = iconUrl;
        _date = date;
        _articleDescr = description;
        _articleLink = [NSURL URLWithString:link];
        _imageContentURLsAndNames = images;
    }
    return self;
}

@end
