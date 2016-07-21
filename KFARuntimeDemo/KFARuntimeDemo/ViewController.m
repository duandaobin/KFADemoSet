//
//  ViewController.m
//  KFARuntimeDemo
//
//  Created by 柯梵Aaron on 16/7/9.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testLoadAndInitialize];
//    [self testRuntimeFunctions_workingWithClasses];
    
    NSString *a = @"I gave my 💛 to you";
    if ([a rangeOfString:@"💛"].location == NSNotFound) {
        // do anything you want
    }
    const char *c = a.UTF8String;
    NSLog(@"%s",c);
    const char *d = [a cStringUsingEncoding:NSUTF16StringEncoding];
    NSLog(@"%s",d);
    BOOL b = [self isEmoji:a];
    NSLog(@"%d",b);
    NSString *s = @"\u55357";
    NSLog(@"%@",s);
    unichar m = [@"💛" characterAtIndex:0];
    NSLog(@"%hu",m);
}

- (BOOL)isEmoji:(NSString *)emoji {
    BOOL isE = YES;
    if ([emoji rangeOfString:@"💛"].location == NSNotFound) {
        isE = NO;
    }
    return isE;
}

- (void)testRuntimeFunctions_workingWithClasses {
    
    // 类
    Class animalClass = [Animal class];
    Class dogClass = [Dog class];
    
    // 获取类的名字
    const char *a = class_getName(animalClass);
    NSLog(@"%s",a);
    
    // 获取父类
    Class superClass = class_getSuperclass(animalClass);
    Class superClass_ = [Animal superclass];
    NSLog(@"%@---%@",superClass,superClass_);
    
//    // 设置父类 不让用
//    Class class_setSuperclass(Class cls, Class newSuper)
    
    // 判断一个类是否是元类
    BOOL animalIsMetaClass = class_isMetaClass(animalClass);
    BOOL dogIsMetaClass = class_isMetaClass(dogClass);
    NSLog(@"%d---%d",animalIsMetaClass,dogIsMetaClass);
    
    
    
}

- (void)testLoadAndInitialize {
    
    Animal *animal = [[Animal alloc] init];
    NSLog(@"%@",animal);
    Dog *dog = [[Dog alloc] init];
    NSLog(@"%@",dog);
    Cat *cat = [[Cat alloc] init];
    NSLog(@"%@",cat);
    Rabbit *rabbit = [[Rabbit alloc] init];
    NSLog(@"%@",rabbit);
    Pig *pig = [[Pig alloc] init];
    NSLog(@"%@",pig);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
