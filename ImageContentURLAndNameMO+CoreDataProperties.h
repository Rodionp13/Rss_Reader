//
//  ImageContentURLAndNameMO+CoreDataProperties.h
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ImageContentURLAndNameMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageContentURLAndNameMO (CoreDataProperties)

+ (NSFetchRequest<ImageContentURLAndNameMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageUrl;
@property (nullable, nonatomic, retain) ArticleMO *article;

@end

NS_ASSUME_NONNULL_END
