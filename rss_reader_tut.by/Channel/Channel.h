//
//  Channel.h
//  htmlParsing
//
//  Created by User on 7/24/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Channel : NSObject
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) UIImageView *imageView;

- (id)initWithName:(NSString *)name url:(NSString *)url;
//- (void)configureImage;
@end
