//
//  UIColor+KFAAdditions.h
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/6.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KFAAdditions)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;

/**
 *  十六进制颜色值转换成UIColor对象
 *
 *  @param hexString 十六进制颜色值
 *
 *  @return 颜色对象
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

/**
 *  使用UIColor创建UIImage
 *
 *  @param color 给定的颜色
 *
 *  @return image
 */
+ (UIImage *)createImageWith:(UIColor *)color;

@end
