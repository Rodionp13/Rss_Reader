//
//  CDManager.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelMO+CoreDataClass.h"
#import "ArticleMO+CoreDataClass.h"
#import "AppDelegate.h"


@interface CDManager : NSObject

- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate;
@end
