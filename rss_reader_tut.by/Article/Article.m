//
//  Article.m
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableDictionary *)images andVideoContent:(NSMutableDictionary *)videoContent {
    self = [super init];
    
    if(self) {
        _title = title;
        _date = date;
        _articleDescr = description;
        _articleLink = [NSURL URLWithString:link];
        _imageContentURLsAndNames = images;
        _videoContentURLsAndNames = videoContent;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ARTICLE:\n%@\n%@\n%@\n%@\n%@\n%@", self.title,self.date,self.articleDescr, self.articleDescr, self.imageContentURLsAndNames, self.videoContentURLsAndNames];
}

@end
