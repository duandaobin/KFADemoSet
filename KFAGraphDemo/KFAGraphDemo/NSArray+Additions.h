//
//  NSArray+Additions.h
//  KFABlockDemo
//
//  Created by 柯梵Aaron on 15/12/30.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

/**
 *  安全的获取指定下标的值，防止越界
 *
 *  @param index 下标
 *
 *  @return 指定下标的value
 */
- (id)safeObjectOfIndex:(NSUInteger)index;

@end
