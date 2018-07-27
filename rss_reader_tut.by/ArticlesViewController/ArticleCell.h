//
//  ArticleCell.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 27.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCell : UITableViewCell
@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UILabel *date;
@property(strong, nonatomic) UIImageView *myImageView;

- (void) configureCellWithTitleText:(NSString *)textLabel data:(NSString *)date;
- (UIImageView*) configureCellImage;
@end
