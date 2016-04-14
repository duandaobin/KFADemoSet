//
//  KFADrawBoardViewController.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFADrawBoardViewController.h"
#import "KFADrawToolView.h"
#import "KFADrawView.h"

@interface KFADrawBoardViewController ()

@property (nonatomic, strong) KFADrawView *drawView;

@property (nonatomic, strong) UIColor *lastColor;
@property (nonatomic, assign) CGFloat lastWidth;

@end

@implementation KFADrawBoardViewController

- (void)loadView {
    [super loadView];
    
    [self setNavigationItem];
    
    [self addToolView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setNavigationItem {
    self.navigationItem.title = @"涂鸦板";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)addToolView {
    
    KFADrawToolView *toolView = [[KFADrawToolView alloc] init];
    toolView.translatesAutoresizingMaskIntoConstraints = NO;
    toolView.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.drawView];
    [self.view addSubview:toolView];
    
    NSLayoutConstraint *toolLeft = [NSLayoutConstraint constraintWithItem:toolView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *toolRight = [NSLayoutConstraint constraintWithItem:toolView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *toolBottom = [NSLayoutConstraint constraintWithItem:toolView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *toolHeight = [NSLayoutConstraint constraintWithItem:toolView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50.0f];
    
    NSLayoutConstraint *drawLeft = [NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *drawTop = [NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *drawRight = [NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *drawHeight = [NSLayoutConstraint constraintWithItem:self.drawView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:kScreenHeight-50];
    
    NSArray *constaints = @[toolLeft, toolRight, toolBottom, toolHeight, drawLeft, drawTop, drawRight, drawHeight];
    [self.view addConstraints:constaints];
    
    self.lastWidth = 1.0;
    
    toolView.colorBlock = ^(UIColor *color){
        self.drawView.lineColor = color;
        self.lastColor = color;
        toolHeight.constant = 50;
        drawHeight.constant = kScreenHeight-50;
    };
    toolView.widthBlock = ^(CGFloat width){
        self.drawView.lineWidth = width;
        self.lastWidth = width;
        toolHeight.constant = 50;
        drawHeight.constant = kScreenHeight-50;
    };
    toolView.colorSelectBlock = ^(){
        toolHeight.constant = 130;
        drawHeight.constant = kScreenHeight-130;
        self.drawView.lineColor = self.lastColor;
        self.drawView.lineWidth = self.lastWidth;
    };
    toolView.widthSelectBlock = ^(){
        toolHeight.constant = 130;
        drawHeight.constant = kScreenHeight-130;
        self.drawView.lineColor = self.lastColor;
        self.drawView.lineWidth = self.lastWidth;
    };
    toolView.eraseBlock = ^(BOOL isErasing){
        if (isErasing) {
            self.drawView.lineWidth = 20;
            self.drawView.lineColor = [UIColor whiteColor];
        }else {
            self.drawView.lineWidth = self.lastWidth;
            self.drawView.lineColor = self.lastColor;
        }
        toolHeight.constant = 50;
        drawHeight.constant = kScreenHeight-50;
    };
    toolView.undoBlock = ^(){
        [self.drawView undoAction];
        toolHeight.constant = 50;
        drawHeight.constant = kScreenHeight-50;
        self.drawView.lineColor = self.lastColor;
        self.drawView.lineWidth = self.lastWidth;
    };
    toolView.clearBlock = ^(){
        [self.drawView clearScreen];
        toolHeight.constant = 50;
        drawHeight.constant = kScreenHeight-50;
        self.drawView.lineColor = self.lastColor;
        self.drawView.lineWidth = self.lastWidth;
    };
}

- (void)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImage:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.drawView.frame.size, YES, 0);
    [self.drawView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark getters

- (KFADrawView *)drawView {
    if (!_drawView) {
        _drawView = [[KFADrawView alloc] init];
        _drawView.backgroundColor = [UIColor whiteColor];
        _drawView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _drawView;
}

@end
