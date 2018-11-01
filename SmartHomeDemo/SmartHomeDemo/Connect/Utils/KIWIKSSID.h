//
//  KIWIKSSID.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GKIWIKSSID [KIWIKSSID sharedKIWIKSSID]

@interface KIWIKSSID : NSObject

SingletonH(KIWIKSSID)

-(void)saveSsid:(NSString *)ssid andKey:(NSString *)key;
-(NSString *)getKeyBySsid:(NSString *)ssid;
-(NSArray *)getAllSsid;

@end
