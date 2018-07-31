//
//  ViewController.m
//  rss_reader_tut.by
//
//  Created by Radzivon Uhrynovich on 25.07.2018.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "ChannelsViewController.h"
#import "ArticlesViewController.h"
#import "AppDelegate.h"
#import "Channel.h"
#import "FirstCell.h"
#import "HTMLParser.h"
#import "Downloader.h"

static NSString *const kCellId = @"myCell";
static NSString *const kChannelsLink = @"https://news.tut.by/rss.html";

@interface ChannelsViewController ()
@property(strong, nonatomic) NSMutableArray *headers;
@property(strong, nonatomic) NSMutableArray *channels;
@property(strong, nonatomic) NSMutableArray *freshNewsForAllArticles;
@property(strong, nonatomic) HTMLParser *parser;
@property(strong, nonatomic) APPManager *appManager;

@property(strong, nonatomic) NSURL *destinationURL;
@property (strong, nonatomic) UITableView *myTable;

@end

@implementation ChannelsViewController

- (NSMutableArray*)headers {
    if(_headers != nil) {
        return _headers;
    }
    _headers = [NSMutableArray array];
    return _headers;
}

- (NSMutableArray*)channels {
    if(_channels != nil) {
        return _channels;
    }
    _channels = [NSMutableArray array];
    return _channels;
}

- (NSMutableArray*)freshNewsForAllArticles {
    if(_freshNewsForAllArticles != nil) {
        return _freshNewsForAllArticles;
    }
    _freshNewsForAllArticles = [NSMutableArray array];
    return _freshNewsForAllArticles;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"HELLOWWWWWWWWWW");
    self.parser = [[HTMLParser alloc] init];
    self.appManager = [[APPManager alloc] init];
    self.appManager.delegate = self;
//    [self executeGetQuery: @"https://news.tut.by/rss.html"];
//    [self downloadDataChannels:[NSURL URLWithString:kChannelsLink]];
    [self.appManager checkingForLoadingChennelContent];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.myTable setDelegate:self];
    [self.myTable setDataSource:self];
    [self.myTable registerClass:[FirstCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.myTable];
}

#pragma mark - APPManager delegate method(download complition)

- (void)complitionLoadingChannelsData:(NSDictionary *)channelsData {
    self.headers = [channelsData valueForKey:kHeaders];
    self.channels = [channelsData valueForKey:kChannels];
    self.freshNewsForAllArticles = [channelsData valueForKey:kFreshNews];
    [self.myTable reloadData];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channels[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    Channel *channel = [[self.channels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell configureCellWithTitleText:channel.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Channel *channel = [self.channels objectAtIndex:indexPath.section][indexPath.row];
    NSLog(@"Channel COUNT %lu", [self.channels[indexPath.section] count]);
    NSLog(@"Ind Path %@", indexPath);
    
    NSLog(@"%@", [[self.channels objectAtIndex:indexPath.section] class]);
    NSLog(@"%@", channel);
    NSString *strUrl = channel.url;
    ArticlesViewController *articleVC = [[ArticlesViewController alloc] init];
    [articleVC setStringUrl:strUrl];
    [self.navigationController pushViewController:articleVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [headerView setBackgroundColor:UIColor.grayColor];
    [headerView.layer setCornerRadius:20];
    [tableView setTableHeaderView:headerView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lbl setBackgroundColor:UIColor.whiteColor];
    [lbl.layer setCornerRadius:20];
    lbl.text = self.headers[section];
    [headerView addSubview:lbl];
    return lbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.view.frame.size.height / 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UILabel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.view.frame.size.height / 20;
}



@end

















