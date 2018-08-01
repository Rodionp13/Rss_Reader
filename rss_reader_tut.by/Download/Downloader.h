//
//  Downloader.h
//  rss_reader_tut.by
//
//  Created by User on 7/29/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject

+ (NSURL*)downloadTaskWith:(NSURL *)url handler:(void(^)(NSURL *destinationUrl))complition;
+ (NSURL *)copyItem:(NSURL *)location;
@end
