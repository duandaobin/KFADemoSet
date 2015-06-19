//
//  KFADataStoreTools.m
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/18.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFADataStoreTools.h"

@implementation KFADataStoreTools

// 当属性为readonly时，必须用@synthesize重新定义，要不在延展里重新定义
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static KFADataStoreTools *dataStoreTools = nil;

dispatch_once_t once;

#pragma mark - 创建单例
+ (instancetype)create{
    dispatch_once(&once, ^{
        dataStoreTools = [[KFADataStoreTools alloc] init];
    });
    return dataStoreTools;
}

#pragma mark - 重写managedObjectContext的get方法
- (NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        if (!self.persistentStoreCoordinator) {
            return nil;
        }
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

#pragma mark - 重写managedObjectModel的get方法
- (NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        // 获取可视化建模文件路径 momd = xcdatamodeld
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:self.resourceName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    }
    return _managedObjectModel;
}

#pragma mark - 重写persistentStoreCoordinator的get方法
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (!_persistentStoreCoordinator) {
        // 初始化持久化存储助理 需要被管理对象模型的支持
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        // 调试测试这个持久化存储助理是否可用，不行的话打印错误信息并手动崩溃
        // 数据库文件路径
        NSURL *storeUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"KFACoreDataExample.sqlite"];
        NSError *error = nil;
        NSString *failureReason = @"There was a error creating or loading the application's saved data";
        // 不考虑版本迁移的话，option可以设为nil
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@",error,error.userInfo);
            // 手动崩溃，只在调试中和打印配合使用，上传时不能用这个方法！
            abort();
        }
        
    }
    return _persistentStoreCoordinator;
}

#pragma mark - 保存数据管理器
- (void)saveContext{
    if (self.managedObjectContext) {
        NSError *error = nil;
        if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@",error,error.userInfo);
            abort();
        }
    }
}

#pragma mark - 获取文件路径
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
