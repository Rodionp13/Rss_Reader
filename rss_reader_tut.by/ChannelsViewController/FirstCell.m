//
//  FirstCell.m
//  htmlParsing
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "FirstCell.h"

@implementation FirstCell

- (void) configureCellImage {
    if(_myImageView == nil) {
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.myImageView setImage:[UIImage imageNamed:@"rss"]];
    [self.myImageView setClipsToBounds:YES];
    [self addSubview:self.myImageView];
    }
}

@end
