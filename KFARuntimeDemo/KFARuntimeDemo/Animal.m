//
//  Animal.m
//  KFARuntimeDemo
//
//  Created by 柯梵Aaron on 16/7/9.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "Animal.h"

@implementation Animal

- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"调用了Animal的init方法~~");
    }
    return self;
}

//***首次加载时调用，绝对只调用一次***/
+ (void)load {
    NSLog(@"调用了animal的load方法~~");
}

//***首次给类发送消息时调用，通常只掉用一次，如果子类没有重写此方法，则会调一次自己的initialize方法；同理如果自己没有重写，就会去调父类的，父类没有就继续往上找***/
+ (void)initialize {
    NSLog(@"调用了animal的initialize方法~~");
}

+ (void)eat {
    NSLog(@"Animal正在吃东西~~");
}

- (void)playBall {
    NSLog(@"Animal在玩球~~");
}

@end


@implementation Dog

+ (void)load {
    NSLog(@"调用了Dog的load方法~~");
}

+ (void)initialize {
    NSLog(@"调用了Dog的initialize方法~~");
}

@end


@implementation Cat

+ (void)load {
    NSLog(@"调用了Cat的load方法~~");
}

@end


@implementation Rabbit

+ (void)initialize {
    NSLog(@"调用了Rabbit的initialize方法~~");
}

@end

@implementation Pig

@end


@implementation People

+ (void)study {
    NSLog(@"这个人在学习~~");
}

- (void)keepPets {
    NSLog(@"这个人养了宠物~~");
}

@end




