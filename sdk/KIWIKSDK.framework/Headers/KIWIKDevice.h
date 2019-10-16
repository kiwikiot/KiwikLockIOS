//
//  KIWIKDevice.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/17.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* 请求的回调，response为payload，error为错误，10000为token过期，10001为连接失败，10002为超时
*/
typedef void(^KIWIKRespBlock)(id response, NSError *error);


@interface KIWIKDevice : NSObject

/**
 * 设备ID
 */
@property(nonatomic, strong) NSString *did;

/**
 * 房间ID
 */
@property(nonatomic, strong) NSString *gid;

/**
 * 设备名
 */
@property(nonatomic, strong) NSString *name;

/**
 * 产品key
 */
@property(nonatomic, strong) NSString *pk;

/**
 * 设备类型
 */
@property(nonatomic, strong) NSString *type;

/**
 * 是否需要密码验证，门锁建议必须密码验证
 */
@property(nonatomic, assign) BOOL verify;

/**
 * 用户备注信息
 */
@property(nonatomic, strong) NSMutableDictionary *userDict;


/*
 * 设置设备名
 *
 *  @param name       设备名
 *  @param block      回调
 */
-(void)setDeviceName:(NSString *)name block:(KIWIKRespBlock)block;

/*
 * 获取设备能力集
 *
 *  @param block      回调
 */
-(void)getDeviceAblility:(KIWIKRespBlock)block;

/*
 * 获取设备详情
 *
 *  @param didArray   设备ID列表
 *  @param block      回调
 */
-(void)getDeviceInfo:(KIWIKRespBlock)block;

/*
 * 设备控制数据
 *
 *  @param data       控制数据
 *  @param block      回调
 */
-(void)ctrl:(NSData *)data block:(KIWIKRespBlock)block;


/*
 * 开关锁接口
 *
 *  @param state      1表示开锁，0表示关锁
 *  @param block      回调
 */
-(void)unlock:(BOOL)state block:(KIWIKRespBlock)block;

/*
 * 删除设备
 *
 *  @param block      回调
 */
-(void)deleteDevice:(KIWIKRespBlock)block;

/*
 * 读取设备事件记录
 *
 *  @param start      当前分页ID，最小为1，默认为1
 *  @param limit      分页大小，最大限制为100，默认为30
 *  @param block      回调
 */
-(void)getRecords:(NSInteger)start limit:(NSInteger)limit block:(KIWIKRespBlock)block;

/*
 * 设置事件用户ID备注
 *
 *  @param userType   用户类型
 *  @param userNo     用户编号
 *  @param name       用户名
 *  @param block      回调
 */
-(void)setUser:(NSInteger)userType userNo:(NSInteger)userNo name:(NSString *)name block:(KIWIKRespBlock)block;

/*
 * 删除事件用户ID备注
 *
 *  @param userType   用户类型
 *  @param userNo     用户编号
 *  @param block      回调
 */
-(void)deleteUser:(NSInteger)userType userNo:(NSInteger)userNo block:(KIWIKRespBlock)block;

/*
 * 读取事件用户ID备注列表
 *
 *  @param block      回调
 */
-(void)getUsers:(KIWIKRespBlock)block;

/*
 * 读取单个用户ID备注
 *
 *  @param userType   用户类型
 *  @param userNo     用户编号
 *  @param block      回调
 */
-(void)getUser:(NSInteger)userType userNo:(NSInteger)userNo block:(KIWIKRespBlock)block;

@end
