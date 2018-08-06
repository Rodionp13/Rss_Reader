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

- (void) configureCellImage:(UIImage*)img {
    if(_myImageView == nil) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _myImageView.image = img;
        [self.myImageView setClipsToBounds:YES];
        [self.contentView addSubview:self.myImageView];
        [self setUpConstraints];
    }
}

- (void) setUpConstraints {
    self.myImageView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *safeArea = self.safeAreaLayoutGuide;
    NSLayoutConstraint *top = [self.myImageView.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:10];
    NSLayoutConstraint *leading = [self.myImageView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:8];
    NSLayoutConstraint *bottom = [self.myImageView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:10];
    NSLayoutConstraint *width = [self.myImageView.widthAnchor constraintEqualToAnchor:safeArea.widthAnchor multiplier:0.25 constant:0];
    [NSLayoutConstraint activateConstraints:@[top, leading, bottom, width]];
}


@end
