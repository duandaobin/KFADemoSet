//
//  KFABufferAnimationController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/26.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFABufferAnimationController.h"

@interface KFABufferAnimationController ()

@property (nonatomic, strong) UIImageView *ballView;

@end

@implementation KFABufferAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBallViews];
    [self animate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animate];
}

#pragma mark -
#pragma mark methods

- (void)addBallViews {
    
    UIImage *image = [UIImage imageNamed:@"emitter"];
    self.ballView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:self.ballView];
}

- (void)animate {
    
    CGFloat x = kScreenWidth/2.0;
    self.ballView.center = CGPointMake(x, 32);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.delegate = self;
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(x, 32)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 140)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 220)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 268)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 250)],
                         [NSValue valueWithCGPoint:CGPointMake(x, 268)]];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    animation.keyTimes = @[@0.0, @0.3, @0.5, @0.7, @0.8, @0.9, @0.95, @1.0];
    self.ballView.layer.position = CGPointMake(x, 268);
    [self.ballView.layer addAnimation:animation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
