//
//  KFAGroupTableViewController.m
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAGroupTableViewController.h"
#import "KFAGroup.h"
#import "KFACeo.h"
#import "KFAWorker.h"
#import "KFAGroupDetailTableViewController.h"
#import "KFADataStoreTools.h"

@interface KFAGroupTableViewController ()

// 存储所有公司
@property (nonatomic, strong) NSMutableArray *allGroups;
// 临时存储器
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// 数据存储工具
@property (nonatomic, strong) KFADataStoreTools *dataStoreTools;

@end

@implementation KFAGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataStoreTools = [KFADataStoreTools create];
    _dataStoreTools.resourceName = @"KFACoreDataModel";
}

#pragma mark - 重写managedObjectContext的get方法
- (NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        _managedObjectContext = _dataStoreTools.managedObjectContext;
    }
    return _managedObjectContext;
}

#pragma mark - 重写allGroups的get方法
- (NSMutableArray *)allGroups{
    if (!_allGroups) {
        // 创建请求对象
        NSFetchRequest *groupFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KFAGroup"];
        // 排序
        NSSortDescriptor *groupSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
        // 由管理对象上下文执行请求
        [groupFetchRequest setSortDescriptors:@[groupSortDescriptor]];
        NSError *error = nil;
        NSArray *array = [self.managedObjectContext executeFetchRequest:groupFetchRequest error:&error];
        if (!error) {
            _allGroups = [[NSMutableArray alloc] initWithArray:array];
        }
    }
    return _allGroups;
}

#pragma mark - 添加group
- (IBAction)addGroup:(id)sender {
    // 创建实体描述
    // 添加公司
    NSEntityDescription *groupEntity = [NSEntityDescription entityForName:@"KFAGroup" inManagedObjectContext:self.managedObjectContext];
    KFAGroup *group = [[KFAGroup alloc] initWithEntity:groupEntity insertIntoManagedObjectContext:self.managedObjectContext];
    int number = arc4random()%1000+1;
    group.name = [NSString stringWithFormat:@"KEFAN%d",number];
    group.number = [NSNumber numberWithInt:number];
    // 添加CEO
    NSEntityDescription *ceoEntity = [NSEntityDescription entityForName:@"KFACeo" inManagedObjectContext:self.managedObjectContext];
    KFACeo *ceo = [[KFACeo alloc] initWithEntity:ceoEntity insertIntoManagedObjectContext:self.managedObjectContext];
    int numb = arc4random()%100+1;
    ceo.name = [NSString stringWithFormat:@"TangZong%d",numb];
    ceo.gender = @"male";
    // 建立联系
    group.ceo = ceo;
    ceo.group = group;
    
    int menberCounts = arc4random()%20+1;
    for (int i = 0; i < menberCounts; i ++) {
        NSEntityDescription *workerEntity = [NSEntityDescription entityForName:@"KFAWorker" inManagedObjectContext:self.managedObjectContext];
        KFAWorker *worker = [[KFAWorker alloc] initWithEntity:workerEntity insertIntoManagedObjectContext:self.managedObjectContext];
        int age = arc4random()%40+ 20;
        worker.name = [NSString stringWithFormat:@"Number%d",age];
        worker.age = [NSNumber numberWithInt:age];
        // 建立表联系
        worker.group = group;
        worker.ceo = ceo;
        // 公司与员工建立联系
        [group addWorkerObject:worker];
        // CEO与员工建立联系
        [ceo addWorkerObject:worker];
    }
    // 计算插入的位置
    NSInteger index = 0;
    for (KFAGroup *agroup in self.allGroups) {
        if (agroup.number < group.number) {
            index ++;
        }
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (!error) {
        [self.allGroups insertObject:group atIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.allGroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KFAcellID" forIndexPath:indexPath];
    
    KFAGroup *group = self.allGroups[indexPath.row];
    cell.textLabel.text = group.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",group.number];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        KFAGroup *group = self.allGroups[indexPath.row];
        KFACeo *ceo = group.ceo;
        for (KFAWorker *worker in group.worker) {
            [self.managedObjectContext deleteObject:worker];
        }
        [self.managedObjectContext deleteObject:ceo];
        [self.managedObjectContext deleteObject:group];
        [self.allGroups removeObjectAtIndex:indexPath.row];
        
        // 保存 -- 持久化
        [_dataStoreTools saveContext];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    KFAGroupDetailTableViewController *groupDetailTVC = (KFAGroupDetailTableViewController *)segue.destinationViewController;
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    KFAGroup *group = self.allGroups[indexPath.row];
    groupDetailTVC.group = group;
}


@end
