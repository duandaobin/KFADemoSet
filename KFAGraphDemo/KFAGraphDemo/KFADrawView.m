//
//  KFADrawView.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFADrawView.h"
#import "KFAPathModel.h"

@interface KFADrawView ()
{
    CGMutablePathRef _lastPath;
    NSMutableArray *_pathArr;
}

@end

@implementation KFADrawView

- (instancetype)init {
    if (self = [super init]) {
        _pathArr = [NSMutableArray array];
        _lineColor = [UIColor blackColor];
        _lineWidth = 1.0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _pathArr = [NSMutableArray array];
        _lineColor = [UIColor blackColor];
        _lineWidth = 1.0;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (KFAPathModel *model in _pathArr) {
        [model.lineColor setStroke];
        CGContextSetLineWidth(context, model.lineWidth);
        CGContextAddPath(context, model.linePath);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (_lastPath != nil) {
        CGContextAddPath(context, _lastPath);
        [self.lineColor setStroke];
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    _lastPath = CGPathCreateMutable();
    CGPathMoveToPoint(_lastPath, NULL, point.x, point.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 把移动的点加入路径中
    CGPathAddLineToPoint(_lastPath, NULL, point.x, point.y);
    // 实时绘图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    KFAPathModel *model = [[KFAPathModel alloc] init];
    model.lineColor = self.lineColor;
    model.lineWidth = self.lineWidth;
    model.linePath = _lastPath;
    [_pathArr addObject:model];
    
    CGPathRelease(_lastPath);
    _lastPath = nil;
}

- (void)undoAction {
    [_pathArr removeLastObject];
    [self setNeedsDisplay];
}

- (void)clearScreen {
    [_pathArr removeAllObjects];
    [self setNeedsDisplay];
}

@end
