//
//  InternationalControl.m
//  InternationalTest
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl

#pragma mark - 获取当前资源文件

static NSBundle *bundle = nil;

+ (NSBundle *)bundle{
    return bundle;
}

#pragma mark - 初始化语言文件
+ (void)initUserLanguage{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    NSString *string = [userD valueForKey:@"ChangeLanguage"];
    if (string.length == 0) {
        string = [[userD objectForKey:@"AppleLanguages"] objectAtIndex:0];
        [userD setValue:string forKey:@"ChangeLanguage"];
        [userD synchronize];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

#pragma mark - 获取应用当前语言
+ (NSString *)userLanguage{
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"ChangeLanguage"];
}

#pragma mark - 设置当前语言
+ (void)setUserLanguage:(NSString *)language{
    NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
    
    [userD setValue:language forKey:@"ChangeLanguage"];
    
    [userD synchronize];
}

@end
