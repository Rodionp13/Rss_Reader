//
//  Channel.m
//  htmlParsing
//
//  Created by User on 7/24/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Channel.h"

@implementation Channel

- (id)initWithName:(NSString *)name url:(NSString *)url; {
    self = [super init];
    
    if(self) {
        _name = name;
        _url = url;
//        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    
    return self;
}
@end
