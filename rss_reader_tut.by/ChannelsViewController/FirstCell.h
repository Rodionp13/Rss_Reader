//
//  FirstCell.h
//  htmlParsing
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstCell : UITableViewCell
@property(strong, nonatomic) UILabel *nameLbl;
@property(strong, nonatomic) UIImageView *myImageView;

- (void) configureCellWithTitleText:(NSString *)textLabel;
- (void)deleteAll;
@end
