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

//entities
static NSString *const kArticleEnt = @"ArticleEnt";
static NSString *const kChannelEnt = @"ChannelEnt";
static NSString *const kImageContentURLAndNameEnt = @"ImageContentURLAndNameEnt";
static NSString *const kVideoContentURLAndNameEnt = @"VideoContentURLAndNameEnt";

//entity attributes && relationshops
static NSString *const kChannelGroupAtr = @"channelGroup";
static NSString *const kChannelNameAtr = @"name";
static NSString *const kChannelUrlAtr = @"url";
static NSString *const kChannelArticlesRel = @"articles";

static NSString *const kArtDescrAtr = @"articleDescr";
static NSString *const kArtLinkAtr = @"articleLink";
static NSString *const kArtDateAtr = @"date";
static NSString *const kArtIconUrlAtr = @"iconUrl";
static NSString *const kArtTitleAtr = @"title";
static NSString *const kArtChannelRel = @"channel";
static NSString *const kArtImageContentUrlRel = @"imageContentURLsAndNames";
static NSString *const kArtVideoContentUrlRel = @"videoContentURLsAndNames";

static NSString *const kImageUrlAtr = @"imageUrl";
static NSString *const kImageContentArticleRel = @"article";

static NSString *const kVideoUrlAtr = @"videoUrl";
static NSString *const kVideoContentArticleRel = @"article";



@interface CDManager : NSObject

- (void)addNewRecordsToDB:(NSDictionary *)channelGroups;
- (NSDictionary *)parseMOinToObjects:(NSArray*)managedObjects;
- (NSArray *)loadDataFromDBWithPredicate:(nullable NSPredicate*)predicate andDescriptor:(nullable NSArray<NSSortDescriptor*>*)sortDescriptors;
- (NSUInteger) deleteAllObjects; //Utility method
@end
