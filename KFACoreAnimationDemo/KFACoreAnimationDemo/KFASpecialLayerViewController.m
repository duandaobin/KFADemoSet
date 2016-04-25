//
//  KFASpecialLayerViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/19.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFASpecialLayerViewController.h"
#import <CoreText/CoreText.h>
#import "AppDelegate.h"

@interface KFASpecialLayerViewController ()

@end

@implementation KFASpecialLayerViewController

- (void)dealloc {
    // 恢复不让横屏
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    dele.isAllowRotaion = NO;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self addShapeLayer];
//    [self addRoundLayer];
    
//    [self addTextLayer];
    
//    [self addCube];
    
//    [self addGradientColor];
    
//    [self addReplicatorView];
    
    [self addEmitterLayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 允许横屏
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    dele.isAllowRotaion = YES;
}

#pragma mark -
#pragma mark 

- (void)addEmitterLayer {
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:emitterLayer];
    
    // 配置发射体
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    emitterLayer.emitterPosition = CGPointMake(emitterLayer.frame.size.width/2.0, emitterLayer.frame.size.height/2.0);
    
    // 创造粒子模板
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"emitter"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1.0 green:0.5 blue:1.0 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI*2.0;
    
    emitterLayer.emitterCells = @[cell];
}

- (void)addReplicatorView {
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer addSublayer:replicatorLayer];
    
    // 设定重复次数
    replicatorLayer.instanceCount = 10;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 10, 0);
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1);
//    transform = CATransform3DTranslate(transform, 0, -10, 0);
    // 注意是instanceTransform 不是transform
    replicatorLayer.instanceTransform = transform;
    
    replicatorLayer.instanceBlueOffset = -0.1;
    replicatorLayer.instanceGreenOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    UIImage *image = [UIImage imageNamed:@"animationPic"];
    layer.contents = (__bridge id)image.CGImage;
    
    [replicatorLayer addSublayer:layer];
}

- (void)addGradientColor {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(50, 100, 200, 200);
    [self.view.layer addSublayer:gradientLayer];
    
    // 设置颜色
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor orangeColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor, (__bridge id)[UIColor blackColor].CGColor, (__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor purpleColor].CGColor];
    // 设置颜色的位置 数组的个数必须和颜色的个数一样
    gradientLayer.locations = @[@0.0, @0.14, @0.28, @0.42, @0.56, @0.7, @0.84];
    
    // 设置起点和终点
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1); // CGPointMake(1, 0);
}

- (void)addCube {
    
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0/500;
    self.view.layer.sublayerTransform = pt;
    
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, 0, -100, 0);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 0, 100, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cube2];
}

- (CALayer *)faceWithTransform:(CATransform3D)transform {
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    
    CGFloat red = (rand()/(double)INT_MAX);
    CGFloat green = (rand()/(double)INT_MAX);
    CGFloat blue = (rand()/(double)INT_MAX);
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0].CGColor;
    
    face.transform = transform;
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)transform {
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    cube.position = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    
    cube.transform = transform;
    return cube;
}

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
