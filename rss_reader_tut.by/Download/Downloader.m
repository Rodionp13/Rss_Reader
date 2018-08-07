//
//  Downloader.m
//  rss_reader_tut.by
//
//  Created by User on 7/29/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

+ (NSURL*)downloadTaskWith:(NSURL *)url handler:(void(^)(NSURL *destinationUrl))complition {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    __block NSURL *destinationUrl;
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(location != nil) {
            destinationUrl = [self copyItem:location];
            complition(destinationUrl);
        } else {
            complition(nil);
        }
    }];
    
    [downloadTask resume];
    
    return destinationUrl;
}

+ (NSURL *)copyItem:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [urls objectAtIndex:0];
    NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
    
    
    NSError *err;
    [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
    [self printError:err withDescr:@"Failed to copy item"];
    return destinationUrl;
}

+ (void)printError:(NSError*)error withDescr:(NSString *)descr {
    if(error != nil) {
        NSLog(@"%@\n%@\n%@", descr, error, [error localizedDescription]);
    } else {NSLog(@"Success");}
}

@end
