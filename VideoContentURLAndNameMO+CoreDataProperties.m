//
//  VideoContentURLAndNameMO+CoreDataProperties.m
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "VideoContentURLAndNameMO+CoreDataProperties.h"

@implementation VideoContentURLAndNameMO (CoreDataProperties)

+ (NSFetchRequest<VideoContentURLAndNameMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"VideoContentURLAndNameEnt"];
}

@dynamic videoUrl;
@dynamic article;

@end
