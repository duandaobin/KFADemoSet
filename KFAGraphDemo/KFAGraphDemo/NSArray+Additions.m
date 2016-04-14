//
//  NSArray+Additions.m
//  KFABlockDemo
//
//  Created by 柯梵Aaron on 15/12/30.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (id)safeObjectOfIndex:(NSUInteger)index
{
    if (self.count > index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end
