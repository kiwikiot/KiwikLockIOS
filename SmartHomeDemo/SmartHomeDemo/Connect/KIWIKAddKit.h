//
//  KIWIKAddKit.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GKIWIKAddKit [KIWIKAddKit sharedKIWIKAddKit]

@interface KIWIKAddKit : NSObject

@property (nonatomic, strong) NSString *ssid;
@property (nonatomic, strong) NSString *key;

SingletonH(KIWIKAddKit)

-(void)clearAll;

@end
