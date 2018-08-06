//
//  FirstCell.h
//  htmlParsing
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"

@interface FirstCell : UITableViewCell
@property(strong, nonatomic) UILabel *titleLbl;
@property(strong, nonatomic) UIImageView *myImageView;

- (void) configureCellImage;
@end
