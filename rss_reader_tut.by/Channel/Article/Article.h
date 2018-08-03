//
//  Article.h
//  rss_reader_tut.by
//
//  Created by User on 7/27/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Article : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSURL *iconUrl;
@property(strong, atomic) UIImage *icon;//NSURL *originalIconUrl;
@property(strong, nonatomic) NSString *date;
@property(strong, nonatomic) NSString *articleDescr;
@property(strong, nonatomic) NSURL *articleLink;
@property(strong, nonatomic) NSMutableArray *imageContentURLsAndNames;
@property(strong, nonatomic) NSMutableArray *videoContentURLsAndNames;

- (id)initWithTitle:(NSString *)title iconUrl:(NSURL *)iconUrl icon:(UIImage *)icon date:(NSString *)date description:(NSString *)description link:(NSString *)link images:(NSMutableArray *)images andVideoContent:(NSMutableArray *)videoContent;

@end
