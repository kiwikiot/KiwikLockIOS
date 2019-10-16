//
//  KIWIKDevice_Add.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/26.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIWIKDevice.h"

@interface KIWIKDevice_Add : NSObject

@property(nonatomic, strong) NSDictionary *mac;

@property(nonatomic, strong) NSString *masterDid;

@property(nonatomic, strong) NSString *pk;

@property(nonatomic, strong) NSString *gid;

@property(nonatomic, assign) BOOL verify;

/*
 * 绑定设备(AddDevice)
 *
 *  @param block      回调
 */
-(void)bind:(KIWIKRespBlock)block;

@end
