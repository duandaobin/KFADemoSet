//
//  ViewController.m
//  KFATelephoneDemo
//
//  Created by TangZhong on 15-7-30.
//  Copyright (c) 2015年 KeFan. All rights reserved.
//

#import "ViewController.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <sqlite3.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

@property (nonatomic, strong) NSDate *time;

@property (nonatomic, assign, getter=isDialing) BOOL dialing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    __weak typeof(self)weakSelf = self;
    // 监听手机的通话状态，并打印
    self.callCenter = [[CTCallCenter alloc] init];
    self.callCenter.callEventHandler = ^(CTCall *call){
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"Call has been disconnected");
            if (!weakSelf.isDialing) return;
            NSDate *time = [NSDate date];
            NSTimeInterval timeInterval = [time timeIntervalSinceDate:weakSelf.time];
            NSString *timeIntervalString = [weakSelf stringFromTimeInterval:timeInterval];
//            NSLog(@"-----%f",timeInterval);
//            NSLog(@"=====%@",timeIntervalString);
            [weakSelf.dataDictionary setObject:timeIntervalString forKey:@"callTime"];
            [weakSelf.dataArray addObject:weakSelf.dataDictionary];
            weakSelf.dialing = NO;
            weakSelf.dataDictionary = nil;
            weakSelf.time = nil;
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            NSLog(@"Call has just been connected");
            if (!weakSelf.isDialing) return;
            weakSelf.time = [NSDate date];
//            NSString *time = [[weakSelf getTimeFromNow] mutableCopy];
//            NSLog(@"Connected time is %@",time);
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            NSLog(@"Call is incoming");
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            NSLog(@"call is dialing");
            NSString *time = [weakSelf getTimeFromNow];
            //NSLog(@"Dialing time is %@",time);
            weakSelf.dialing = YES;
            weakSelf.dataDictionary = [@{@"phoneNumber":weakSelf.phoneNumber.text, @"time":time} mutableCopy];
        }
        else
        {  
            NSLog(@"Nothing is done");  
        }
    };
    /*
    NSSet *currenCalls = callCenter.currentCalls;
    if (!currenCalls) return;
    for (CTCall * call in currenCalls) {
        NSLog(@"====%@",call);
    }
     */
}

// 获取时长
- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval{
    int hour = timeInterval / 3600;
    int tempSecond = timeInterval - 3600 * hour;
    int minute = tempSecond / 60;
    int resultSecond = tempSecond - 60 * minute;
    NSString *timeIv = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,resultSecond];
    return timeIv;
}

// 获取当时时间
- (NSString *)getTimeFromNow{
    NSDate *time = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd hh:mm"];
    NSString *timeStr = [formatter stringFromDate:time];
    return timeStr;
}

// 拨打电话
- (IBAction)call:(id)sender {
    UIWebView *callView = [[UIWebView alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"tel:%@",self.phoneNumber.text];
    [callView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.view addSubview:callView];
}

// 通话记录
- (IBAction)callMenu:(id)sender {
    /*
    
        NSMutableArray *_dataArray = [[NSMutableArray alloc] init];
        
        [_dataArray removeAllObjects];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *callHisoryDatabasePath = @"var/wireless/Library/CallHistory/call_history.db";
        BOOL callHistoryFileExist = FALSE;
        callHistoryFileExist = [fileManager fileExistsAtPath:callHisoryDatabasePath];
        
        if(callHistoryFileExist)
        {
            if ([fileManager isReadableFileAtPath:callHisoryDatabasePath])
            {
                sqlite3 *database;
                if(sqlite3_open([callHisoryDatabasePath UTF8String], &database) == SQLITE_OK)
                {
                    sqlite3_stmt *compiledStatement;
//                    NSString *sqlStatement = [NSString stringWithString:@"SELECT * FROM call;"];
                    NSString *sqlStatement = @"SELECT * FROM call;";
                    int errorCode = sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1,  &compiledStatement, NULL);
                    if( errorCode == SQLITE_OK)
                    {
                        int count = 1;
                        
                        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                        {
                            // Read the data from the result row
                            NSMutableDictionary *callHistoryItem = [[NSMutableDictionary alloc] init];
                            int numberOfColumns = sqlite3_column_count(compiledStatement);
                            NSString *data;
                            NSString *columnName;
                            
                            for (int i = 0; i < numberOfColumns; i++)
                            {
                                columnName = [[NSString alloc] initWithUTF8String:
                                              (char *)sqlite3_column_name(compiledStatement, i)];
                                
                                data = [[NSString alloc] initWithUTF8String:
                                        (char *)sqlite3_column_text(compiledStatement, i)];
                                
                                [callHistoryItem setObject:data forKey:columnName];
                            }
                            
                            [_dataArray addObject:callHistoryItem];
                        }
                        
                        count++;
                    }
                    else
                    {
                        NSLog(@"Failed to retrieve table");
                        NSLog(@"Error Code: %d", errorCode);  
                    }  
                    sqlite3_finalize(compiledStatement);  
                }  
            }  
        }   
        NSLog(@"%@",_dataArray);  
   */
    NSLog(@"%@",self.dataArray);
    
    
}

// 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
