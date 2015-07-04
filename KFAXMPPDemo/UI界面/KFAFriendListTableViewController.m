//
//  KFAFriendListTableViewController.m
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAFriendListTableViewController.h"
#import "KFAXMPPManager.h"
#import "KFAChatViewController.h"

@interface KFAFriendListTableViewController ()<XMPPRosterDelegate>

@property (nonatomic, strong) NSMutableArray *rosterArray;

@end

@implementation KFAFriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rosterArray = [[NSMutableArray alloc] init];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[KFAXMPPManager defaultManager].xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMPPRosterDelegate方法
// 开始获取好友
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender{
    NSLog(@"开始获取好友");
}

/*
 "none" -- the user does not have a subscription to the contact's presence information, and the contact does not have a subscription to the user's presence information  (互相没有订阅)
 "to" -- the user has a subscription to the contact's presence information, but the contact does not have a subscription to the user's presence information   （你订阅了别人，同意了，但是没有订阅你）
 "from" -- the contact has a subscription to the user's presence information, but the user does not have a subscription to the contact's presence information   （你被订阅了）
 "both" -- both the user and the contact have subscriptions to each other's presence information    （互相订阅）
 */
// 获取好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item{
    NSString *jidString = [[item attributeForName:@"jid"] stringValue];
    NSString *subscription = [[item attributeForName:@"subscription"] stringValue];
    XMPPJID *jid = [XMPPJID jidWithString:jidString resource:kResource];
    if ([self.rosterArray containsObject:jid] || ![subscription isEqualToString:@"both"]) {
        return;
    }
    [self.rosterArray addObject:jid];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rosterArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// 停止获取好友
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender{
    NSLog(@"停止获取好友");
}

// 收到添加请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //self.jid = presence.from;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友请求" message:[NSString stringWithFormat:@"%@请求添加你为好友！",presence.from.user] preferredStyle:UIAlertControllerStyleAlert];
    //__weak typeof(self)temp = self;
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[KFAXMPPManager defaultManager].xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }];
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [[KFAXMPPManager defaultManager].xmppRoster rejectPresenceSubscriptionRequestFrom:presence.from];
    }];
    [alert addAction:acceptAction];
    [alert addAction:rejectAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rosterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
    
    XMPPJID *jid = self.rosterArray[indexPath.row];
    cell.textLabel.text = jid.user;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    XMPPJID *jid = self.rosterArray[indexPath.row];
    // 删除好友
    [[KFAXMPPManager defaultManager] removeFriendFrom:jid];
    [self.rosterArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - private方法
// 退出
- (IBAction)exitFromNow:(id)sender {
    // 退出
    [[KFAXMPPManager defaultManager] exit];
    // 返回登录界面
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"KFALoginAndRegister" bundle:nil];
    UIViewController *vc = [storyBoard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}
// 添加好友
- (IBAction)addFriend:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好友请求" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction *senderAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 取得alert上面textFeild的值
        UITextField *textField = [alert.textFields firstObject];
        NSString *userName = textField.text;
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",userName,kHostName]];
        [[KFAXMPPManager defaultManager] addFriendWith:jid];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:senderAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KFAChatViewController *chatVC = segue.destinationViewController;
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    XMPPJID *jid = self.rosterArray[indexPath.row];
    chatVC.chatToStr = jid.bare;
}

@end
