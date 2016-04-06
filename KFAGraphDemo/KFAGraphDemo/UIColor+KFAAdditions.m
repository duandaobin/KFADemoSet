//
//  UIColor+KFAAdditions.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/6.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "UIColor+KFAAdditions.h"

@implementation UIColor (KFAAdditions)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // hexString应该6到8个字符
    if (cString.length < 6) {
        return [UIColor clearColor];
    }
    
    // 如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    // 如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6) {
        return [UIColor clearColor];
    }
    
    // RGB转换
//    // 方法一
//    NSScanner *scanner = [NSScanner scannerWithString:cString];
//    unsigned hasNum = 0;
//    if (![scanner scanHexInt:&hasNum]) {
//        return nil;
//    }
//    
//    return [UIColor colorWithRGBHex:hasNum];
    
    // 方法二
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIImage *)createImageWith:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
