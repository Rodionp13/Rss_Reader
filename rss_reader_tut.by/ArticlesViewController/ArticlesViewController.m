//
//  ArticlesViewController.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController.h"
#import "ArticlesViewController+Parsing_Methods.h"
#import "CDManager.h"
#import "MyXMLParser.h"

static NSString *const kCellId2 = @"myCell2";

static NSString *const kMediaContentType = @"type";
static NSString *const kMediaTypeJpeg = @"jpeg";
static NSString *const kMediaTypePng = @"png";
static NSString *const kMediaTypeMp4 = @"mp4";


@interface ArticlesViewController () <UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate, MyXMLParseDelegate, APPManagerDelegate>
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *articles;
@property(strong, nonatomic) NSMutableArray *articlesData;//test
@property(strong, nonatomic) APPManager *appManager;

//@property(strong, nonatomic) NSXMLParser *xmlParser;
@property(strong, nonatomic) NSArray *tags;
@property(strong, nonatomic) NSMutableArray *arrOfImageContent;
@property(strong, nonatomic) NSMutableArray *arrOfVideoContent;
@property(assign, nonatomic) BOOL inItem;
@property(strong, nonatomic) NSMutableDictionary *tempDict;
@property(strong, nonatomic) NSMutableString *foundValue;
@property(strong, nonatomic) NSString *currentString;

@end

@implementation ArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.articles = [[NSMutableArray alloc] init];
    self.articlesData = [[NSMutableArray alloc] init];
//    self.appManager = [[APPManager alloc] init];
//    self.appManager.delegate = self;
    
    /* это можно сдеать вместо делегата - заводим пропертю блок в appManager и потом её здесь вызываем с массивом и делаем reloadData на tableView
    self.appManager.outpt = { arr in
        self.tabelvew.kCFStringEncodingNonLossyASCII
    }
     */
    
    //tableview initialization
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:kCellId2];
    [self.view addSubview:self.tableView];
    [self setUpContraintsForTable];
    //fetching data for articles
    [self download];
}

- (void)complitionLoadingArticlesData:(NSMutableArray *)articlesData {
    self.articles = articlesData;
    [self.tableView reloadData];
}

#pragma mark - methods for table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;//self.manager.daatset  - это пропертя в appManager, и её трэкаем постоянно
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[tableView dequeueReusableCellWithIdentifier:kCellId2 forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellId2];
    Article *article = [self.articles objectAtIndex:indexPath.row];
    
//    UIImage *icon;
//    if(article.icon != nil) {
////        NSData *data = [NSData dataWithContentsOfURL:article.originalIconUrl];
////        icon = [UIImage imageWithData:data];
//    } else {
//        icon = [UIImage imageNamed:@"rss"];
//    }
    
    cell.imageView.image = article.icon;
    [cell.textLabel setText:article.title];
    [cell.detailTextLabel setText:article.articleDescr];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 7;
}

- (void)parseFetchedDataIntoArticlesObjects:(NSArray *)fetchedArticleData {
    NSArray *articles = [self parseArticlesDataIntoArticlesObjects:fetchedArticleData tableView:self.tableView];
    self.articles = [articles mutableCopy];
}




#pragma mark - method for downloading xml file to the Document directory

- (void)download {
    NSURL *myUrl = [NSURL URLWithString:self.stringUrl];

//    [Downloader downloadTaskWith:myUrl handler:^(NSURL *destinationUrl) {
//        if(destinationUrl != nil) {
//            NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:destinationUrl];
//            [xmlParser setDelegate:self];
//            if([xmlParser parse]) {
//                NSLog(@"Parse started");
//            }
//        }
//    }];
    [Downloader downloadTaskWith:myUrl handler:^(NSURL *destinationUrl) {
        MyXMLParser *parser = [[MyXMLParser alloc] initWithUrl:destinationUrl];//[NSURL URLWithString:self.stringUrl]
        parser.delegate = self;
        if(![parser.myXMLParser parse]) {NSAssert(errno, @"Some problems with parser!!!ArticleVC respone");} else {NSLog(@"PARSING STARTED ARTICEVC response");}
    }];
}
//
//#pragma mark - methods for XML-parsing
//
//- (void)parserDidStartDocument:(NSXMLParser *)parser {
//    self.tags = @[kTitle, kLink, kDescription, kPubDate];
//    self.foundValue = [[NSMutableString alloc] init];
//    self.arrOfImageContent = [[NSMutableArray alloc] init];
//    self.arrOfVideoContent = [[NSMutableArray alloc] init];
////    NSLog(@"parserDidStartDocument");
//}
//
//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
//    if([elementName isEqualToString:kItem]) {
//        self.inItem = YES;
//        self.tempDict = [[NSMutableDictionary alloc] init];
//    }
//
//    if([elementName containsString:kMediaContent] && self.inItem == YES) {
//        NSString *mediaContentType = [attributeDict valueForKey:kMediaContentType];
//        NSString *mediaContentUrl = [attributeDict valueForKey:@"url"];
//        if([mediaContentType containsString:kMediaTypeJpeg] || [mediaContentType containsString:kMediaTypePng]) {
//        [self.arrOfImageContent addObject:mediaContentUrl];
//        }
//        else if([mediaContentType containsString:kMediaTypeMp4]) {
//            [self.arrOfVideoContent addObject:mediaContentUrl];
//        }
//    }
//
//    self.currentString = elementName;
////    NSLog(@"didStartElement ---> %@", elementName);
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    for(NSString *tag in self.tags) {
//        if([self.currentString isEqualToString:tag]) {
//            NSString *trimmingStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n"]];
//                [self.foundValue appendString:trimmingStr];
//        }
//    }
////    NSLog(@"foundCharacters ---> %@", string);
//}
//
//- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
//    if([elementName isEqualToString:kItem]) {
//        NSArray *arrOfImageContent = [[NSArray alloc] initWithArray:[self.arrOfImageContent copy]];
//        NSArray *arrOfVideoContent = [[NSArray alloc] initWithArray:[self.arrOfVideoContent copy]];
//        [self.tempDict setValue:arrOfImageContent forKey:kMediaContent];
//        [self.tempDict setValue:arrOfVideoContent forKey:kVideoContent];
//
//        NSDictionary *dictToAdd = [[NSDictionary alloc] initWithDictionary:self.tempDict.copy];
//        [self.articlesData addObject:dictToAdd];
////        [self.articles addObject:dictToAdd];
//
//        [self.tempDict removeAllObjects];//?????????????????!!!!!!!!!!!!!
//        [self.arrOfImageContent removeAllObjects];
//        [self.arrOfVideoContent removeAllObjects];
//        self.inItem = NO;
//    } else {
//        for(NSString *tag in self.tags) {
//            if([elementName isEqualToString:tag]) {
//
//                NSString *strToAdd = [[NSString alloc] initWithString:self.foundValue];
//                [self.tempDict setValue:strToAdd forKey:elementName];
//            }
//        }
//    }
////    NSLog(@"didEndElement ---> %@", elementName);
//    [self.foundValue setString:@""];
//}
//
//- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    NSMutableArray *arrToPass = [NSArray arrayWithArray:self.articlesData].mutableCopy;
//    NSArray *articlesObjects = [self parseArticlesDataIntoArticlesObjects:arrToPass tableView:self.tableView];
//    self.articles = articlesObjects.mutableCopy;
//    [self.articlesData removeAllObjects];
//}

- (void)setUpContraintsForTable {
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [self.tableView.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:0];
    NSLayoutConstraint *leading = [self.tableView.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:0];
    NSLayoutConstraint *botton = [self.tableView.bottomAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.bottomAnchor multiplier:0];
    NSLayoutConstraint *trailing = [self.tableView.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.trailingAnchor multiplier:0];
    [NSLayoutConstraint activateConstraints:@[top, leading, botton, trailing]];
}




@end
