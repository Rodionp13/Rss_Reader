//
//  Article.m
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Article.h"

@implementation Article

- (id)initWithTitle:(NSString *)title iconUrlStr:(NSString *)iconUrlString icon:(UIImage *)icon date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images andVideoContent:(NSMutableArray *)videoContent {
    self = [super init];
    
    if(self) {
        _title = title;
//        if(iconUrlString != nil) {
        _iconUrl = [NSURL URLWithString:iconUrlString];
//        } else {/*NSAssert(errno, @"passing iconUrlString is nil see init of Article!!!!!!!");*/}
        if(icon != nil) {
            _icon = icon ;//1)iconPathComponent   2)[NSURL URLWithString:iconPathComponent]
        } else {NSAssert(errno, @"passing iconPathComponent is nil see init of Article!!!!!!!");}
        _date = date;
        _articleDescr = description;
        _articleLink = [NSURL URLWithString:link];
        _imageContentURLsAndNames = images;
        _videoContentURLsAndNames = videoContent;
    }
    return self;
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"ARTICLE:\ntitle %@\n iconUrl %@\n originalUrl %@\n date %@\n artDescription %@\n imges %@\n videoContent%@\n\n\n\n\n", self.title,self.iconUrl,self.originalIconUrl,self.date,self.articleDescr, self.imageContentURLsAndNames, self.videoContentURLsAndNames];
//}

@end
