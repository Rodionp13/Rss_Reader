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
#import "CDManager.h"
#import "HTMLParser.h"
#import "APPManager.h"

static NSString *const kCellId = @"myCell";
static NSString *const kChannelsLink = @"https://news.tut.by/rss.html";

@interface ChannelsViewController () <UITableViewDataSource, UITableViewDelegate, APPManagerDelegate>
@property(strong, nonatomic) NSMutableArray *headers;
@property(strong, nonatomic) NSMutableArray *channels;
@property(strong, nonatomic) NSMutableArray *freshNewsForAllArticles;
//@property(strong, nonatomic) HTMLParser *parser;
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
    self.appManager = [[APPManager alloc] init];
    self.appManager.delegate = self;
    [self.appManager checkingForLoadingChennelContent];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.myTable setDelegate:self];
    [self.myTable setDataSource:self];
    [self.myTable registerClass:[FirstCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.myTable];
    [self setUpContraintsForTable];
    
    self.navigationItem.title = @"RSS - reader" ;
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
    cell.textLabel.text = channel.name;
    cell.imageView.image = [UIImage imageNamed:@"rss"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Channel *channel = [self.channels objectAtIndex:indexPath.section][indexPath.row];
    NSString *strUrl = channel.url;
    ArticlesViewController *articleVC = [[ArticlesViewController alloc] init];
    [articleVC setStringUrl:strUrl];
    [self.navigationController pushViewController:articleVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/*
 NSLog(@"Channel COUNT %lu", [self.channels[indexPath.section] count]);
 NSLog(@"Ind Path %@", indexPath);
 
 NSLog(@"%@", [[self.channels objectAtIndex:indexPath.section] class]);
 NSLog(@"%@", channel);
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [headerView setTextAlignment:NSTextAlignmentCenter];
    [headerView setBackgroundColor:UIColor.whiteColor];
    [headerView.layer setBorderWidth:3];
    [headerView.layer setBackgroundColor:UIColor.blackColor.CGColor];
    [headerView.layer setCornerRadius:20];
    [headerView setText:self.headers[section]];
//    [tableView setTableHeaderView:headerView];
    return headerView;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.headers[section];
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.view.frame.size.height / 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UILabel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return self.view.frame.size.height / 13;
}

- (void)setUpContraintsForTable {
    [self.myTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [self.myTable.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:0];
    NSLayoutConstraint *leading = [self.myTable.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:0];
    NSLayoutConstraint *botton = [self.myTable.bottomAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.bottomAnchor multiplier:0];
    NSLayoutConstraint *trailing = [self.myTable.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.trailingAnchor multiplier:0];
    [NSLayoutConstraint activateConstraints:@[top, leading, botton, trailing]];
}



@end

















