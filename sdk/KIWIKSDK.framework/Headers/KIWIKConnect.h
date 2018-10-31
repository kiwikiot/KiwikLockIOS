//
//  KIWIKConnect.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIWIKWifi.h"
#import "KIWIKDevice_Add.h"

NS_ASSUME_NONNULL_BEGIN

@interface KIWIKConnect : NSObject

// 获取wifi列表
+(void)wifiScan:(void(^)(NSArray *wifiList, NSError *error))block;

// 配置wifi密码
+(void)settingWifi:(NSString *)ssid pwd:(NSString *)pwd block:(void(^)(KIWIKDevice_Add *dev, NSError *error))block;

@end

NS_ASSUME_NONNULL_END
