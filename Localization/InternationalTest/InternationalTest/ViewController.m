//
//  ViewController.m
//  InternationalTest
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "InternationalControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:@"changeLanguage" object:nil];
    
    [InternationalControl initUserLanguage];
    
    NSBundle *bundle = [InternationalControl bundle];
    
    NSString *titleN = [bundle localizedStringForKey:@"titleName" value:nil table:@"KfaLanguage"];
    
    _titleName.text = titleN;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeLanguage:(id)sender {
    if ([[InternationalControl userLanguage] isEqualToString:@"en"]) {
        [InternationalControl setUserLanguage:@"zh-Hans"];
    }else {
        [InternationalControl setUserLanguage:@"en"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
}

- (void)changeLanguage{
    _titleName.text = [[InternationalControl bundle] localizedStringForKey:@"titleName" value:nil table:@"KfaLanguage"];
}

@end
