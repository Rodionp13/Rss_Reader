//
//  ArticlesViewController.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController.h"
#import "AppDelegate.h"

typedef  void(^myBlock)(NSData* xmlFile);

static NSString *const kItem = @"item";
static NSString *const kTitle = @"title";
static NSString *const kLink = @"link";
static NSString *const kDescription = @"description";
static NSString *const kMediaContent = @"media:content";
static NSString *const kPubDate = @"pubDate";

@interface ArticlesViewController ()
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *articles;

@property(strong, nonatomic) NSXMLParser *xmlParser;
@property(strong, nonatomic) NSArray *tags;
@property(strong, nonatomic) NSMutableArray *arrOfMediaContent;
@property(assign, nonatomic) BOOL inItem;
@property(strong, nonatomic) NSMutableDictionary *tempDict;
@property(strong, nonatomic) NSMutableString *foundValue;
@property(strong, nonatomic) NSString *currentString;
@end

@implementation ArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.articles = [[NSMutableArray alloc] init];
    self.tags = @[kTitle, kLink, kDescription, kPubDate];
    self.foundValue = [[NSMutableString alloc] init];
    self.arrOfMediaContent = [[NSMutableArray alloc] init];
    [self download];
}

- (void)download {
    NSURL *myUrl = [NSURL URLWithString:self.stringUrl];
    
    [AppDelegate downloadTaskWith:myUrl handler:^(NSURL *destinationUrl) {
        if(destinationUrl != nil) {
            self.xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:destinationUrl];
            [self.xmlParser setDelegate:self];
            if([self.xmlParser parse]) {
                NSLog(@"COMPLETE");
            } else {
                NSLog(@"Fail");
            }
            NSLog(@"%lu", self.articles.count);
            for(NSDictionary *dict in self.articles) {
                NSLog(@"DICT");
                for(NSString *key in dict.allKeys) {
                NSLog(@"%@", [dict valueForKey:key]);
                }
            }
        }
    }];
}


- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if([elementName isEqualToString:kItem]) {
        self.inItem = YES;
        self.tempDict = [[NSMutableDictionary alloc] init];
    }
    
    if([elementName isEqualToString:kMediaContent] && self.inItem == YES) {
        NSString *mediaContent = [attributeDict valueForKey:@"url"];
        [self.arrOfMediaContent addObject:mediaContent];
        NSLog(@"%@", attributeDict);
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
//    if([self.currentString isEqualToString:kTitle] || [self.currentString isEqualToString:kLink]) {
//        if(![string isEqualToString:@"\n"]) {
//        [self.foundValue appendString:string];
//        }
    }
    NSLog(@"foundCharacters ---> %@", string);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if([elementName isEqualToString:kItem]) {
        NSArray *arrOfMediaContent = [[NSArray alloc] initWithArray:[self.arrOfMediaContent copy]];
        [self.tempDict setValue:arrOfMediaContent forKey:kMediaContent];
        NSDictionary *dictToAdd = [[NSDictionary alloc] initWithDictionary:self.tempDict.copy];
        [self.articles addObject:dictToAdd];
        [self.arrOfMediaContent removeAllObjects];
        self.inItem = NO;
    } else {
        for(NSString *tag in self.tags) {
            if([elementName isEqualToString:tag]) {
                NSString *strToAdd = [[NSString alloc] initWithString:self.foundValue];
                [self.tempDict setValue:strToAdd forKey:elementName];
            }
        }
    }
//    if([elementName isEqualToString:kItem]) {
//        NSDictionary *dictToAdd = [[NSDictionary alloc] initWithDictionary:self.tempDict.copy];
//        [self.articles addObject:dictToAdd];
//    } else if([elementName isEqualToString:kTitle]) {
//        NSString *str1 = [[NSString alloc] initWithString:self.foundValue];
//        [self.tempDict setValue:str1 forKey:elementName];
//    } else if([elementName isEqualToString:kLink]) {
//        NSString *str2 = [[NSString alloc] initWithString:self.foundValue];
//        [self.tempDict setValue:str2 forKey:elementName];
//    }
    NSLog(@"didEndElement ---> %@", elementName);
    [self.foundValue setString:@""];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument");
}


@end
