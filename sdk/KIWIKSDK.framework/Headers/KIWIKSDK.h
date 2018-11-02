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


@interface KIWIKSDK : NSObject

// Log开关
@property(nonatomic, assign) BOOL debug;

// 设为NO即可
@property(nonatomic, assign) BOOL isTest;

// 请联系我们提供
@property(nonatomic, strong) NSString *clientId;


+(KIWIKSDK *)shareInstance;


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

/*
 * 刷新token
 *
 *  @param token     旧的token，如果已经设置，这里可以不传
 *  @param block     新的token回调
 */
-(void)refreshToken:(KIWIKToken *)token
              block:(void(^)(KIWIKToken *newToken, NSError *error))block;

@end
