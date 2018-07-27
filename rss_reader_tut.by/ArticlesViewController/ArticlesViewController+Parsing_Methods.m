//
//  ArticlesViewController+Parsing_Methods.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 27.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController+Parsing_Methods.h"

@implementation ArticlesViewController (Parsing_Methods)

- (NSArray *)parseArticlesDataIntoArticlesObjects:(NSMutableArray *)fetchedDataForArticles {
    NSMutableArray *mutArticlse = [NSMutableArray array];
    for(int i = 0; i < fetchedDataForArticles.count; i++) {
        NSDictionary *articleObj = [fetchedDataForArticles objectAtIndex:i];
        NSDictionary *dictWithIconUrlAndArtDescription = [self parseStringFromDescriptionTag:[articleObj valueForKey:kDescription]];
        Article *article = [[Article alloc] initWithTitle:[articleObj valueForKey:kTitle] iconUrlStr:[dictWithIconUrlAndArtDescription valueForKey:@"url"] date:[articleObj valueForKey:kPubDate] description:[dictWithIconUrlAndArtDescription valueForKey:@"shortDescription"] link:[articleObj valueForKey:kLink] images:[articleObj valueForKey:kMediaContent] andVideoContent:[articleObj valueForKey:kVideoContent]];
        
        [mutArticlse addObject:article];
    }
    return mutArticlse.copy;
}


- (NSDictionary *)parseStringFromDescriptionTag:(NSString *)strToParse {
    NSRange r = NSMakeRange(0, 0);
    NSArray *strings = [strToParse componentsSeparatedByString:@"\""];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(NSString *string in strings) {
        if([string containsString:@"https"]) {
            [result setValue:string forKey:@"url"];
        } else if([string containsString:@"/>"]) {
            for(int ch = 0; ch < string.length; ch++) {
                if([string characterAtIndex:ch] == '>') {
                    r.location = ch+1;
                } else if([string characterAtIndex:ch] == '<') {
                    int end = ch;
                    int locate = [NSNumber numberWithUnsignedInteger:r.location].intValue;
                    r.length = [NSNumber numberWithInt:end - locate].unsignedIntegerValue;
                    NSString *shortDescription = [[NSString alloc] initWithString:[string substringWithRange:r]];
                    [result setValue:shortDescription forKey:@"shortDescription"];
                }
            }
        }
    }
//    NSLog(@"%@\n%@", [[result allValues] firstObject], [[result allValues] lastObject]);
    return [result copy];
}

@end
