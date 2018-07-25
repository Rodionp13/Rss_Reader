//
//  FirstCell.m
//  htmlParsing
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "FirstCell.h"

@implementation FirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) configureCellWithTitleText:(NSString *)textLabel {
    if(self.myImageView != nil && self.nameLbl != nil) {
        [self deleteAll];
    }
    [self configureCellImage];
    [self configureCellLabel:textLabel];
}

- (void) configureCellImage {
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [self.myImageView.layer setBorderWidth:5];
        [self.myImageView.layer setBorderColor:UIColor.blueColor.CGColor];
        [self.myImageView.layer setCornerRadius:15];
    
    [self addSubview:self.myImageView];
}

- (void)deleteAll {
    [self.myImageView removeFromSuperview];
    [self.nameLbl removeFromSuperview];
}

- (void) configureCellLabel:(NSString *)textlabel {
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width + 50, self.imageView.center.y, 100, 20)];
    [self.nameLbl.layer setBorderWidth:2];
    [self.nameLbl.layer setBorderColor:UIColor.blueColor.CGColor];
    [self.nameLbl.layer setCornerRadius:15];
    self.nameLbl.text = textlabel;
    
    [self addSubview:self.nameLbl];
}


@end
