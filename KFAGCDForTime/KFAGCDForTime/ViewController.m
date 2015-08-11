//
//  ViewController.m
//  KFAGCDForTime
//
//  Created by TangZhong on 15-8-10.
//  Copyright (c) 2015年 KeFan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *text; // 输入框
@property (weak, nonatomic) IBOutlet UIButton *btn; // 按钮


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 开始倒计时
- (IBAction)calculateTime:(id)sender {
    __block int timeout = 59; // 设置倒计时时间
    __weak typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 设置执行间隔时间
    dispatch_source_set_event_handler(timer, ^{
        if (timeout <= 0) {
            // 倒计时结束
            dispatch_source_cancel(timer);
            // 回到主线程执行动作
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.btn setTitle:@"发送验证码" forState:UIControlStateNormal];
                weakSelf.btn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout % 60;
            NSString *timeStr = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.btn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",timeStr] forState:UIControlStateNormal];
                weakSelf.btn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
