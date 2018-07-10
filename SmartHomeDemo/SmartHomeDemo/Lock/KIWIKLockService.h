//
//  KIWIKLockService.h
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/22.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GKIWIKLockService [KIWIKLockService sharedKIWIKLockService]

@interface KIWIKLockService : NSObject

SingletonH(KIWIKLockService)

-(void)start;

-(void)stop;

-(NSString *)userName:(KIWIKEvent *)event device:(KIWIKDevice *)device;

@end
