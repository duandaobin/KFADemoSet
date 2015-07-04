//
//  KFAXMPPManager.m
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import "KFAXMPPManager.h"

// 定义枚举,代表登录或者注册
typedef NS_ENUM(NSInteger, KFAConnectToServerPurpose) {
    KFAConnectToServerPurposeLogin, // 登录
    KFAConnectToServerPurposeRegister, // 注册
};

@interface KFAXMPPManager ()

@property (nonatomic) KFAConnectToServerPurpose connectPurpose; // 枚举类型决定登录还是注册

@property (nonatomic, strong) NSString *loginPassword; // 登录密码
@property (nonatomic, strong) NSString *registerPassword; // 注册密码

@end

@implementation KFAXMPPManager

#pragma mark - 单例及初始化
static KFAXMPPManager *kManager = nil;

+ (KFAXMPPManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kManager = [[KFAXMPPManager alloc] init];
    });
    return kManager;
}

- (instancetype)init{
    if (self = [super init]) {
        // 初始化流
        self.xmppStream = [[XMPPStream alloc] init];
        self.xmppStream.hostName = kHostName;
        self.xmppStream.hostPort = kHostPort;
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        // 初始化花名册
        XMPPRosterCoreDataStorage *xmppRosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [self.xmppRoster activate:self.xmppStream];
        // 消息归档
        XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        self.xmppMessageArchiving  = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_main_queue()];
        // 激活
        [self.xmppMessageArchiving activate:self.xmppStream];
        self.managedObjectContext = xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    }
    return self;
}

#pragma mark - 外调方法
// 登录
- (void)authenticateWith:(NSString *)userName and:(NSString *)password{
    self.connectPurpose = KFAConnectToServerPurposeLogin;
    self.loginPassword = password;
    [self connectToServerWith:userName];
}
// 注册
- (void)registerWith:(NSString *)userName and:(NSString *)password{
    self.connectPurpose = KFAConnectToServerPurposeRegister;
    self.registerPassword = password;
    [self connectToServerWith:userName];
}
// 退出
- (void)exit{
    [self disconnectToServer];
}
// 添加好友
- (void)addFriendWith:(XMPPJID *)userJid{
    [self.xmppRoster subscribePresenceToUser:userJid];
}
// 删除好友
- (void)removeFriendFrom:(XMPPJID *)userJid{
    [self.xmppRoster unsubscribePresenceFromUser:userJid];
}

#pragma mark - XMPPStreamDelegate方法
#pragma mark - 连接
// 连接成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"连接成功");
    switch (self.connectPurpose) {
        case KFAConnectToServerPurposeLogin:
            // 登录验证
            [self.xmppStream authenticateWithPassword:self.loginPassword error:nil];
            break;
        case KFAConnectToServerPurposeRegister:
            // 注册验证
            [self.xmppStream registerWithPassword:self.registerPassword error:nil];
            break;
        default:
            break;
    }
}
// 连接超时
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"连接超时");
}
// 连接失败
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"连接失败");
}
#pragma mark - 登录验证
// 登录验证成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"登录验证成功");
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.xmppStream sendElement:presence];
}
// 登录验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    NSLog(@"登录验证失败");
}
#pragma mark - 注册验证
// 注册验证成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册验证成功");
}
// 注册验证失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    NSLog(@"注册验证失败");
}

#pragma mark - private方法
// 设置身份
- (void)connectToServerWith:(NSString *)userName{
    // 身份
    XMPPJID *jid = [XMPPJID jidWithUser:userName domain:kDomin resource:kResource];
    self.xmppStream.myJID = jid;
    [self connectToServer];
}

// 连接
- (void)connectToServer{
    if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
        // 断开连接
        [self disconnectToServer];
    }
    NSError *error = nil;
    [self.xmppStream connectWithTimeout:30 error:&error];
    if (error) {
        NSLog(@"error %@",error);
    }
}

// 断开连接
- (void)disconnectToServer{
    // 下线
    // 生成下线状态 (NSXMLElement)
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    // 插入信息
    [self.xmppStream sendElement:presence];
    // 断开与服务器连接
    [self.xmppStream disconnect];
}

@end
