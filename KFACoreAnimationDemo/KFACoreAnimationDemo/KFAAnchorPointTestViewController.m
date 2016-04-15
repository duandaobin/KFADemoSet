//
//  KFAAnchorPointTestViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFAAnchorPointTestViewController.h"
#import "NSTimer+KFAWeakUsing.h"

@interface KFAAnchorPointTestViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hourImage;
@property (weak, nonatomic) IBOutlet UIImageView *minuteImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (nonatomic, weak) NSTimer *timer;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *timeViewArr;

@end

@implementation KFAAnchorPointTestViewController

- (void)dealloc {
    [self.timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setImageViewAnchorPoint];
    [self initTimeView];
    
    @weakify(self);
    self.timer = [NSTimer kfa_scheduledTimerWithTimeInterval:1.0 block:^{
        @strongify(self);
        [self tick];
    } repeats:YES];
    
    [self tick];
}

// 设置时针、分针、秒针的anchorPoint
- (void)setImageViewAnchorPoint {
    self.hourImage.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteImage.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.secondImage.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
}

- (void)initTimeView {
    UIImage *digitImage = [UIImage imageNamed:@"num"];
    for (UIView *view in self.timeViewArr) {
        view.layer.contents = (__bridge id)digitImage.CGImage;
        view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0);
        view.layer.contentsGravity = kCAGravityResizeAspect;
        // 设置图片的拉伸过滤方式 默认kCAFilterLinear
//        view.layer.magnificationFilter = kCAFilterNearest;
    }
}

- (void)tick {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    
    CGFloat hourAngle = (components.hour/12.0)*M_PI*2.0;
    CGFloat minuteAngle = (components.minute/60.0)*M_PI*2.0;
    CGFloat secondAngle = (components.second/60.0)*M_PI*2.0;
    self.hourImage.transform = CGAffineTransformMakeRotation(hourAngle);
    self.minuteImage.transform = CGAffineTransformMakeRotation(minuteAngle);
    self.secondImage.transform = CGAffineTransformMakeRotation(secondAngle);
    
    [self setDigit:(components.hour/10) forView:self.timeViewArr[0]];
    [self setDigit:(components.hour%10) forView:self.timeViewArr[1]];
    [self setDigit:(components.minute/10) forView:self.timeViewArr[2]];
    [self setDigit:(components.minute%10) forView:self.timeViewArr[3]];
    [self setDigit:(components.second/10) forView:self.timeViewArr[4]];
    [self setDigit:(components.second%10) forView:self.timeViewArr[5]];
}

- (void)setDigit:(NSInteger)digit forView:(UIView *)view {
    view.layer.contentsRect = CGRectMake(digit*0.1, 0, 0.1, 1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
