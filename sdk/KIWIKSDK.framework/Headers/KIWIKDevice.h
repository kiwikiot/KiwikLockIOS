//
//  KIWIKDevice.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/17.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KIWIKDevice;
@protocol KIWIKDeviceDelegate <NSObject>
@optional
-(void)device:(KIWIKDevice *)device usersChanged:(NSDictionary *)users;
@end

@interface KIWIKDevice : NSObject

/**
 * 设备ID
 */
@property(nonatomic, strong) NSString *did;

/**
 * 设备名
 */
@property(nonatomic, strong) NSString *name;

/**
 * 设备类型
 */
@property(nonatomic, strong) NSString *type;

/**
 * 是否需要密码验证，门锁建议必须密码验证
 */
@property(nonatomic, assign) BOOL verify;


@property(nonatomic, assign) id<KIWIKDeviceDelegate> delegate;


/*
 * 设置设备名
 *
 *  @param name       设备名
 *  @param block      回调
 */
-(void)setDeviceName:(NSString *)name block:(void(^)(id response, NSError *error))block;

/*
 * 开启或关闭验证
 *
 *  @param verify     YES / NO
 *  @param password   验证密码
 *  @param block      回调
 */
-(void)setDeviceSecurity:(BOOL)verify password:(NSString *)password block:(void(^)(id response, NSError *error))block;

/*
 * 获取设备详情
 *
 *  @param didArray   设备ID列表
 *  @param block      回调
 */
-(void)getDeviceInfo:(void(^)(id response, NSError *error))block;

/*
 * 设备控制数据
 *
 *  @param password   设备密码
 *  @param data       控制数据
 *  @param block      回调
 */
-(void)ctrl:(NSString *)password data:(NSData *)data block:(void(^)(id response, NSError *error))block;


/*
 * 开关锁接口
 *
 *  @param password   设备密码
 *  @param state      1表示开锁，0表示关锁
 *  @param block      回调
 */
-(void)unlock:(NSString *)password state:(BOOL)state block:(void(^)(id response, NSError *error))block;

/*
 * 删除设备
 *
 *  @param password   设备密码
 *  @param block      回调
 */
-(void)deleteDevice:(NSString *)password block:(void(^)(id response, NSError *error))block;

/*
 * 读取设备事件记录
 *
 *  @param idMin      最小消息ID
 *  @param diMax      最大消息ID，为-1是表示取最新的消息
 *  @param count      消息数量
 *  @param block      回调
 */
-(void)getRecords:(NSInteger)idMin idMax:(NSInteger)idMax count:(NSInteger)count block:(void(^)(id response, NSError *error))block;

/*
 * 设置事件用户ID备注
 *
 *  @param userId     用户ID
 *  @param name       用户名
 *  @param block      回调
 */
-(void)setUserId:(NSInteger)userId name:(NSString *)name block:(void(^)(id response, NSError *error))block;

/*
 * 删除事件用户ID备注
 *
 *  @param userId     用户ID
 *  @param block      回调
 */
-(void)deleteUserId:(NSInteger)userId block:(void(^)(id response, NSError *error))block;

/*
 * 读取事件用户ID备注列表
 *
 *  @param block      回调
 */
-(void)getUserIds:(void(^)(id response, NSError *error))block;

@end
