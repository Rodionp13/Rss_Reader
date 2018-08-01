//
//  XMLParser.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 01.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyXMLParseDelegate
- (void) parseFetchedDataIntoArticlesObjects:(NSArray *)fetchedArticleData;

@end

@interface MyXMLParser : NSObject
@property(strong, nonatomic) NSURL *url;
@property(strong, nonatomic, readonly) NSXMLParser *myXMLParser;
@property(weak, nonatomic) id <MyXMLParseDelegate> delegate;

- (id) initWithUrl:(NSURL*)url;
@end
