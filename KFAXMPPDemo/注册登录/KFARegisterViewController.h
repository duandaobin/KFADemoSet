//
//  KFARegisterViewController.h
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSString *userName, NSString *password);

@interface KFARegisterViewController : UIViewController

@property (nonatomic, copy) block handler;

@end
