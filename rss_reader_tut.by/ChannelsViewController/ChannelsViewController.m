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


@interface ChannelsViewController ()
@property(strong, nonatomic) NSMutableArray *headers;
@property(strong, nonatomic) NSMutableArray *channels;
@property(strong, nonatomic) NSMutableArray *freshNewsForAllArticles;
@property(strong, nonatomic) HTMLParser *parser;

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
    [self executeGetQuery: @"https://news.tut.by/rss.html"];
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.myTable setDelegate:self];
    [self.myTable setDataSource:self];
    [self.myTable registerClass:[FirstCell class] forCellReuseIdentifier:kCellId];
    [self.view addSubview:self.myTable];
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
    [tableView setTableHeaderView:headerView];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [lbl setBackgroundColor:UIColor.whiteColor];
    lbl.text = self.headers[section];
    return lbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UILabel alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}


- (void) executeGetQuery:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask1 = [session downloadTaskWithRequest:request];
    [downloadTask1 resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *resStr = [self copyItem:location];
    NSDictionary *channelsAndHeaders = [self.parser parseHTML:resStr];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headers = [channelsAndHeaders valueForKey:kHeaders];
        self.channels = [channelsAndHeaders valueForKey:kChannels];
        self.freshNewsForAllArticles = [channelsAndHeaders valueForKey:kFreshNews];
        [self.myTable reloadData];
    });
}

- (NSString *)copyItem:(NSURL *)location {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [urls objectAtIndex:0];
    NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
    
    NSError *err;
    [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
    if(err != nil) {
        NSLog(@"Failed to copy item\%@\%@", err, err.localizedDescription);
    }
    NSLog(@"%@", location);
    NSLog(@"%@", destinationUrl);
    NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
    NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    
    NSError *removeErr;
    [fileManager removeItemAtURL:destinationUrl error:&removeErr];
    if(removeErr != nil) {
        NSLog(@"Failed to remove item\%@\%@", removeErr, removeErr.localizedDescription);
    }
    
    
    return resStr;
}



@end
