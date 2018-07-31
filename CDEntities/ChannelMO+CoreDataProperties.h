//
//  ChannelMO+CoreDataProperties.h
//  rss_reader_tut.by
//
//  Created by User on 7/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ChannelMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChannelMO (CoreDataProperties)

+ (NSFetchRequest<ChannelMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *channelGroup;
@property (nullable, nonatomic, retain) NSSet<ArticleMO *> *articles;

@end

@interface ChannelMO (CoreDataGeneratedAccessors)

- (void)addArticlesObject:(ArticleMO *)value;
- (void)removeArticlesObject:(ArticleMO *)value;
- (void)addArticles:(NSSet<ArticleMO *> *)values;
- (void)removeArticles:(NSSet<ArticleMO *> *)values;

@end

NS_ASSUME_NONNULL_END
