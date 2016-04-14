//
//  KFADrawView.h
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KFADrawView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)undoAction;
- (void)clearScreen;

@end
