//
//  ArticleMO+CoreDataProperties.h
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ArticleMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ArticleMO (CoreDataProperties)

+ (NSFetchRequest<ArticleMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *articleDescr;
@property (nullable, nonatomic, copy) NSString *articleLink;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *iconUrl;
@property (nullable, nonatomic, copy) NSString *originalIconUrl;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) ChannelMO *channel;
@property (nullable, nonatomic, retain) NSSet<ImageContentURLAndNameMO *> *imageContentURLsAndNames;
@property (nullable, nonatomic, retain) NSSet<VideoContentURLAndNameMO *> *videoContentURLsAndNames;

@end

@interface ArticleMO (CoreDataGeneratedAccessors)

- (void)addImageContentURLsAndNamesObject:(ImageContentURLAndNameMO *)value;
- (void)removeImageContentURLsAndNamesObject:(ImageContentURLAndNameMO *)value;
- (void)addImageContentURLsAndNames:(NSSet<ImageContentURLAndNameMO *> *)values;
- (void)removeImageContentURLsAndNames:(NSSet<ImageContentURLAndNameMO *> *)values;

- (void)addVideoContentURLsAndNamesObject:(VideoContentURLAndNameMO *)value;
- (void)removeVideoContentURLsAndNamesObject:(VideoContentURLAndNameMO *)value;
- (void)addVideoContentURLsAndNames:(NSSet<VideoContentURLAndNameMO *> *)values;
- (void)removeVideoContentURLsAndNames:(NSSet<VideoContentURLAndNameMO *> *)values;

@end

NS_ASSUME_NONNULL_END
