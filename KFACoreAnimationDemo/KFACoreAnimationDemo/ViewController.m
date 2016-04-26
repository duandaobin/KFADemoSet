//
//  ViewController.m
//  KFACoreAnimationDemo
//
//  Created by 柯梵Aaron on 16/4/13.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "KFAAnchorPointTestViewController.h"
#import "KFASolidObjeViewController.h"
#import "KFASpecialLayerViewController.h"
#import "KFAImplicitAnimationController.h"
#import "KFAShowAnimationController.h"
#import "KFABufferAnimationController.h"

static NSString *cellIdentifier = @"cellIdentifier";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIView *leftTopView;
@property (weak, nonatomic) IBOutlet UIView *rightTopView;
@property (weak, nonatomic) IBOutlet UIView *leftDownView;
@property (weak, nonatomic) IBOutlet UIView *rightDownView;

@property (nonatomic, weak) CALayer *blueLayer;

@property (weak, nonatomic) IBOutlet UITableView *btnTableview;
@property (nonatomic, copy) NSArray *btnArray;
@property (nonatomic, copy) NSArray *controllerArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBlueLayer];
    [self setLayerViewBackgroudImage];
    [self seperateImageToFourView];
    [self addAnotherBlueLayer];
    
    [self setTableview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 通过识别在图层上的点击位置，判断点击的图层，从而实现相应的相应
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    // 第一种方法 containsPoint:
//    point = [self.layerView.layer convertPoint:point fromLayer:self.view.layer];
//    if ([self.layerView.layer containsPoint:point]) {
//        point = [self.blueLayer convertPoint:point fromLayer:self.layerView.layer];
//        if ([self.blueLayer containsPoint:point]) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inside blue layer" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }else {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inside white layer" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
//        }
//    }
    
    // 第二种方法 hitTest:
    CALayer *layer = [self.layerView.layer hitTest:point];
    if (layer == self.blueLayer) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inside blue layer" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (layer == self.layerView.layer) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Inside white layer" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.btnArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor cyanColor];
    cell.textLabel.text = self.btnArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.controllerArr[indexPath.row];
    Class class = NSClassFromString(className);
    UIViewController *vc = (UIViewController *)[[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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

// 配置tableView
- (void)setTableview {
    
    self.btnTableview.delegate = self;
    self.btnTableview.dataSource = self;
    [self.btnTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    UIView *footer = [[UIView alloc] init];
    self.btnTableview.tableFooterView = footer;
}

// 自定义绘画
- (void)addAnotherBlueLayer {
    CALayer *blueLayer = [CALayer layer];
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    
    // 设置代理
    blueLayer.delegate = self;
    blueLayer.contentsScale = [UIScreen mainScreen].scale;
    self.blueLayer = blueLayer;
    [self.layerView.layer addSublayer:self.blueLayer];
    // 强制重绘 以便调动代理方法, 不同于UIView，图层显示在屏幕上时，CALayer不会自动重绘它的内容
    [self.blueLayer display];
    
    // 尽管Core Animation图层存在于3D空间之内，但他们并不都存在同一个3D空间。
//    CATransform3D outer = CATransform3DIdentity;
    // 设置透视效果
//    outer.m34 = -1.0/500.0;
//    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
//    self.layerView.layer.transform = outer;
    
//    CATransform3D inner = CATransform3DIdentity;
//    inner.m34 = -1.0/500.0;
//    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
//    self.blueLayer.transform = inner;
    
    // 对图层绕Y轴做45°的旋转
//    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//    blueLayer.transform = transform;
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
    
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(190.0f, 190.0f, 10.0f, 10.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layerView.layer addSublayer:blueLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark getters

- (NSArray *)btnArray {
    if (!_btnArray) {
        _btnArray = @[@"AnchorPoint",@"SolidObje",@"SepecialLayer",@"ImplicitAnimation",@"ShowAnimation",@"BufferAnimation"];
    }
    return _btnArray;
}

- (NSArray *)controllerArr {
    if (!_controllerArr) {
        _controllerArr = @[@"KFAAnchorPointTestViewController",@"KFASolidObjeViewController",@"KFASpecialLayerViewController",@"KFAImplicitAnimationController",@"KFAShowAnimationController",@"KFABufferAnimationController"];
    }
    return _controllerArr;
}

@end
