//
//  KFAShowAnimationController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/25.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFAShowAnimationController.h"

@interface KFAShowAnimationController ()

@property (nonatomic, strong) UIBezierPath *berzierPath;
@property (nonatomic, strong) CALayer *planeLayer;

@end

@implementation KFAShowAnimationController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self addBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPlaneLayer];
}

#pragma mark -
#pragma mark method

- (void)addBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((kScreenWidth-150)/2, kScreenHeight-40-40, 150, 40);
    [btn setTitle:@"transition显示" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(performTransition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake((kScreenWidth-150)/2, btn.frame.origin.y-40-40, 150, 40);
    [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
    [stopBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    stopBtn.backgroundColor = [UIColor whiteColor];
    stopBtn.layer.cornerRadius = 5;
    stopBtn.layer.masksToBounds = YES;
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBtn];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake((kScreenWidth-150)/2, stopBtn.frame.origin.y-40-40, 150, 40);
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor whiteColor];
    startBtn.layer.cornerRadius = 5;
    startBtn.layer.masksToBounds = YES;
    [startBtn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    
    UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rotateBtn.frame = CGRectMake((kScreenWidth-150)/2, startBtn.frame.origin.y-40-40, 150, 40);
    [rotateBtn setTitle:@"旋转飞机" forState:UIControlStateNormal];
    [rotateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rotateBtn.backgroundColor = [UIColor whiteColor];
    rotateBtn.layer.cornerRadius = 5;
    rotateBtn.layer.masksToBounds = YES;
    [rotateBtn addTarget:self action:@selector(rotatePlane) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rotateBtn];
}

- (void)performTransition {
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIView *coverView = [[UIImageView alloc] initWithImage:coverImage];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    
    CGFloat red = arc4random()/(CGFloat)INT_MAX;
    CGFloat green = arc4random()/(CGFloat)INT_MAX;
    CGFloat blue = arc4random()/(CGFloat)INT_MAX;
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0.01, 0.01);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        coverView.transform = transform;
        coverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [coverView removeFromSuperview];
    }];
}

- (void)addPlaneLayer {
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 150)];
    [bezierPath addLineToPoint:CGPointMake(80, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(100, 0) controlPoint2:CGPointMake(225, 300)];
    [bezierPath addLineToPoint:CGPointMake(300, 300)];
    [bezierPath addArcWithCenter:CGPointMake(175, 300) radius:125 startAngle:M_PI endAngle:0 clockwise:YES];
    [bezierPath closePath];
    self.berzierPath = bezierPath;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = self.berzierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:shapeLayer];
    
    CALayer *planeLayer = [CALayer layer];
    planeLayer.frame = CGRectMake(0, 0, 50, 50);
    planeLayer.position = CGPointMake(50, 150);
    planeLayer.contents = (__bridge id)[UIImage imageNamed:@"plane"].CGImage;
    self.planeLayer = planeLayer;
    [self.view.layer addSublayer:self.planeLayer];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -0.1/500.0;
    self.view.layer.sublayerTransform = perspective;
}

- (void)start {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.path = self.berzierPath.CGPath;
    // 让飞机头跟曲线自动对齐
    animation.rotationMode = kCAAnimationRotateAuto;
    //    animation.duration = 4.0;
    //    animation.repeatCount = 10;
    
    CABasicAnimation *colorAnimation = [CABasicAnimation animation];
    colorAnimation.keyPath = @"backgroundColor";
    colorAnimation.byValue = (__bridge id)[UIColor greenColor].CGColor;
    //    colorAnimation.toValue = (__bridge id)[UIColor yellowColor].CGColor;
    
    CABasicAnimation *scaleAnimation = [[CABasicAnimation alloc] init];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.5];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation, colorAnimation, scaleAnimation];
    group.duration = 4.0;
    group.repeatCount = 3;
    
    [self.planeLayer addAnimation:group forKey:@"fly"];
}

- (void)rotatePlane {
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(M_PI_2);
    animation.duration = 2.0;
    // repeatDuration会与repeatCount冲突
    animation.repeatDuration = INFINITY;
    // 自动回到0度
    animation.autoreverses = YES;
    [self.planeLayer addAnimation:animation forKey:@"rotation"];
}

- (void)stop {
    [self.planeLayer removeAnimationForKey:@"fly"];
    [self.planeLayer removeAnimationForKey:@"rotation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // 可以通过打印查看是否是手动终止动画
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
