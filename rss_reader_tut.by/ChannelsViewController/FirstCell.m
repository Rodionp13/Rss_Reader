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
    if(self.myImageView != nil) {
        [self deleteAll];
    }
    [self configureCellImage];
//    [self configureCellLabel:textLabel];
}

- (void) configureCellImage {
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.myImageView setImage:[UIImage imageNamed:@"rss"]];
    [self.myImageView setClipsToBounds:YES];
    [self addSubview:self.myImageView];
}

//- (void) configureCellLabel:(NSString *)textlabel {
//    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    self.nameLbl.text = textlabel;
//    [self.nameLbl setFont:[UIFont fontWithName:@"AvenirNext-Heavy" size:15]];
//    [self addSubview:self.nameLbl];
//    [self setUpLabelConstarints];
//}

//- (void) setUpLabelConstarints {
//    [self.nameLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
//    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.nameLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
//    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.nameLbl attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0];
////    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.nameLbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.6 constant:0];
//    [NSLayoutConstraint activateConstraints:@[centerX, centerY]];
//
//}

- (void)deleteAll {
    [self.myImageView removeFromSuperview];
    [self.nameLbl removeFromSuperview];
}


@end
