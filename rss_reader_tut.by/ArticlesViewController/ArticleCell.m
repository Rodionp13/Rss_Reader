//
//  ArticleCell.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 27.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticleCell.h"

@implementation ArticleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

//- (void)prepareForReuse {
//}

//- (void) configureCellWithTitleText:(NSString *)textLabel data:(NSString *)date {
//    if(self.myImageView != nil) {
//        [self.myImageView removeFromSuperview];
//    }
//    [self configureCellImage];
//    [self configureCellLabel:textLabel date:date];
////    [self configureCellDate:date];
//}
//
//- (UIImageView*) configureCellImage {
//    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [self.myImageView.layer setBorderWidth:5];
//    [self.myImageView.layer setBorderColor:UIColor.blueColor.CGColor];
//    [self.myImageView.layer setCornerRadius:15];
//    return self.myImageView;
//}
//
////- (void)deleteAll {
////    [self.myImageView removeFromSuperview];
////    [self.nameLbl removeFromSuperview];
////    [self.date removeFromSuperview];
////}
//
//- (void) configureCellLabel:(NSString *)textlabel date:(NSString *)date {
////    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width + 50, self.imageView.center.y, 300, 20)];
////    [self.nameLbl.layer setBorderWidth:1];
////    [self.nameLbl.layer setBorderColor:UIColor.blueColor.CGColor];
////    [self.nameLbl.layer setCornerRadius:15];
////    self.nameLbl.text = textlabel;
//
////    [self addSubview:self.nameLbl];
//    [self.textLabel setText:textlabel];
//    [self.detailTextLabel setText:date];
//}
//
////- (void) configureCellDate:(NSString *)date {
////    self.date = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height / 2, 50, 20)];
////    [self.date.layer setBorderWidth:2];
////    [self.date.layer setBorderColor:UIColor.blueColor.CGColor];
////    [self.date.layer setCornerRadius:15];
////    self.date.text = date;
////
////    [self addSubview:self.date];
////}

@end
