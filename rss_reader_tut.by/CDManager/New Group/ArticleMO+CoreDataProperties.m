//
//  ArticleMO+CoreDataProperties.m
//  rss_reader_tut.by
//
//  Created by User on 7/30/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//
//

#import "ArticleMO+CoreDataProperties.h"

@implementation ArticleMO (CoreDataProperties)

+ (NSFetchRequest<ArticleMO *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ArticleEnt"];
}

@dynamic articleDescr;
@dynamic articleLink;
@dynamic date;
@dynamic iconUrl;
@dynamic originalIconUrl;
@dynamic title;
@dynamic channel;
@dynamic imageContentURLsAndNames;
@dynamic videoContentURLsAndNames;

@end
