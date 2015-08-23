//
//  KFAWebViewController.m
//  KFABrowerDemo
//
//  Created by 柯梵Aaron on 15/8/23.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAWebViewController.h"

@interface KFAWebViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation KFAWebViewController
- (instancetype)initWithUrlString:(NSString *)urlString{
    if (self = [super init]) {
        self.urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStylePlain target:self action:@selector(webViewBackward:)];
    self.navigationItem.leftBarButtonItem = item;
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
   
}

// 网页后退
- (void)webViewBackward:(UIBarButtonItem *)item{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
