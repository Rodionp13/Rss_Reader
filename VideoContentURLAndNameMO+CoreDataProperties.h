//
//  VideoContentURLAndNameMO+CoreDataProperties.h
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "VideoContentURLAndNameMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VideoContentURLAndNameMO (CoreDataProperties)

+ (NSFetchRequest<VideoContentURLAndNameMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *videoUrl;
@property (nullable, nonatomic, retain) ArticleMO *article;

@end

NS_ASSUME_NONNULL_END
