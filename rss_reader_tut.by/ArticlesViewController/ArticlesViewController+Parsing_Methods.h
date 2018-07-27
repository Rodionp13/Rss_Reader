//
//  ArticlesViewController+Parsing_Methods.h
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 27.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController.h"

@interface ArticlesViewController (Parsing_Methods)

- (NSArray *)parseArticlesDataIntoArticlesObjects:(NSMutableArray *)fetchedDataForArticles;
@end
