//
//  KFADrawToolView.h
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/14.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ColorSelectBlock)(UIColor *color);
typedef void(^WidthSelectBlock)(CGFloat width);
typedef void(^EraseBlcok)(BOOL isErasing);

@interface KFADrawToolView : UIView

@property (nonatomic, copy) ColorSelectBlock colorBlock;
@property (nonatomic, copy) WidthSelectBlock widthBlock;
@property (nonatomic, copy) KFABasicBlock colorSelectBlock;
@property (nonatomic, copy) KFABasicBlock widthSelectBlock;
@property (nonatomic, copy) EraseBlcok eraseBlock;
@property (nonatomic, copy) KFABasicBlock undoBlock;
@property (nonatomic, copy) KFABasicBlock clearBlock;

@end
