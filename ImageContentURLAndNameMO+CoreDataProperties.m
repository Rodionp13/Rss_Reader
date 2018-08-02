//
//  ImageContentURLAndNameMO+CoreDataProperties.m
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ImageContentURLAndNameMO+CoreDataProperties.h"

@implementation ImageContentURLAndNameMO (CoreDataProperties)

+ (NSFetchRequest<ImageContentURLAndNameMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ImageContentURLAndNameEnt"];
}

@dynamic imageUrl;
@dynamic article;

@end
