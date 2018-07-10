//
//  SocketManager.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/15.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIWIKDevice_Add.h"
#import "KIWIKDevice.h"
#import "KIWIKConstant.h"

#define GKIWIKSocket [KIWIKSocket shareInstance]

/**
 * 请求的回调，response为payload，error为错误，10000为token过期，10001为连接失败，10002为超时
 */
typedef void(^KIWIKResponseBlock)(id response, NSError *error);


@protocol KIWIKSocketDelegate <NSObject>
@optional
-(void)deviceListChanged:(NSArray *)deviceList;
@end


@interface KIWIKSocket : NSObject

/**
 * websocket超时，默认是10秒
 */
@property(nonatomic, assign) NSTimeInterval requestTimeout;


+(KIWIKSocket *)shareInstance;

/**
 * 设备列表
 */
@property(nonatomic, strong) NSArray *deviceList;

/**
 * 所有设备的用户
 */
@property(nonatomic, strong) NSMutableDictionary *userDict;


@property(nonatomic, assign) id<KIWIKSocketDelegate> delegate;

/**
 * 开启websocket，SDK内部会在登录后自动开启
 */
- (void)openSocket;

/**
 * 关闭websocket，一般不需要关闭
 */
- (void)closeSocket;


/*
 * 获取设备列表
 *
 *  @param block   回调，与其他接口不同的是response是设备列表
 */
-(void)getDevices:(KIWIKResponseBlock)block;

/*
 * 获取多个设备用户列表
 *
 *  @param didArray  设备ID列表
 *  @param block     回调
 */
-(void)getMultiUserIds:(NSArray *)didArray block:(KIWIKResponseBlock)block;


/*
 * 通用接口
 *
 *  @param np        域名，在KIWIKConstant.h有定义
 *  @param name      接口名，在KIWIKConstant.h有定义
 *  @param params    参数，根据《设备服务器接口列表.txt》中定义的
 *  @param block     回调
 */
-(void)request:(KIWIKNamepace)np name:(NSString *)name params:(NSDictionary *)params block:(KIWIKResponseBlock)block;

@end
