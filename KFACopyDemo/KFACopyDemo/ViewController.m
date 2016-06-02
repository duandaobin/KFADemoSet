//
//  ViewController.m
//  KFACopyDemo
//
//  Created by 柯梵Aaron on 16/6/1.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "KFACopyModel.h"

void KFALog(NSArray *array1, NSArray *array2, NSArray *array3);
NSString *KFANSStringFromArray(NSArray *array);

@interface ViewController ()

@property (nonatomic, strong) NSString *testStrongStr;
@property (nonatomic, copy) NSString *testCopyStr;

@property (nonatomic, strong) NSArray *testStrongArr;
@property (nonatomic, copy) NSArray *testCopyArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self testImmutableObjectCopy];
//    [self testMutableObjectCopy];
//    [self testImmutableArrayCopy];
//    [self testMutableArrayCopy];
//    [self testCopyAndStrongForString];
    [self testCopyAndStrongForArray];
}

- (void)testImmutableObjectCopy {
    
    NSString *immutableStr = @"KFA_test1";
    NSString *copyImmutableStr = [immutableStr copy];
    NSString *mutableCopyImmutableStr = [immutableStr mutableCopy];
    NSLog(@"\nimmutableStr:%p-%p\ncopyImmutableStr:%p-%p\nmutableImmutableStr:%p-%p",immutableStr,&immutableStr,copyImmutableStr,&copyImmutableStr,mutableCopyImmutableStr,&mutableCopyImmutableStr);
}

- (void)testMutableObjectCopy {
    
    NSMutableString *mutableStr = [@"KFA_test2" mutableCopy];
    NSString *copyImmutableStr = [mutableStr copy];
    NSString *mutableCopyImmutableStr = [mutableStr mutableCopy];
    NSLog(@"\nmutableStr:%p-%p\ncopyImmutableStr:%p-%p\nmutableImmutableStr:%p-%p",mutableStr,&mutableStr,copyImmutableStr,&copyImmutableStr,mutableCopyImmutableStr,&mutableCopyImmutableStr);
}

- (void)testImmutableArrayCopy {
    
    NSArray *immutableArr = @[@"KFA_test3"];
    NSString *immu = immutableArr.firstObject;
    NSArray *copyImmutableArr = [immutableArr copy];
    NSString *copyImmu = copyImmutableArr.firstObject;
    NSArray *mutableCopyImmutableArr = [immutableArr mutableCopy];
    NSString *mutableCopyImu = mutableCopyImmutableArr.firstObject;
    NSLog(@"\nimmutableArr:%p-%p\ncopyImmutableArr:%p-%p\nmutableCopyImmutableArr:%p-%p\nimmu:%p-%p\ncopyImmu:%p-%p\nmutableCopyImu:%p-%p",immutableArr,&immutableArr,copyImmutableArr,&copyImmutableArr,mutableCopyImmutableArr,&mutableCopyImmutableArr,immu,&immu,copyImmu,&copyImmu,mutableCopyImu,&mutableCopyImu);
}

- (void)testMutableArrayCopy {
    NSArray *mutableArr = [@[@"KFA_test3"] mutableCopy];
    NSString *mu = mutableArr.firstObject;
    NSArray *copyImmutableArr = [mutableArr copy];
    NSString *copyImmu = copyImmutableArr.firstObject;
    NSArray *mutableCopyImmutableArr = [mutableArr mutableCopy];
    NSString *mutableCopyImu = mutableCopyImmutableArr.firstObject;
    NSLog(@"\nmutableArr:%p-%p\ncopyImmutableArr:%p-%p\nmutableCopyImmutableArr:%p-%p\nmu:%p-%p\ncopyImmu:%p-%p\nmutableCopyImu:%p-%p",mutableArr,&mutableArr,copyImmutableArr,&copyImmutableArr,mutableCopyImmutableArr,&mutableCopyImmutableArr,mu,&mu,copyImmu,&copyImmu,mutableCopyImu,&mutableCopyImu);
}

- (void)testCopyAndStrongForString {
    
    NSString *immutableStr = @"KFA_test4";
    self.testStrongStr = immutableStr;
    self.testCopyStr = immutableStr;
    NSLog(@"\nimmutableStr:%@\nself.testStrongStr:%@\nself.testCopyStr:%@",immutableStr,self.testStrongStr,self.testCopyStr);
    immutableStr = @"KFA_test4_change";
    NSLog(@"\nimmutableStr:%@\nself.testStrongStr:%@\nself.testCopyStr:%@",immutableStr,self.testStrongStr,self.testCopyStr);
    
    NSMutableString *mutableStr = [@"KFA_test5" mutableCopy];
    self.testStrongStr = mutableStr;
    self.testCopyStr = mutableStr;
    NSLog(@"\nmutableStr:%@\nself.testStrongStr:%@\nself.testCopyStr:%@",mutableStr,self.testStrongStr,self.testCopyStr);
    [mutableStr appendString:@"_change"];
    NSLog(@"\nmutableStr:%@\nself.testStrongStr:%@\nself.testCopyStr:%@",mutableStr,self.testStrongStr,self.testCopyStr);
}

- (void)testCopyAndStrongForArray {
    
    NSArray *immutableArr = @[@"KFA_test6"];
    self.testStrongArr = immutableArr;
    self.testCopyArr = immutableArr;
    KFALog(immutableArr,self.testStrongArr,self.testCopyArr);
    immutableArr = @[@"KFA_test6_change"];
    KFALog(immutableArr,self.testStrongArr,self.testCopyArr);
    
    NSMutableArray *mutableArr = [@[@"KFA_test7"] mutableCopy];
    self.testStrongArr = mutableArr;
    self.testCopyArr = mutableArr;
    KFALog(mutableArr, self.testStrongArr, self.testCopyArr);
    [mutableArr replaceObjectAtIndex:0 withObject:@"KFA_test7_change"];
    KFALog(mutableArr, self.testStrongArr, self.testCopyArr);
    
    KFACopyModel *model1 = [[KFACopyModel alloc] init];
    model1.number = @"13789892310";
    NSArray *immutableArr_ = @[model1];
    self.testStrongArr = immutableArr_;
    self.testCopyArr = immutableArr_;
    KFALog(immutableArr_, self.testStrongArr, self.testCopyArr);
    model1.number = @"137****2310";
    KFALog(immutableArr_, self.testStrongArr, self.testCopyArr);
    
    KFACopyModel *model2 = [[KFACopyModel alloc] init];
    model2.number = @"13982650942";
    NSArray *mutableArr_ = @[model2];
    self.testStrongArr = mutableArr_;
    self.testCopyArr = mutableArr_;
    KFALog(mutableArr_, self.testStrongArr, self.testCopyArr);
    model2.number = @"139****0942";
    KFALog(mutableArr_, self.testStrongArr, self.testCopyArr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

void KFALog(NSArray *array1, NSArray *array2, NSArray *array3) {

    NSString *string1 = KFANSStringFromArray(array1);
    NSString *string2 = KFANSStringFromArray(array2);
    NSString *string3 = KFANSStringFromArray(array3);
    NSLog(@"\n\%@\n%@\n%@",string1,string2,string3);
}

NSString *KFANSStringFromArray(NSArray *array) {
    NSMutableString *string = nil;
    for (NSString *objc in array) {
        NSString *objcStr = nil;
        if ([objc isKindOfClass:[NSString class]]) {
            objcStr = (NSString *)objc;
        }else if ([objc isKindOfClass:[KFACopyModel class]]) {
            KFACopyModel *model = (KFACopyModel *)objc;
            objcStr = model.number;
        }
        if (string == nil) {
            string = [objcStr mutableCopy];
        }else {
            [string appendFormat:@"_%@",objcStr];
        }
    }
    return string;
}
