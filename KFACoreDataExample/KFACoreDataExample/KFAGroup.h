//
//  KFAGroup.h
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KFACeo, KFAWorker;

@interface KFAGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) KFACeo *ceo;
@property (nonatomic, retain) NSSet *worker;
@end

@interface KFAGroup (CoreDataGeneratedAccessors)

- (void)addWorkerObject:(KFAWorker *)value;
- (void)removeWorkerObject:(KFAWorker *)value;
- (void)addWorker:(NSSet *)values;
- (void)removeWorker:(NSSet *)values;

@end
