//
//  KFADrawToolView.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFADrawToolView.h"

@interface KFADrawToolView ()
{
    UIView *_colorView;
    UIView *_widthView;
    UIView *_toolView;
    
    // 选择动画效果图
    UIImageView *_toolSelectAnimationView;
    UIImageView *_colorSelectAnimationView;
    UIImageView *_widthSelectAnimationView;
    
    NSArray *_colorArr;
}

@end

@implementation KFADrawToolView

- (instancetype)init {
    if (self = [super init]) {
        [self addToolBar];
        [self addWidthSelectView];
        [self addColorSelectView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addToolBar];
        [self addWidthSelectView];
        [self addColorSelectView];
    }
    return self;
}

// 加载工具选择栏
- (void)addToolBar {
    _toolView = [[UIView alloc] init];
    _toolView.backgroundColor = [UIColor lightGrayColor];
    _toolView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_toolView];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:_toolView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:_toolView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:_toolView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *height_ = [NSLayoutConstraint constraintWithItem:_toolView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    NSArray *constraintArr = @[left, right, bottom, height_];
    [self addConstraints:constraintArr];
    
    NSArray *nameArr = @[@"颜色", @"线宽", @"橡皮", @"撤销", @"清屏"];
    CGFloat width = kScreenWidth/nameArr.count;
    CGFloat height = 50;
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 0, width, height);
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
    }
    
    _toolSelectAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(-width, 0, width, height)];
    _toolSelectAnimationView.backgroundColor = [UIColor cyanColor];
    _toolSelectAnimationView.alpha = 0.3;
    [_toolView addSubview:_toolSelectAnimationView];
}

// 加载宽度选择栏
- (void)addWidthSelectView {
    _widthView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 80)];
    _widthView.backgroundColor = [UIColor lightGrayColor];
    _widthView.hidden = YES;
    [self addSubview:_widthView];
    
    NSArray *widthArr = @[@"1",@"3",@"5",@"8",@"10",@"15",@"20"];
    CGFloat width = kScreenWidth/widthArr.count;
    CGFloat height = 70;
    for (int i = 0; i < widthArr.count; i++) {
        NSString *sizeW = widthArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 5, width, height);
        [btn setTitle:sizeW forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.tag = 2000+sizeW.floatValue;
        [btn addTarget:self action:@selector(widthBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_widthView addSubview:btn];
    }
    
    _widthSelectAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, width, height)];
    _widthSelectAnimationView.backgroundColor = [UIColor cyanColor];
    _widthSelectAnimationView.alpha = 0.3;
    [_widthView addSubview:_widthSelectAnimationView];
}

// 加载颜色选择栏
- (void)addColorSelectView {
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 80)];
    _colorView.backgroundColor = [UIColor lightGrayColor];
    _colorView.hidden = YES;
    [self addSubview:_colorView];
    
    _colorArr = @[[UIColor blackColor], [UIColor darkGrayColor], [UIColor grayColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor brownColor]];
    CGFloat width = kScreenWidth/_colorArr.count;
    CGFloat height = 70;
    for (int i = 0; i < _colorArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*width, 5, width, height);
        btn.backgroundColor = _colorArr[i];
        btn.tag = 3000+i;
        [btn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_colorView addSubview:btn];
    }
    
    _colorSelectAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, width, height)];
    _colorSelectAnimationView.backgroundColor = [UIColor blackColor];
    _colorSelectAnimationView.alpha = 0.2;
    [_colorView addSubview:_colorSelectAnimationView];
}

- (void)toolBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1000: // 颜色选择
        {
            if (!_widthView.hidden) {
                [self hidenView];
            }
            [self changeEraseTitle];
            if (_colorView.hidden) {
                _colorView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    _colorView.transform = CGAffineTransformMakeTranslation(0, -80);
                }];
            }
            if (self.colorSelectBlock) {
                self.colorSelectBlock();
            }
        }
            break;
        case 1001: // 宽度选择
        {
            if (!_colorView.hidden) {
                [self hidenView];
            }
            [self changeEraseTitle];
            if (_widthView.hidden) {
                _widthView.hidden = NO;
                [UIView animateWithDuration:0.3 animations:^{
                    _widthView.transform = CGAffineTransformMakeTranslation(0, -80);
                }];
            }
            if (self.widthSelectBlock) {
                self.widthSelectBlock();
            }
        }
            break;
        case 1002: // 橡皮擦
        {
            [self hidenView];
            
            NSString *title = [btn titleForState:UIControlStateNormal];
            if ([title isEqualToString:@"橡皮"]) {
                [btn setTitle:@"完成" forState:UIControlStateNormal];
                if (self.eraseBlock) {
                    self.eraseBlock(YES);
                }
            }else {
                [btn setTitle:@"橡皮" forState:UIControlStateNormal];
                if (self.eraseBlock) {
                    self.eraseBlock(NO);
                }
            }
        }
            break;
        case 1003: // 撤销
        {
            [self hidenView];
            [self changeEraseTitle];
            if (self.undoBlock) {
                self.undoBlock();
            }
        }
            break;
        case 1004: // 清屏
        {
            [self hidenView];
            [self changeEraseTitle];
            if (self.clearBlock) {
                self.clearBlock();
            }
        }
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _toolSelectAnimationView.center = btn.center;
    }];
}

- (void)widthBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    CGFloat width = btn.tag-2000;
    if (self.widthBlock) {
        self.widthBlock(width);
    }
    
    _widthSelectAnimationView.center = btn.center;
    [self hidenView];
}

- (void)colorBtnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIColor *color = [_colorArr safeObjectOfIndex:(btn.tag-3000)];
    if (self.colorBlock) {
        self.colorBlock(color);
    }
    
    _colorSelectAnimationView.center = btn.center;
    [self hidenView];
}

- (void)hidenView {
    UIView *view = nil;
    if (!_colorView.hidden) {
        view = _colorView;
    }
    if (!_widthView.hidden) {
        view = _widthView;
    }
    if (view != nil) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeTranslation(0, 80);
        } completion:^(BOOL finished) {
            view.hidden = YES;
        }];
    }
}

- (void)changeEraseTitle {
    for (UIView *view in _toolView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (btn.tag == 1002) {
                [btn setTitle:@"橡皮" forState:UIControlStateNormal];
            }
        }
    }
}

@end
