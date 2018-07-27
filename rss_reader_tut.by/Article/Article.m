//
//  Article.m
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title iconUrlStr:(NSString *)iconUrlString iconPathComponent:(NSString *)iconPathComponent date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images andVideoContent:(NSMutableArray *)videoContent {
    self = [super init];
    
    if(self) {
        _title = title;
        _iconUrl = [NSURL URLWithString:iconUrlString];
        _originalIconUrl = [NSURL URLWithString:iconPathComponent];
        _date = date;
        _articleDescr = description;
        _articleLink = [NSURL URLWithString:link];
        _imageContentURLsAndNames = images;
        _videoContentURLsAndNames = videoContent;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"ARTICLE:\ntitle %@\n iconUrl %@\n originalUrl %@\n date %@\n artDescription %@\n imges %@\n videoContent%@\n\n\n\n\n", self.title,self.iconUrl,self.originalIconUrl,self.date,self.articleDescr, self.imageContentURLsAndNames, self.videoContentURLsAndNames];
}

@end
