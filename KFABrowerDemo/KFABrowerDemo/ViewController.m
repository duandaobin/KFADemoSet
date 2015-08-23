//
//  ViewController.m
//  KFABrowerDemo
//
//  Created by 柯梵Aaron on 15/8/23.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "KFAWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

// 进入凤凰首页
- (IBAction)fenghuang:(id)sender {
    NSString *urlStr = @"http://i.ifeng.com";
    KFAWebViewController *webVC = [[KFAWebViewController alloc] initWithUrlString:urlStr];
    [self.navigationController pushViewController:webVC animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
