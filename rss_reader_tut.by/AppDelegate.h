//
//  AppDelegate.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

//+ (void)downloadTaskWith:(NSURL *)url handler:(void(^)(NSURL *destinationUrl))complition;
+ (void)printError:(NSError*)error withDescr:(NSString *)descr;


@end

