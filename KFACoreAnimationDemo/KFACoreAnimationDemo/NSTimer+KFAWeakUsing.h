//
//  NSTimer+KFAWeakUsing.h
//  KFABlockDemo
//
//  Created by 柯梵Aaron on 16/3/11.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (KFAWeakUsing)

// 通过block防止NSTimer循环引用
+ (NSTimer *)kfa_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)repeats;

@end
