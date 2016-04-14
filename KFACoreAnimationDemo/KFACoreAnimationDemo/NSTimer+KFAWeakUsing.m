//
//  NSTimer+KFAWeakUsing.m
//  KFABlockDemo
//
//  Created by 柯梵Aaron on 16/3/11.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "NSTimer+KFAWeakUsing.h"

@implementation NSTimer (KFAWeakUsing)

+ (NSTimer *)kfa_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(kfa_blockInvoke:) userInfo:[block copy] repeats:repeats];
}

+ (void)kfa_blockInvoke:(NSTimer *)timer
{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
