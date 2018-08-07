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
    self.navigationItem.title = @"RSS - reader";
    
    self.appManager = [[APPManager alloc] init];
    self.appManager.delegate = self;
    [self.appManager checkingForLoadingChennelContent];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.myTable setDelegate:self];
    [self.myTable setDataSource:self];
    [self.myTable registerClass:[FirstCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.myTable];
    [self setUpContraintsForTable];
}

#pragma mark - APPManager delegate method(download complition)

- (void)complitionLoadingChannelsData:(NSDictionary *)channelsData {
    self.headers = [channelsData valueForKey:kHeaders];
    self.channels = [channelsData valueForKey:kChannels];
    self.freshNewsForAllArticles = [channelsData valueForKey:kFreshNews];
    [self.myTable reloadData];
}

- (void)userAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wait" message:@"There'is no internet connection and no data in store!!!\nPlease switch on connection and reload App" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"OKEY");
    }];
}

#pragma mark - TableView methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headers.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.channels[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    Channel *channel = [[self.channels objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell configureCellImage];
    cell.textLabel.text =  channel.name;
    cell.separatorInset = UIEdgeInsetsMake(0, 50, 0, 0);
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [headerView setTextAlignment:NSTextAlignmentCenter];
    [headerView setBackgroundColor:UIColor.lightGrayColor];
    [headerView.layer setBorderWidth:2];
    [headerView.layer setBackgroundColor:UIColor.blackColor.CGColor];
    [headerView setText:self.headers[section]];
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.view.frame.size.height / 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UILabel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        return self.view.frame.size.height / 20;
}



#pragma mark - constraints

- (void)setUpContraintsForTable {
    [self.myTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *top = [self.myTable.topAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.topAnchor multiplier:0];
    NSLayoutConstraint *leading = [self.myTable.leadingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.leadingAnchor multiplier:0];
    NSLayoutConstraint *botton = [self.myTable.bottomAnchor constraintEqualToSystemSpacingBelowAnchor:self.view.safeAreaLayoutGuide.bottomAnchor multiplier:0];
    NSLayoutConstraint *trailing = [self.myTable.trailingAnchor constraintEqualToSystemSpacingAfterAnchor:self.view.safeAreaLayoutGuide.trailingAnchor multiplier:0];
    [NSLayoutConstraint activateConstraints:@[top, leading, botton, trailing]];
}



@end

















