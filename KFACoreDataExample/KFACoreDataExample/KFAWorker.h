//
//  KFAWorker.h
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KFACeo, KFAGroup;

@interface KFAWorker : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) KFAGroup *group;
@property (nonatomic, retain) KFACeo *ceo;

@end
