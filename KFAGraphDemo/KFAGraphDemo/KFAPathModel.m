//
//  KFAPathModel.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFAPathModel.h"

@implementation KFAPathModel

- (void)dealloc {
    CGPathRelease(_linePath);
}

- (void)setLinePath:(CGMutablePathRef)linePath {
    if (_linePath != linePath) {
        _linePath = (CGMutablePathRef)CGPathRetain(linePath);
    }
}

@end
