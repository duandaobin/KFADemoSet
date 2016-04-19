//
//  KFASpecialLayerViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/19.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFASpecialLayerViewController.h"
#import <CoreText/CoreText.h>

@interface KFASpecialLayerViewController ()

@end

@implementation KFASpecialLayerViewController

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self addShapeLayer];
//    [self addRoundLayer];
    
    [self addTextLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark 

- (void)addTextLayer {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    [self.view addSubview:label];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = label.bounds;
    // 防止像素化
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [label.layer addSublayer:textLayer];
    
//    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
//    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
//    textLayer.font = fontRef;
//    textLayer.fontSize = font.pointSize;
//    CGFontRelease(fontRef);
    
    NSString *_string = @"从事iOS开发工作 一个喜欢吉他、京剧、小说、相声、摄影的文艺骚年 一个喜欢篮球、羽毛球、健身、慢跑、爬山的运动狂人 一个喜欢美色、美景的贪痴之人";
    
    NSMutableAttributedString *string = nil;
    string = [[NSMutableAttributedString alloc] initWithString:_string];
    
    CGFloat fontSize = font.pointSize;
    CTFontRef fontRef = CTFontCreateWithName(fontName, fontSize, NULL);
    
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef};
    [string setAttributes:attribs range:NSMakeRange(0, _string.length)];
    
    attribs = @{
                (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor,
                (__bridge id)kCTUnderlineStyleAttributeName:@(kCTUnderlineStyleSingle),
                (__bridge id)kCTFontAttributeName:(__bridge id)fontRef};
    [string setAttributes:attribs range:NSMakeRange(2, 3)];
    CFRelease(fontRef);
    
    textLayer.string = string;
    
}

- (void)addShapeLayer {
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    // 画圆
    [path moveToPoint:CGPointMake(175, 100)];
    [path addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:2*M_PI clockwise:YES];
    // 一竖一撇
    [path moveToPoint:CGPointMake(150, 125)];
    [path addLineToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(125, 225)];
    // 一捺
    [path moveToPoint:CGPointMake(150, 175)];
    [path addLineToPoint:CGPointMake(175, 225)];
    // 一横
    [path moveToPoint:CGPointMake(100, 150)];
    [path addLineToPoint:CGPointMake(200, 150)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

- (void)addRoundLayer {
    CGRect rect = CGRectMake(100, 250, 100, 100);
    CGSize redii = CGSizeMake(20, 50);
    UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerBottomLeft;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:redii];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor greenColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
