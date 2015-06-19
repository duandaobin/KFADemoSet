//
//  KFAGroupDetailTableViewController.h
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KFAGroup, KFACeo;

@interface KFAGroupDetailTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *allWorkers; // 存储workers
@property (nonatomic, strong) KFACeo *ceo; // 相应的ceo
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext; // 临时存储

@property (nonatomic, strong) KFAGroup *group; // 接受传过来的公司

@end
