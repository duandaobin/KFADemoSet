//
//  KFAPathModel.h
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFAPathModel : NSObject

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGMutablePathRef linePath;

@end
