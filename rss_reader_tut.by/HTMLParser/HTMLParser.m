//
//  HTMLParser.m
//  htmlParsing
//
//  Created by User on 7/25/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "HTMLParser.h"
#import "Channel.h"

@implementation HTMLParser

- (NSDictionary *)parseHTML:(NSString *)htmlString {
    NSArray * requiredHtmlSrings = [self parseHTMLString:htmlString];
    NSArray *validHtmlStrings = [self parseArrOfHTMLstrings:requiredHtmlSrings];
    NSDictionary *result = [self getChannelsAndHeaders:validHtmlStrings];
    
    return result;
}


- (NSArray *)parseHTMLString:(NSString *)htmlString {
    NSArray *htmlStringsArr = [htmlString componentsSeparatedByString:@"\n"];
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    //    for(NSString *match in temp) {
    //        NSLog(@"%@", match);
    //    }
    //    NSLog(@"%@", temp);
    
    BOOL flag = NO;
    for(int i = 0; i < htmlStringsArr.count; i++) {
        if([[htmlStringsArr objectAtIndex:i] isEqualToString:begin]) {
            flag = YES;
        }
        if(flag == YES) {
            [result addObject:htmlStringsArr[i]];
        }
        if([htmlStringsArr[i+1] containsString:end]) {
            flag = NO;
            break;
        }
    }
    //    NSLog(@"%lu", result.count);
    return [result copy];
}


- (NSArray *)parseArrOfHTMLstrings:(NSArray *)feedArr {
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex1 options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRegularExpression *regulrExpression2 = [NSRegularExpression regularExpressionWithPattern:regex2 options:NSRegularExpressionCaseInsensitive error:NULL];
    NSMutableArray *matches = [NSMutableArray array];
    
    for(NSString *item in feedArr) {
        
        NSTextCheckingResult *match1;  NSTextCheckingResult *match2; NSString *substring1; NSString *substring2;
        NSArray *headersArr = [regulrExpression2 matchesInString:item options:0 range:NSMakeRange(0, [item length])];
        NSArray *channelsArr = [regularExpression matchesInString:item options:0 range:NSMakeRange(0, [item length])];
        
        for(match1 in headersArr) {
            NSRange range = [match1 rangeAtIndex:1];
            substring1 = [item substringWithRange:range];
            [matches addObject:[item substringWithRange:range]];
        }
        for(match2 in channelsArr) {
            NSRange range = [match2 rangeAtIndex:1];
            substring2 = [item substringWithRange:range];
            [matches addObject:[item substringWithRange:range]];
        }
    }
    //    for(NSString *i in matches) {
    //        NSLog(@"%@", i);
    //    }
    
    return [matches copy];
}

- (NSDictionary *)getChannelsAndHeaders:(NSArray *)feedArr {
    NSMutableArray *mutFeedArr = [feedArr mutableCopy];
    NSMutableArray *headers = [NSMutableArray array];
    NSMutableArray *channels = [NSMutableArray array];
    NSMutableArray *subChannels = [NSMutableArray array];
    BOOL flag = NO;
    
    for(int i = 0; i < mutFeedArr.count; i++) {
        NSMutableString *mutStr = [NSMutableString stringWithString:mutFeedArr[i]];
        if([mutStr containsString:@"https"]) {
            NSArray *objArray = [mutStr componentsSeparatedByString:@"\">"];
            Channel *channel = [[Channel alloc] initWithName:[objArray lastObject] url:[objArray firstObject]];
            [mutFeedArr replaceObjectAtIndex:i withObject:channel];
            
            if(flag == YES) {
                [subChannels addObject:channel];
            }
            
            if((i + 1) < mutFeedArr.count && ([mutFeedArr[i+1] containsString:@"Новости"] && ![mutFeedArr[i+1] containsString:@"https"])) {
                if(subChannels.count != 0) {
                    [channels addObject:subChannels.copy];
                    [subChannels removeAllObjects];
                }
            }
            if(i == mutFeedArr.count - 1) {
                [channels addObject:subChannels.copy];
            }
            
        } else {
            flag = YES;
            [headers addObject:mutStr];
        }
    }
    NSArray *freshNews = [mutFeedArr objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 2)]];
//    self.lastNewsForAllTopics = [[mutFeedArr objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 2)]] mutableCopy];
    [mutFeedArr removeObjectsInRange:NSMakeRange(0, 2)];
    
    return @{kHeaders:headers, kChannels:channels, kFreshNews:freshNews};
}

@end
