//
//  MyXMLParser+MyXMLParserTypeConvertingMethods.m
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "MyXMLParser+MyXMLParserTypeConvertingMethods.h"
#import "Downloader.h"
#import "ArticlesViewController.h"

@implementation MyXMLParser (MyXMLParserTypeConvertingMethods)
                                              //NSMutableArray*
- (NSArray<Article*>*)parseArticlesDataIntoArticlesObjects:(NSArray *)fetchedDataForArticles withComplition:(void(^)(NSArray*myRes))complitionBLock {
    NSMutableArray<Article*> *mutArticlse = [NSMutableArray array];
    
        for(int i = 0; i < fetchedDataForArticles.count; i++) {
            NSDictionary *articleObj = [fetchedDataForArticles objectAtIndex:i];
            NSDictionary *dictWithIconUrlAndArtDescription = [self parseStringFromDescriptionTag:[articleObj valueForKey:kDescription]];
            NSString *strIconUrl = [dictWithIconUrlAndArtDescription valueForKey:@"url"];
            NSString *artDescription = [dictWithIconUrlAndArtDescription valueForKey:@"shortDescription"];
            NSLog(@"HTTPS URL: %@", strIconUrl);
            if(artDescription == nil) {
                artDescription = @"NO Description";
            }

            //Initialization of artilce instance
//            UIImage *icon = [UIImage imageNamed:@"rss"];
//            NSURL *iconURL = [NSURL URLWithString:strIconUrl];
//             Article *article = [[Article alloc] initWithTitle:[articleObj valueForKey:kTitle] iconUrl:iconURL icon:icon date:[articleObj valueForKey:kPubDate] description:artDescription link:[articleObj valueForKey:kLink] images:[articleObj valueForKey:kMediaContent] andVideoContent:[articleObj valueForKey:kVideoContent]];
            
            //article.iconUrl
            if([AppDelegate isNetworkAvailable]) {
            if([NSURL URLWithString:strIconUrl] != nil) {
               [Downloader downloadTaskWith:[NSURL URLWithString:strIconUrl] handler:^(NSURL *destinationUrl) {//article.iconUrl
                    if(destinationUrl != nil) {
                        NSLog(@"DESTINATION FROM XML %@", destinationUrl);
//                        dispatch_async(dispatch_get_main_queue(), ^{
                            Article *article = [[Article alloc] initWithTitle:[articleObj valueForKey:kTitle] iconUrl:destinationUrl icon:[UIImage imageWithData:[NSData dataWithContentsOfURL:destinationUrl]] date:[articleObj valueForKey:kPubDate] description:artDescription link:[articleObj valueForKey:kLink] images:[articleObj valueForKey:kMediaContent] andVideoContent:[articleObj valueForKey:kVideoContent]];
                            [mutArticlse addObject:article];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(i == fetchedDataForArticles.count - 1) {
                                complitionBLock(mutArticlse.copy);
                            }
                        });
                        
//                            article.iconUrl = destinationUrl.copy;
//                            article.icon = [UIImage imageWithData:[NSData dataWithContentsOfURL:destinationUrl]];
//                        });
                        
                        
                        if(i == fetchedDataForArticles.count - 1) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTable" object:nil];
                            }); }
                    }
                }];
//                article.iconUrl = url;
            }// else {NSAssert(errno, @"article.iconUrl ====== NILLLL in downloadTaskWith Method");}
        }
            
//            [mutArticlse addObject:article];
        }
    
    return mutArticlse.copy;
}



//take url of article icon and article description (parse <description></> tag)
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
                } else if([string characterAtIndex:ch] == '<'|| [string characterAtIndex:ch] == ';') {
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
