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

#define GKIWIKSDK [KIWIKSDK shareInstance]


@interface KIWIKSDK : NSObject


@property(nonatomic, assign) BOOL debug;


@property(nonatomic, strong) NSString *clientId;


// 用户ID，设置accessToken的时候自动获取
@property(nonatomic, strong, readonly) NSString *uid;


+(KIWIKSDK *)shareInstance;


-(void)setToken:(KIWIKToken *)accessToken block:(void(^)(BOOL success, NSError *error))block;


#pragma mark - Token
/*
 * SDK里面会对token持久化，该方法判断token是否过期
 */
-(BOOL)tokenIsValid;

/*
 * 网页登录
 *
 * 如果token过期，调用打开登录页面
 */
-(void)openKIWIKLoginPage:(void(^)(KIWIKToken *accessToken))loginBlock;

/*
 * 退出登录，清空token
 */
-(void)logout;


/*
 * 刷新token
 *
 *  @param token     旧的token，如果已经设置，这里可以不传
 *  @param block     新的token回调
 */
-(void)refreshToken:(KIWIKToken *)token
              block:(void(^)(KIWIKToken *newToken, NSError *error))block;

@end

