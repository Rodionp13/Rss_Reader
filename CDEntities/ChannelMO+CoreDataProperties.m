//
//  ChannelMO+CoreDataProperties.m
//  rss_reader_tut.by
//
//  Created by User on 7/31/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ChannelMO+CoreDataProperties.h"

@implementation ChannelMO (CoreDataProperties)

+ (NSFetchRequest<ChannelMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ChannelEnt"];
}

@dynamic name;
@dynamic url;
@dynamic channelGroup;
@dynamic articles;

@end
