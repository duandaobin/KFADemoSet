//
//  KFAChatViewController.m
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAChatViewController.h"
#import "KFAXMPPManager.h"

@interface KFAChatViewController ()<UITableViewDataSource,UITableViewDelegate,XMPPStreamDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *chatView; // 对话框
@property (weak, nonatomic) IBOutlet UITextView *editView; // 编辑框
@property (weak, nonatomic) IBOutlet UIButton *senderButton;


@property (nonatomic, strong) NSMutableArray *messageArray;

@end

@implementation KFAChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [self changeStyleFrom:self.chatToStr];
    
    self.chatView.delegate = self;
    self.chatView.dataSource = self;
    self.editView.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    [self.chatView addGestureRecognizer:tap];
    
    self.messageArray = [[NSMutableArray alloc] init];
    
    [[KFAXMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMPPStreamDelegate方法
// 收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    [self fetchMessageData];
}
// 发送消息
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    [self fetchMessageData];
}

#pragma mark - UITableViewDelegate方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (self.messageArray.count) {
        XMPPMessageArchiving_Message_CoreDataObject *message = self.messageArray[indexPath.row];
        height = [self calculateWith:message.body];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chat" forIndexPath:indexPath];
    if (self.messageArray.count) {
        XMPPMessageArchiving_Message_CoreDataObject *message = self.messageArray[indexPath.row];
        if (message.isOutgoing) {
            cell.detailTextLabel.text = message.body;
            cell.textLabel.text = @"";
        }else {
            cell.textLabel.text = message.body;
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

#pragma mark - UITextViewDelegate方法
// 准备编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat ty = -(220 + 50);
    __weak typeof(self)temp = self;
    [UIView animateWithDuration:0.3 animations:^{
        temp.editView.transform = CGAffineTransformMakeTranslation(0, ty);
        temp.senderButton.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    return YES;
}

#pragma mark - private方法
// 发送
- (IBAction)sendMessage:(id)sender {
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:self.chatToStr resource:kResource]];
    [message addBody:self.editView.text];
    [[KFAXMPPManager defaultManager].xmppStream sendElement:message];
}
// 获得消息数据
- (void)fetchMessageData{
    NSManagedObjectContext *context = [KFAXMPPManager defaultManager].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //XMPPMessageArchiving_Message_CoreDataObject
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[KFAXMPPManager defaultManager].xmppStream.myJID.bare,self.chatToStr];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSArray *fetchArray = [context executeFetchRequest:fetchRequest error:nil];
    if (self.messageArray.count != 0) {
        [self.messageArray removeAllObjects];
    }
    [self.messageArray addObjectsFromArray:fetchArray];
    [self.chatView reloadData];
    if (self.messageArray.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0];
        [self.chatView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
// 计算自适应高度
- (CGFloat)calculateWith:(NSString *)string{
    CGFloat w = self.view.bounds.size.width;
    CGRect rect = [string boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    return rect.size.height;
}
// 转换字符串格式
- (NSString *)changeStyleFrom:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@"@"];
    return [array firstObject];
}
// 回收键盘
- (void)removeKeyboard{
    __weak typeof(self)temp = self;
    [UIView animateWithDuration:0.3 animations:^{
        temp.editView.transform = CGAffineTransformMakeTranslation(0, 0);
        temp.senderButton.transform = CGAffineTransformMakeTranslation(0, 0);
        [self.editView resignFirstResponder];
    }];
}

@end
