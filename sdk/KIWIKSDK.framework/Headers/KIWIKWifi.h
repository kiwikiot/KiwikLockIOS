//
//  KIWIKWifi.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KIWIKWifi : NSObject

// Wi-Fi名字
@property(nonatomic, strong) NSString *ssid;

// 加密方式
@property(nonatomic, strong) NSString *auth;

// 信号强度
@property(nonatomic, assign) NSInteger rssi;

@end

NS_ASSUME_NONNULL_END
