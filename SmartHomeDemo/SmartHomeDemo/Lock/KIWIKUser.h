//
//  KIWIKUser.h
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/23.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KIWIKUser : NSObject

@property(nonatomic, assign) NSInteger userId;

@property(nonatomic, assign) NSInteger userType;

@property(nonatomic, assign) NSInteger userNo;

@property(nonatomic, strong) NSString *userName;

- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name;

- (UIImage *)userImage;

@end
