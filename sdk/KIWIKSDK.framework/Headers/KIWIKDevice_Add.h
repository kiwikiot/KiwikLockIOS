//
//  KIWIKDevice_Add.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/26.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KIWIKDevice_Add : NSObject

@property(nonatomic, strong) NSDictionary *mac;

@property(nonatomic, strong) NSString *masterDid;

@property(nonatomic, strong) NSString *pk;

/*
 * 绑定设备(AddDevice)
 *
 *  @param block      回调
 */
-(void)bind:(void(^)(id response, NSError *error))block;

@end
