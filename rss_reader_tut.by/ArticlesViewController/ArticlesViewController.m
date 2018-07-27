//
//  ArticlesViewController.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController.h"
#import "ArticlesViewController+Parsing_Methods.h"

static NSString *const kCellId2 = @"myCell2";

static NSString *const kMediaContentType = @"type";
static NSString *const kMediaTypeJpeg = @"jpeg";
static NSString *const kMediaTypePng = @"png";
static NSString *const kMediaTypeMp4 = @"mp4";


@interface ArticlesViewController ()
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *articles;

@property(strong, nonatomic) NSXMLParser *xmlParser;
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
    
    //tableview initialization
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:kCellId2];
    [self.view addSubview:self.tableView];
    
    //fetching data for articles
    [self download];
}

#pragma mark - methods for table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[tableView dequeueReusableCellWithIdentifier:kCellId2 forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellId2];
    Article *article = [self.articles objectAtIndex:indexPath.row];
    
    [AppDelegate downloadTaskWith:article.iconUrl handler:^(NSURL *destinationUrl) {
        NSData *dataImg = [[NSData alloc] initWithContentsOfURL:destinationUrl];
        UIImage *imgNew = [[UIImage alloc] initWithData:dataImg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:imgNew];
        });
        
    }];
    
    [cell.textLabel setText:[article.originalIconUrl lastPathComponent]];
    [cell.detailTextLabel setText:article.date];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 15;
}




#pragma mark - method for downloading xml file to the Document directory

- (void)download {
    NSURL *myUrl = [NSURL URLWithString:self.stringUrl];

    [AppDelegate downloadTaskWith:myUrl handler:^(NSURL *destinationUrl) {
        if(destinationUrl != nil) {
            self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:destinationUrl];
            [self.xmlParser setDelegate:self];
            if([self.xmlParser parse]) {
                NSLog(@"COMPLETE");
            }
//            else {
//                NSLog(@"Fail");
//            }
//            NSLog(@"%lu", self.articles.count);
//            for(Article *art in self.articles) {
//                NSLog(@"%@", [art description]);
//            }
        }
    }];
}

#pragma mark - methods for XML-parsing

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.tags = @[kTitle, kLink, kDescription, kPubDate];
    self.foundValue = [[NSMutableString alloc] init];
    self.arrOfImageContent = [[NSMutableArray alloc] init];
    self.arrOfVideoContent = [[NSMutableArray alloc] init];
    NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if([elementName isEqualToString:kItem]) {
        self.inItem = YES;
        self.tempDict = [[NSMutableDictionary alloc] init];
    }
    
    if([elementName containsString:kMediaContent] && self.inItem == YES) {
        NSString *mediaContentType = [attributeDict valueForKey:kMediaContentType];
        NSString *mediaContentUrl = [attributeDict valueForKey:@"url"];
        if([mediaContentType containsString:kMediaTypeJpeg] || [mediaContentType containsString:kMediaTypePng]) {
        [self.arrOfImageContent addObject:mediaContentUrl];
        }
        else if([mediaContentType containsString:kMediaTypeMp4]) {
            [self.arrOfVideoContent addObject:mediaContentUrl];
        }
    }
    
    self.currentString = elementName;
    NSLog(@"didStartElement ---> %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    for(NSString *tag in self.tags) {
        if([self.currentString isEqualToString:tag]) {
            NSString *trimmingStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n"]];
                [self.foundValue appendString:trimmingStr];
        }
    }
    NSLog(@"foundCharacters ---> %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:kItem]) {
        NSArray *arrOfImageContent = [[NSArray alloc] initWithArray:[self.arrOfImageContent copy]];
        NSArray *arrOfVideoContent = [[NSArray alloc] initWithArray:[self.arrOfVideoContent copy]];
        [self.tempDict setValue:arrOfImageContent forKey:kMediaContent];
        [self.tempDict setValue:arrOfVideoContent forKey:kVideoContent];
        
        NSDictionary *dictToAdd = [[NSDictionary alloc] initWithDictionary:self.tempDict.copy];
        [self.articles addObject:dictToAdd];
        
        [self.arrOfImageContent removeAllObjects];
        [self.arrOfVideoContent removeAllObjects];
        self.inItem = NO;
    } else {
        for(NSString *tag in self.tags) {
            if([elementName isEqualToString:tag]) {
                
                NSString *strToAdd = [[NSString alloc] initWithString:self.foundValue];
                [self.tempDict setValue:strToAdd forKey:elementName];
            }
        }
    }
    NSLog(@"didEndElement ---> %@", elementName);
    [self.foundValue setString:@""];
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSArray *articlesObjects = [self parseArticlesDataIntoArticlesObjects:self.articles];
    [self setArticles:articlesObjects.mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    NSLog(@"parserDidEndDocument");
}




@end
