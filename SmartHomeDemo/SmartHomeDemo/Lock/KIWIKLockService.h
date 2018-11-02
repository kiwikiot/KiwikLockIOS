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

@property(nonatomic, assign) NSInteger lockState; // 开锁状态，0-空闲；1-问询；2-发送命令；3-等待

SingletonH(KIWIKLockService)

-(void)start;

-(void)stop;

-(void)remoteUnlock:(KIWIKDevice *)device event:(KIWIKEvent *)event;

-(NSString *)userName:(KIWIKEvent *)event device:(KIWIKDevice *)device;

@end
