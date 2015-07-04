//
//  KFARegisterViewController.m
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFARegisterViewController.h"
#import "KFAXMPPManager.h"

static NSString *kUserName = @"userName";
static NSString *kPassword = @"password";

@interface KFARegisterViewController ()<XMPPStreamDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

@implementation KFARegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加代理
    [[KFAXMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

#pragma mark - button方法
- (IBAction)register:(id)sender {
    [[KFAXMPPManager defaultManager] registerWith:self.userName.text and:self.password.text];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    // 注册验证成功后
    // 将注册成功的账号和密码传到登录界面
    self.handler(self.userName.text, self.password.text);
    //直接跳入登录界面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    // 注册验证失败后提醒
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"注册失败，请重新输入账号和密码注册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
