//
//  Article.m
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title iconUrlStr:(NSString *)iconUrlString date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images andVideoContent:(NSMutableArray *)videoContent {
    self = [super init];
    
    if(self) {
        _title = title;
        _iconUrl = [NSURL URLWithString:iconUrlString];
        _date = date;
        _articleDescr = description;
        _articleLink = [NSURL URLWithString:link];
        _imageContentURLsAndNames = images;
        _videoContentURLsAndNames = videoContent;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ARTICLE:\n%@\n%@\n%@\n%@\n%@\n%@\n%@", self.title,self.iconUrl,self.date,self.articleDescr, self.articleDescr, self.imageContentURLsAndNames, self.videoContentURLsAndNames];
}

@end
