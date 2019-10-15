//
//  KIWIKSDK.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIWIKSocket.h"
#import "KIWIKDevice.h"
#import "KIWIKEvent.h"
#import "KIWIKDevice_Add.h"
#import "KIWIKToken.h"
#import "KIWIKWifi.h"
#import "KIWIKConnect.h"

#define GKIWIKSDK          [KIWIKSDK shareInstance]

@protocol KIWIKSDKDelegate <NSObject>
-(void)loginChanged:(BOOL)success;
@end

@interface KIWIKSDK : NSObject

// Log开关
@property(nonatomic, assign) BOOL debug;

// YES时时测试服务器，正式版请设为NO
@property(nonatomic, assign) BOOL isTest;

// 是否登录成功
@property(nonatomic, assign, readonly) BOOL isLogin;

// 请联系我们提供
@property(nonatomic, strong) NSString *clientId;

@property(nonatomic, assign) id<KIWIKSDKDelegate> delegate;


+(KIWIKSDK *)shareInstance;

/*
* 检查是否登录成功
*
*
*  @param block           回调
*/
-(void)checkLogined:(void(^)(BOOL success, NSError *error))block;


/*
 * 设置token
 *
 *
 *  @param accessToken     token，通过服务器对接获取得到
 *  @param block           回调
 */
-(void)setToken:(KIWIKToken *)accessToken block:(void(^)(BOOL success, NSError *error))block;


/*
 * 网页登录
 *
 * 如果token过期，调用打开登录页面
 */
-(void)openLoginWebPage:(void(^)(KIWIKToken *accessToken))loginBlock;

/*
 * 清空token
 */
-(void)clearToken;

@end
