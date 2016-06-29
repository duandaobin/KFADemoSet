//
//  ViewController.m
//  KFAImageHeightDemo
//
//  Created by 柯梵Aaron on 16/6/29.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "ImageDto.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray *imgUrlArr;
@property (nonatomic, copy) NSArray *datasourceArr;

@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datasourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.LoadedImageBlock = ^(NSString *imgUrl, CGFloat height){
            [self changeCellHeight:imgUrl height:height];
        };
    }
    
    ImageDto *dto = self.datasourceArr[indexPath.section];
    cell.imageUrl = dto.imageUrl;
    
    return cell;
}

-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageDto *dto = self.datasourceArr[indexPath.section];
    return dto.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)changeCellHeight:(NSString *)imgUrl height:(CGFloat)height {
    
    for (ImageDto *dto in self.datasourceArr) {
        if ([dto.imageUrl isEqualToString:imgUrl] && !dto.isResetHeight) {
            dto.height = height;
            dto.isResetHeight = YES;
            [self.tableView reloadData];
            break;
        }
    }
    
}

#pragma mark -
#pragma mark Properties

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)imgUrlArr {
    if (!_imgUrlArr) {
        _imgUrlArr = @[@"http://bcs.img.r1.91.com/data/upload/2015/01_14/15/201501141553480313.jpg",
                       @"http://big5.southcn.com/gate/big5/ent.southcn.com/8/images/attachement/jpg/site4/20160603/3/8359911509003130195.jpg",
                       @"http://zx.01ny.cn/uploadfile/2015/0404/20150404103325780.jpg",
                       @"http://static.zhidao.manmankan.com/kimages/201606/06_1465196264237922.jpg",
                       @"http://img1.shenchuang.com/2016/0617/1466128899443.jpg",
                       @"http://i2.hexunimg.cn/2016-06-08/184311457.jpg",
                       @"http://imgbdb2.bendibao.com/bjbdb/20147/16/201471616431771.jpg",
                       @"http://pic.nen.com.cn/600/16/35/53/16355335_848257.jpg",
                       @"http://image.ijq.tv/201508/19/09-23-01-15-13.jpg"];
    }
    return _imgUrlArr;
}

- (NSArray *)datasourceArr {
    if (!_datasourceArr) {
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *imageUrl in self.imgUrlArr) {
            ImageDto *dto = [[ImageDto alloc] init];
            dto.imageUrl = imageUrl;
            dto.height = 120;
            dto.isResetHeight = NO;
            [arr addObject:dto];
        }
        _datasourceArr = arr;
    }
    return _datasourceArr;
}

@end
