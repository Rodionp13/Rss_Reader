//
//  XMLParser.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 01.08.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "MyXMLParser.h"
#import "MyXMLParser+MyXMLParserTypeConvertingMethods.h"

static NSString *const kItem = @"item";
static NSString *const kTitle = @"title";
static NSString *const kLink = @"link";
static NSString *const kDescription = @"description";
static NSString *const kMediaContent = @"media:content";
static NSString *const kPubDate = @"pubDate";
static NSString *const kVideoContent = @"video";

static NSString *const kMediaContentType = @"type";
static NSString *const kMediaTypeJpeg = @"jpeg";
static NSString *const kMediaTypePng = @"png";
static NSString *const kMediaTypeMp4 = @"mp4";

@interface MyXMLParser() <NSXMLParserDelegate>
@property(strong, nonatomic, readwrite) NSXMLParser *myXMLParser;
@property(strong, nonatomic) NSMutableArray *articlesData;//test

@property(strong, nonatomic) NSArray *tags;
@property(strong, nonatomic) NSMutableArray *arrOfImageContent;
@property(strong, nonatomic) NSMutableArray *arrOfVideoContent;
@property(assign, nonatomic) BOOL inItem;
@property(strong, nonatomic) NSMutableDictionary *tempDict;
@property(strong, nonatomic) NSMutableString *foundValue;
@property(strong, nonatomic) NSString *currentString;
@end

@implementation MyXMLParser

- (id)initWithUrl:(NSURL *)url {
    self = [super init];
    
    if(self) {
        _url = url;
        _myXMLParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [_myXMLParser setDelegate:self];
    }
    return self;
}

#pragma mark - methods for XML-parsing

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.articlesData = [[NSMutableArray alloc] init];
    self.tags = @[kTitle, kLink, kDescription, kPubDate];
    self.foundValue = [[NSMutableString alloc] init];
    self.arrOfImageContent = [[NSMutableArray alloc] init];
    self.arrOfVideoContent = [[NSMutableArray alloc] init];
    //    NSLog(@"parserDidStartDocument");
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
    //    NSLog(@"didStartElement ---> %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    for(NSString *tag in self.tags) {
        if([self.currentString isEqualToString:tag]) {
            NSString *trimmingStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n"]];
            [self.foundValue appendString:trimmingStr];
        }
    }
    //    NSLog(@"foundCharacters ---> %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:kItem]) {
        NSArray *arrOfImageContent = [[NSArray alloc] initWithArray:[self.arrOfImageContent copy]];
        NSArray *arrOfVideoContent = [[NSArray alloc] initWithArray:[self.arrOfVideoContent copy]];
        [self.tempDict setValue:arrOfImageContent forKey:kMediaContent];
        [self.tempDict setValue:arrOfVideoContent forKey:kVideoContent];
        
        NSDictionary *dictToAdd = [[NSDictionary alloc] initWithDictionary:self.tempDict.copy];
        [self.articlesData addObject:dictToAdd];
        //        [self.articles addObject:dictToAdd];
        
        [self.tempDict removeAllObjects];//?????????????????!!!!!!!!!!!!!
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
    //    NSLog(@"didEndElement ---> %@", elementName);
    [self.foundValue setString:@""];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSArray *arrToParse = [NSArray arrayWithArray:self.articlesData];
//    [self.delegate parseFetchedDataIntoArticlesObjects:arrToParse];//Delegate of ArticleVC
    NSArray<Article*> *articlesObjects = [self parseArticlesDataIntoArticlesObjects:arrToParse withComplition:^(NSArray *myRes) {
        [self.delegate getArticlesDataAfterXMlParsing:myRes];
    }];
    
    //AppMAnager Delegate TEST
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.delegate getArticlesDataAfterXMlParsing:articlesObjects];
//    });
//    NSArray *articlesObjects = [self parseArticlesDataIntoArticlesObjects:arrToPass tableView:self.tableView];
//    self.articles = articlesObjects.mutableCopy;
    
    [self.articlesData removeAllObjects];
}


@end
