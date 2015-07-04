//
//  KFAXMPPManager.h
//  KFAXMPPDemo
//
//  Created by 柯梵Aaron on 15/7/3.
//  Copyright (c) 2015年 柯梵Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPFramework.h"

@interface KFAXMPPManager : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>

/**
 *  流
 */
@property (nonatomic, strong) XMPPStream *xmppStream;

/**
 *  花名册（好友列表）
 */
@property (nonatomic, strong) XMPPRoster *xmppRoster;

/**
 *  消息归档
 */
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

/**
 *  单例方法
 */
+ (KFAXMPPManager *)defaultManager;

/**
 *  登录
 *
 *  @param userName 用户名
 *  @param password 密码
 */
- (void)authenticateWith:(NSString *)userName and:(NSString *)password;

/**
 *  注册
 *
 *  @param userName 用户名
 *  @param password 密码
 */
- (void)registerWith:(NSString *)userName and:(NSString *)password;

/**
 *  退出
 */
- (void)exit;

/**
 *  添加好友
 *
 *  @param userName 要添加好友的身份
 */
- (void)addFriendWith:(XMPPJID *)userJid;

/**
 *  删除好友
 *
 *  @param userJid 要删除好友的身份
 */
- (void)removeFriendFrom:(XMPPJID *)userJid;

@end
