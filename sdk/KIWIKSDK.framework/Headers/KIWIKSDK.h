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

#define GKIWIKSDK [KIWIKSDK shareInstance]

/*
 * 进度回调
 */
typedef void(^KIWIKProgressBlock)(float progress);

/*
 * 连接回调，device为优智云家兼容设备
 */
typedef void(^KIWIKFinishBlock)(KIWIKDevice_Add *device);


@interface KIWIKSDK : NSObject


@property(nonatomic, assign) BOOL debug;


@property(nonatomic, strong) NSString *clientId;


@property(nonatomic, strong) KIWIKToken *accessToken;


+(KIWIKSDK *)shareInstance;


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
 * 接口登录
 *
 * @param identifier    用户账号
 * @param clientSecret  跟clientId配套分配的密钥，请注意保存
 */
-(void)loginWithIdentifier:(NSString *)identifier
              clientSecret:(NSString *)secret
                     block:(void(^)(KIWIKToken *accessToken, NSError *error))block;

/*
 * 退出登录，清空token
 */
-(void)logout;


#pragma mark - Connect

/*
 * 热点连接的方法
 *
 *  @param ssid        目标热点名字
 *  @param key         目标热点密码
 *  @param isLock      添加锁的时候传入YES，其他的为NO
 *  @param progressBlock  进度回调
 *  @param finishBlock  结果回调
 */
-(void)connectWithSSID:(NSString *)ssid
                   key:(NSString *)key
                isLock:(NSInteger)isLock
         progressBlock:(KIWIKProgressBlock)progressBlock
           finishBlock:(KIWIKFinishBlock)finishBlock;

/*
 * 热点连接的方法（需要固件的支持）
 *
 *  @param ssid        目标热点名字
 *  @param key         目标热点密码
 *  @param progressBlock  进度回调
 *  @param finishBlock  结果回调
 */
-(void)connectWithSSID:(NSString *)ssid
                   key:(NSString *)key
         progressBlock:(KIWIKProgressBlock)progressBlock
           finishBlock:(KIWIKFinishBlock)finishBlock;

/*
 * 停止连接
 */
-(void)stop;


/*
 * 刷新token
 *
 *  @param token     旧的token，如果GKIWIKSDK.accessToken已经设置，这里可以不传
 *  @param block     新的token回调
 */
-(void)refreshToken:(KIWIKToken *)token
              block:(void(^)(KIWIKToken *newToken, NSError *error))block;

/*
 * 设置设备密码
 *
 *  @param password  密码
 *  @param block     结果回调
 */
-(void)setDevicePassword:(NSString *)password
                   block:(void(^)(id response, NSError *error))block;

@end

