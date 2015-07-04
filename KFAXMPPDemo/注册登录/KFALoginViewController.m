//
//  KFALoginViewController.m
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFALoginViewController.h"
#import "KFAXMPPManager.h"
#import "KFARegisterViewController.h"

static NSString *kUserName = @"userName";
static NSString *kPassword = @"password";

@interface KFALoginViewController ()<XMPPStreamDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;

@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation KFALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // 添加代理
    [[KFAXMPPManager defaultManager].xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userName.text = [userDefaults valueForKey:kUserName];
    self.password.text = [userDefaults valueForKey:kPassword];
    //[[KFAXMPPManager defaultManager] authenticateWith:[userDefaults valueForKey:kUserName] and:[userDefaults valueForKey:kPassword]];
    
}

#pragma mark - button方法
- (IBAction)login:(id)sender {
    [[KFAXMPPManager defaultManager] authenticateWith:self.userName.text and:self.password.text];
}

- (IBAction)noLogin:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"找回密码" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"短信验证登录" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //[alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - XMPPStreamDelegate方法
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    // 登录验证成功之后
    // 保存登录验证成功的账号和密码
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:self.userName.text forKey:kUserName];
    [userDefaults setValue:self.password.text forKey:kPassword];
    [userDefaults synchronize];
    // 跳入对话页面
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    // 登录验证失败后提醒
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您的账号或者密码不正确，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIRsponder响应方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KFARegisterViewController *registerVC = segue.destinationViewController;
    __weak typeof(self)temp = self;
    registerVC.handler = ^(NSString *userName, NSString *password){
        temp.userName.text = userName;
        temp.password.text = password;
    };
    
}


@end
