//
//  MyXMLParser+MyXMLParserTypeConvertingMethods.h
//  rss_reader_tut.by
//
//  Created by User on 8/2/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "MyXMLParser.h"
#import "Article.h"

@interface MyXMLParser (MyXMLParserTypeConvertingMethods)

- (NSArray<Article*>*)parseArticlesDataIntoArticlesObjects:(NSArray *)fetchedDataForArticles withComplition:(void(^)(NSArray*myRes))complitionBLock;
@end
