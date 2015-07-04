//
//  InternationalControl.h
//  InternationalTest
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalControl : NSObject

/**
 *  获取当前资源文件
 */
+ (NSBundle *)bundle;

/**
 *  初始化语言文件
 */
+ (void)initUserLanguage;

/**
 *  获取应用当前语言
 */
+ (NSString *)userLanguage;

/**
 *  设置当前语言
 *
 *  @param language 目标语言
 */
+ (void)setUserLanguage:(NSString *)language;

@end
