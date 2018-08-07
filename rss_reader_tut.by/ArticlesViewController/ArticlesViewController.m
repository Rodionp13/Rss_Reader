//
//  ArticlesViewController.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ArticlesViewController.h"
#import "CDManager.h"
#import "MyXMLParser.h"

static NSString *const kCellId2 = @"myCell2";

static NSString *const kMediaContentType = @"type";
static NSString *const kMediaTypeJpeg = @"jpeg";
static NSString *const kMediaTypePng = @"png";
static NSString *const kMediaTypeMp4 = @"mp4";


@interface ArticlesViewController () <UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate, APPManagerDelegate>
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
    self.appManager = [[APPManager alloc] init];
    self.appManager.delegate = self;
    [self.appManager checkingForLoadingArticleContent:[NSURL URLWithString:self.stringUrl]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:@"updateTable" object:nil];
    
    //tableview initialization
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ArticleCell class] forCellReuseIdentifier:kCellId2];
    [self.view addSubview:self.tableView];
    [self setUpContraintsForTable];
}


#pragma mark - APPManager delegate method(download complition)

- (void)complitionLoadingArticlesData:(NSMutableArray *)articlesData {
    self.articles = articlesData;
    [self.tableView reloadData];
}
- (void)updateTable {
    [self.tableView reloadData];
}

- (void)userAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wait" message:@"There'is no internet connection and no data in store!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - methods for table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [[tableView dequeueReusableCellWithIdentifier:kCellId2 forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellId2];
    Article *article = [self.articles objectAtIndex:indexPath.row];
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:article.iconUrl]];
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    cell.imageView.image = img;
    [cell.textLabel setText:article.title];
    [cell.detailTextLabel setText:article.date];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height / 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Article *article = self.articles[indexPath.row];
    RLDetailedArticleViewController *detailedVC = [[RLDetailedArticleViewController alloc] init];
    detailedVC.article = article;
    [self.navigationController pushViewController:detailedVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setUpContraintsForTable {
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [self.tableView.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:0];
    NSLayoutConstraint *leading = [self.tableView.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:0];
    NSLayoutConstraint *botton = [self.tableView.bottomAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.bottomAnchor multiplier:0];
    NSLayoutConstraint *trailing = [self.tableView.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.trailingAnchor multiplier:0];
    [NSLayoutConstraint activateConstraints:@[top, leading, botton, trailing]];
}

@end
