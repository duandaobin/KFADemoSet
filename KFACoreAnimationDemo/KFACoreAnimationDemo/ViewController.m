//
//  ViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/13.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "KFAAnchorPointTestViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UIView *rightTopView;
@property (weak, nonatomic) IBOutlet UIView *leftDownView;
@property (weak, nonatomic) IBOutlet UIView *rightDownView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBlueLayer];
    [self setLayerViewBackgroudImage];
    [self seperateImageToFourView];
    [self addAnotherBlueLayer];
}

#pragma mark -
#pragma mark CALayerDelegate

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

#pragma mark -
#pragma mark method

- (void)goToAnchorPointTestView:(id)sender {
    KFAAnchorPointTestViewController *anchorPointTestVC = [[KFAAnchorPointTestViewController alloc] init];
    [self.navigationController pushViewController:anchorPointTestVC animated:YES];
}

// 自定义绘画
- (void)addAnotherBlueLayer {
    CALayer *blueLayer = [CALayer layer];
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    // 设置代理
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layerView.layer addSublayer:blueLayer];
    // 强制重绘 以便调动代理方法, 不同于UIView，图层显示在屏幕上时，CALayer不会自动重绘它的内容
    [blueLayer display];
}

- (void)addImage:(UIImage *)image withRect:(CGRect)rect toLayer:(CALayer *)layer {
    layer.contents = (__bridge id)image.CGImage;
    layer.contentsGravity = kCAGravityResizeAspect;
    // contentsRect默认为{0,0,1,1}，即展示全部内容
    layer.contentsRect = rect;
}

- (void)addImage:(UIImage *)image  withContentsCenter:(CGRect)rect toLayer:(CALayer *)layer {
    layer.contents = (__bridge id)image.CGImage;
    // contentsCenter默认为{0,0,1,1}
    layer.contentsCenter = rect;
}

// 把图片分成四份并分别在四个view上面显示
- (void)seperateImageToFourView {
    UIImage *image = [UIImage imageNamed:@"animationPic"];
//    [self addImage:image withRect:CGRectMake(0, 0, 0.5, 0.5) toLayer:self.leftTopView.layer];
    [self addImage:image withContentsCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.leftTopView.layer];
    [self addImage:image withRect:CGRectMake(0.5, 0, 0.5, 0.5) toLayer:self.rightTopView.layer];
    [self addImage:image withRect:CGRectMake(0, 0.5, 0.5, 0.5) toLayer:self.leftDownView.layer];
//    [self addImage:image withRect:CGRectMake(0.5, 0.5, 0.5, 0.5) toLayer:self.rightDownView.layer];
    [self addImage:image withContentsCenter:CGRectMake(0.25, 0.25, 0.5, 0.5) toLayer:self.rightDownView.layer];
}

// 设置图层的寄宿图
- (void)setLayerViewBackgroudImage {
    UIImage *image = [UIImage imageNamed:@"animationPic"];
    self.layerView.layer.contents = (__bridge id)(image.CGImage);
    
    // 相当于设置UIView的contentMode
//    self.layerView.layer.contentsGravity = kCAGravityResizeAspect;
    
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    
    // contentsScale属性定义的寄宿图的像素和视图大小的比例 默认为1.0
//    self.layerView.layer.contentsScale = image.scale;
    self.layerView.layer.contentsScale = [UIScreen mainScreen].scale;
    
    // 决定图层是否显示超出边界的内容 类似于UIView的clipsToBounds
    self.layerView.layer.masksToBounds = YES;
}

// 给图层添加一个子图层
- (void)addBlueLayer {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToAnchorPointTestView:)];
    [self.layerView addGestureRecognizer:tap];
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(190.0f, 190.0f, 10.0f, 10.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:blueLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
