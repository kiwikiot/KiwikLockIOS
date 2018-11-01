//
//  KIWIKUser.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/23.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKUser.h"

@implementation KIWIKUser

- (instancetype)initWithId:(NSInteger)userId name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.userType = (userId >> 16) & 0xFFFF;
        self.userNo = userId & 0xFFFF;
        self.userName = name;
    }
    return self;
}

- (UIImage *)userImage {
    switch (self.userType) {
        case DoorLockUserTypeFinger:
            return [UIImage imageNamed:@"User_Fingerprint"];
        case DoorLockUserTypePhone:
            return [UIImage imageNamed:@"User_Phone"];
        case DoorLockUserTypePassword:
            return [UIImage imageNamed:@"User_Password"];
        case DoorLockUserTypeCard:
            return [UIImage imageNamed:@"User_IC"];
        case DoorLockUserTypeKey:
            return [UIImage imageNamed:@"User_Key"];
        default:
            return [UIImage imageNamed:@"User_Default"];
    }
}

@end
