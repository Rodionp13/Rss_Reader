//
//  ArticleCell.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 27.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface ArticleCell : UITableViewCell
@property(strong, nonatomic) UIImageView *myImageView;

- (void) configureCellImage:(UIImage*)article;
@end
