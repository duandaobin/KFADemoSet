//
//  KFACustomView.h
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/7.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KFACustomType) {
    KFACustomTypeLine, // 线
    KFACustomTypeShape, // 多边形
    KFACustomTypeCircle, // 圆
    KFACustomTypeTextImage, // 文字图片
    KFACustomTypeCut, // 裁剪
    KFACustomTypeGraduatedColors, // 颜色渐变
    KFACustomTypeOther // 其他
};

@interface KFACustomView : UIView

@property (nonatomic, assign) KFACustomType type;

@end
