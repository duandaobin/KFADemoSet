//
//  KFAGroupDetailTableViewController.m
//  KFACoreDataExample
//
//  Created by 柯梵Aaron on 15/6/17.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAGroupDetailTableViewController.h"
#import "KFAGroup.h"
#import "KFACeo.h"
#import "KFAWorker.h"
#import "KFADataStoreTools.h"

@interface KFAGroupDetailTableViewController ()

// 数据存储工具
@property (nonatomic, strong) KFADataStoreTools *dataStoreTools;

@end

@implementation KFAGroupDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataStoreTools = [KFADataStoreTools create];
    _dataStoreTools.resourceName = @"KFACoreDataModel";
    
    self.navigationItem.title = self.ceo.name;
    
}

#pragma mark - 重写allWorkers的get方法
- (NSMutableArray *)allWorkers{
    if (!_allWorkers) {
        NSFetchRequest *workerFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KFAWorker"];
        NSSortDescriptor *workerSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
        [workerFetchRequest setSortDescriptors:@[workerSortDescriptor]];
        NSPredicate *workerPredicate = [NSPredicate predicateWithFormat:@"group = %@",self.group];
        [workerFetchRequest setPredicate:workerPredicate];
        NSError *error = nil;
        NSArray *array = [self.managedObjectContext executeFetchRequest:workerFetchRequest error:&error];
        if (!error) {
            _allWorkers = [[NSMutableArray alloc] initWithArray:array];
        }
    }
    return _allWorkers;
}

#pragma mark - 重写ceo的get方法
- (KFACeo *)ceo{
    if (!_ceo) {
        NSFetchRequest *ceoFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KFACeo"];
        NSPredicate *ceoPredicate = [NSPredicate predicateWithFormat:@"group = %@",self.group];
        [ceoFetchRequest setPredicate:ceoPredicate];
        NSError *error = nil;
        NSArray *array = [self.managedObjectContext executeFetchRequest:ceoFetchRequest error:&error];
        if (!error) {
            _ceo = [array firstObject];
        }
    }
    return _ceo;
}

#pragma mark - 重写managedObjectContext的get方法
- (NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        _managedObjectContext = _dataStoreTools.managedObjectContext;
    }
    return _managedObjectContext;
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

    return self.allWorkers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KFADetailCellID" forIndexPath:indexPath];
    
    KFAWorker *worker = self.allWorkers[indexPath.row];
    cell.textLabel.text = worker.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",worker.age];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
