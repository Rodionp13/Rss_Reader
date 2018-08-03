//
//  XMLParser.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 01.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@protocol RLMyDelegate

- (void) parseFetchedDataIntoArticlesObjects:(NSArray *)fetchedArticleData;
- (void) getArticlesDataAfterXMlParsing:(NSArray<Article*>*)fetchedXMlData;
@end

@interface MyXMLParser : NSObject
@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic, readonly) NSXMLParser *myXMLParser;
@property(weak, nonatomic) id <RLMyDelegate> delegate;

- (id) initWithUrl:(NSURL*)url;
@end
