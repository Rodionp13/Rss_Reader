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
    [self downloadDataChannels:[NSURL URLWithString:kChannelsLink]];
    
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

- (void)downloadDataChannels:(NSURL *)url {
//    [self downloadTaskWith:url handler:^(NSURL *destinationUrl) {
//        if(destinationUrl != nil) {
//        NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
//        NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSDictionary *channelsAndHeaders = [self.parser parseHTML:resString];
//        [self removeItem:destinationUrl];
    [Downloader downloadTaskWith:url handler:^(NSURL *destinationUrl) {
        if(destinationUrl != nil) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:destinationUrl];
            NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *channelsAndHeaders = [self.parser parseHTML:resString];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.headers = [channelsAndHeaders valueForKey:kHeaders];
                self.channels = [channelsAndHeaders valueForKey:kChannels];
                self.freshNewsForAllArticles = [channelsAndHeaders valueForKey:kFreshNews];
                [self.myTable reloadData];
            });
        } else {NSAssert(errno, @"Failed to load channels");}
    }];
    
        //complition
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.headers = [channelsAndHeaders valueForKey:kHeaders];
//            self.channels = [channelsAndHeaders valueForKey:kChannels];
//            self.freshNewsForAllArticles = [channelsAndHeaders valueForKey:kFreshNews];
//            [self.myTable reloadData];
//        });
//        } else {NSAssert(errno, @"Failed to load channels");}
//    }];
}

//- (void)downloadTaskWith:(NSURL *)url handler:(void(^)(NSURL *destinationUrl))complition {
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    [request setHTTPMethod:@"GET"];
//
//    NSURLSession *session = [NSURLSession sharedSession];
//
//    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        if(location != nil) {
//            NSURL *destinationUrl = [self copyItem:location];
//            complition(destinationUrl);
//        } else {
//            complition(nil);
//        }
//
//    }];
//    [downloadTask resume];
//}
//
//- (NSURL*)copyItem:(NSURL *)location {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
//    NSURL *documentsDirectory = [urls objectAtIndex:0];
//    NSURL *originalUrl = [NSURL URLWithString:[location lastPathComponent]];
//    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:[originalUrl lastPathComponent]];
//
//    NSError *err;
//    [fileManager copyItemAtURL:location toURL:destinationUrl error:&err];
//    if(err != nil) {
//        NSLog(@"Failed to copy item\%@\%@", err, err.localizedDescription);
//    }
//    NSLog(@"%@", location);
//    NSLog(@"%@", destinationUrl);
//
//    return destinationUrl;
//}
//
//- (BOOL)removeItem:(NSURL*)location {
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSError *removeErr;
//    [fm removeItemAtURL:location error:&removeErr];
//    if(removeErr != nil) {
//        NSLog(@"Failed to remove item\%@\%@", removeErr, removeErr.localizedDescription);
//        return NO;
//    }
//    return YES;
//}



@end


//- (void) executeGetQuery:(NSString *)urlString {
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"GET"];
//
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    NSURLSessionDownloadTask *downloadTask1 = [session downloadTaskWithRequest:request];
//    [downloadTask1 resume];
//}

//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//
//    NSString *resStr = [self copyItem:location];
//    NSDictionary *channelsAndHeaders = [self.parser parseHTML:resStr];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.headers = [channelsAndHeaders valueForKey:kHeaders];
//        self.channels = [channelsAndHeaders valueForKey:kChannels];
//        self.freshNewsForAllArticles = [channelsAndHeaders valueForKey:kFreshNews];
//        [self.myTable reloadData];
//    });
//}

















