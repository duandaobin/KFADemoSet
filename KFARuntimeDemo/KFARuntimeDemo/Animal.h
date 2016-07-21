//
//  Animal.h
//  KFARuntimeDemo
//
//  Created by 柯梵Aaron on 16/7/9.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal : NSObject

@property (nonatomic, copy) NSString *name;

+ (void)eat;
- (void)playBall;

@end


@interface Dog : Animal

@end


@interface Cat : Animal

@end


@interface Rabbit : Animal

@end


@interface Pig : Animal

@end


@interface People : NSObject

@property (nonatomic, copy) NSString *gender;

+ (void)study;
- (void)keepPets;

@end





