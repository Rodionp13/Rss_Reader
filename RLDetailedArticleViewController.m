//
//  RLDetailedArticleViewController.m
//  rss_reader_tut.by
//
//  Created by User on 8/5/18.
//  Copyright © 2018 Radzivon Uhrynovich. All rights reserved.
//

#import "RLDetailedArticleViewController.h"
#import "APPManager.h"

@interface RLDetailedArticleViewController () <APPManagerDelegate>

@property(strong, nonatomic) NSArray *images;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIView *contentView;
@property(strong, nonatomic) UILabel *detailedLabel;
@end

@implementation RLDetailedArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *descr;
    if([self.article.articleDescr isEqualToString: @"NO Description"]) {descr = self.article.title;}else{descr=self.article.articleDescr;}
    self.detailedLabel = [self createDetailedLabel:descr];
    self.scrollView = [self createScrollViewWithContentView];
    self.contentView = [self createContentView];
    UIImageView *placeholder = [self createPlaceHolderView:self.contentView scrollView:self.scrollView];
    
    APPManager *appManager = [[APPManager alloc] init];
    appManager.delegate = self;
    [appManager checkingForLoadingNews:self.article complition:^(NSMutableArray *images) {
            [placeholder removeFromSuperview];
            self.images = images.copy;
            [self constraitnsToContentView];
            [self prepareArticleContent:self.images scrollView:self.scrollView];
    }];
}

- (void)prepareArticleContent:(NSArray*)images scrollView:(UIScrollView*)scrollView {
    NSMutableArray *imageItems = [NSMutableArray array];
    UIImageView *prevImgView;   UIImageView *imgView;
    NSLayoutConstraint *top; NSLayoutConstraint *lead; NSLayoutConstraint *trail;NSLayoutConstraint *height;
    UILayoutGuide *safe = self.contentView.safeAreaLayoutGuide;
    for(int idx = 0; idx < images.count; idx++) {
        if(imageItems.count > 0) {prevImgView = imageItems[idx - 1];}
        imgView = [self getmyImageView:images[idx]];
        if(idx == 0) {
            top = [imgView.topAnchor constraintEqualToAnchor:safe.topAnchor constant:0];
        } else {top = [imgView.topAnchor constraintEqualToAnchor:prevImgView.bottomAnchor constant:0];}
        lead = [imgView.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:0];
        trail = [imgView.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:0];
        height = [imgView.heightAnchor constraintEqualToAnchor:scrollView.safeAreaLayoutGuide.heightAnchor multiplier:1];
        [NSLayoutConstraint activateConstraints:@[top,lead,trail,height]];
        [imageItems addObject:imgView];
    }
}

- (UIImageView*)getmyImageView:(NSURL*)url {
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:url]]];
    imgView.clipsToBounds = YES;
    [self.contentView addSubview:imgView];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    return imgView;
}


- (UIScrollView*)createScrollViewWithContentView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [scrollView.layer setBorderWidth:1]; [scrollView.layer setBorderColor:UIColor.blackColor.CGColor];
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    [self setupConstraintsToScrollView:scrollView];
    return scrollView;
}

- (void)setupConstraintsToScrollView:(UIScrollView*)scrollView {
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    NSLayoutConstraint *top = [scrollView.topAnchor constraintEqualToAnchor:self.detailedLabel.bottomAnchor constant:20];
    NSLayoutConstraint *leading = [scrollView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:8];
    NSLayoutConstraint *trailing = [scrollView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-8];
    NSLayoutConstraint *bottom = [scrollView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-8];
    [NSLayoutConstraint activateConstraints:@[top,leading,trailing, bottom]];
}

- (UIView*)createContentView {
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:contentView];
    return contentView;
}

- (void)constraitnsToContentView {
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:0];
    NSLayoutConstraint *lead = [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:0];
    NSLayoutConstraint *trail = [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:0];
    NSLayoutConstraint *bottom = [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:0];
    NSLayoutConstraint *centerX = [self.contentView.centerXAnchor constraintEqualToAnchor:self.scrollView.centerXAnchor];
    NSLayoutConstraint *height = [self.contentView.heightAnchor constraintEqualToAnchor:self.scrollView.heightAnchor multiplier:self.images.count constant:0];
    [NSLayoutConstraint activateConstraints:@[top,lead,trail,bottom, centerX, height]];
}

- (UILabel*)createDetailedLabel:(NSString*)text {
    UILabel *detailedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [detailedLabel.layer setBorderWidth:1]; [detailedLabel.layer setBorderColor:UIColor.blackColor.CGColor];
    [detailedLabel setTextAlignment:NSTextAlignmentCenter];
    [detailedLabel setNumberOfLines:0];
    detailedLabel.text = text;
    [self.view addSubview:detailedLabel];
    [self setUpLabelConstraint:detailedLabel];
    return detailedLabel;
}

- (void)setUpLabelConstraint:(UILabel*)detailedLabel {
    detailedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    NSLayoutConstraint *top = [detailedLabel.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:8];
    NSLayoutConstraint *leading = [detailedLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:8];
    NSLayoutConstraint *trailing = [detailedLabel.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-8];
    NSLayoutConstraint *height = [detailedLabel.heightAnchor constraintEqualToAnchor:safeArea.heightAnchor multiplier:0.1];
    [NSLayoutConstraint activateConstraints:@[top,leading,trailing,height]];
}

- (UIImageView*)createPlaceHolderView:(UIView*)contentView scrollView:(UIScrollView*)scrollView {
    UIImageView *placeholder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rss"]];
    [contentView addSubview:placeholder];
    [self constraintToPlaceholderView:placeholder scrollView:scrollView];
    return placeholder;
}

- (void)constraintToPlaceholderView:(UIView*)placeholder scrollView:(UIScrollView*)scrollView {
    placeholder.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *safe = scrollView.safeAreaLayoutGuide;
    NSLayoutConstraint *centerX = [placeholder.centerXAnchor constraintEqualToAnchor:safe.centerXAnchor constant:0];
    NSLayoutConstraint *centerY = [placeholder.centerYAnchor constraintEqualToAnchor:safe.centerYAnchor constant:0];
    NSLayoutConstraint *height = [placeholder.heightAnchor constraintEqualToAnchor:safe.heightAnchor multiplier:0.2];
    NSLayoutConstraint *width = [placeholder.widthAnchor constraintEqualToAnchor:safe.widthAnchor multiplier:0.2];
    [NSLayoutConstraint activateConstraints:@[centerX,centerY,width,height]];
}


#pragma mark - APPManager delegate method(download complition)
- (void)userAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wait" message:@"There'is no internet connection and no data in store!!!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okey" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        NSLog(@"OKEY");
    }];
}

@end
