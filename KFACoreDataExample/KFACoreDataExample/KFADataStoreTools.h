//
//  KFADataStoreTools.h
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/18.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface KFADataStoreTools : NSObject

// 被管理对象上下文 数据管理器
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

// 被管理数据模型 数据模型器 （表）
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;

// 持久化存储助理 （结合数据模型器操作）
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// momd文件名 -- 使用之前先给resourceName赋值
@property (nonatomic, strong) NSString *resourceName;

/**
 *  创建数据存储单例
 */
+ (instancetype)create;

/**
 *  保存数据管理器方法
 */
- (void)saveContext;

/**
 *  获取文件路径
 *
 *  @return 文件路径
 */
- (NSURL *)applicationDocumentsDirectory;

@end
