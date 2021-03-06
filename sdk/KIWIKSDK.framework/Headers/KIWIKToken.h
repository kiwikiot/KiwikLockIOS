//
//  KIWIKToken.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KIWIKToken : NSObject

/*
 * access_token过期时，SDK会根据refresh_token和expires_at自动更新，请正确设置这两项
 */
@property(nonatomic, strong) NSString *access_token;

/*
 * access_token过期后，重新获取token的凭证
 */
@property(nonatomic, strong) NSString *refresh_token;

/*
 * 过期秒数，7200也就是两个小时
 */
@property(nonatomic, assign) NSInteger expires_in;

/*
 * 过期的时间，请将当时的时间加上expires_in
 * expires_at = [[NSDate date] timeIntervalSince1970] + expires_in
 */
@property(nonatomic, assign) NSInteger expires_at;

// 是否已经过期
-(BOOL)isValid;

@end
