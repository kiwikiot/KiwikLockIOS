//
//  KIWIKAddKit.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKAddKit.h"

@implementation KIWIKAddKit

SingletonM(KIWIKAddKit, )

-(void)clearAll {
    self.ssid = nil;
    self.key = nil;
}

@end
