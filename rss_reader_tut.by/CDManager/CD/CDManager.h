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
#import "APPManager.h"

static NSString *const kArticleEnt = @"ArticleEnt";
static NSString *const kChannelEnt = @"ChannelEnt";
static NSString *const kImageContentURLAndNameEnt = @"ImageContentURLAndNameEnt";
static NSString *const kVideoContentURLAndNameEnt = @"VideoContentURLAndNameEnt";

//entity attributes && relationshops
static NSString *const kChannelGroup = @"channelGroup";


@interface CDManager : NSObject

- (void)addNewRecordsToDB:(NSDictionary *)channelGroups;
- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects;
- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors;
@end
