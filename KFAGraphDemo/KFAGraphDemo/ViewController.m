//
//  ViewController.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/6.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "KFAGraphView.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *graphAarr;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    KFAGraphView *graphView = [[KFAGraphView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 332.5)];
    graphView.backgroundColor = [UIColor clearColor];
    graphView.dataArr = self.graphAarr;
    [self.view addSubview:graphView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)graphAarr {
    if (!_graphAarr) {
        NSString *timeStr1 = @"2016-04-06 14:46:59";
        NSString *timeStr2 = @"2016-04-06 14:46:54";
        NSString *timeStr3 = @"2016-04-05 08:35:54";
        NSString *timeStr4 = @"2016-04-05 08:35:49";
        NSString *timeStr5 = @"2016-04-04 04:42:07";
        NSString *timeStr6 = @"2016-04-03 06:52:51";
        NSString *timeStr7 = @"2016-03-31 20:01:13";
        _graphAarr = @[timeStr1,timeStr2,timeStr3,timeStr4,timeStr5,timeStr6,timeStr7];
    }
    return _graphAarr;
}

@end
