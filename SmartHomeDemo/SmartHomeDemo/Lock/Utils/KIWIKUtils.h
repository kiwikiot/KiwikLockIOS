//
//  KIWIKUtils.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRAlertController.h"

@interface KIWIKUtils : NSObject

+ (void)go2Wifi;

+ (NSString *)getSSID;

+ (NSString *)getLockAP;

+ (NSArray *)allSubviews:(UIView *)aView;

+ (FRAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg ok:(void(^)(FRAlertController *al))ok;

+(FRAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg cancel:(void(^)(FRAlertController *al))cancel ok:(void(^)(FRAlertController *al))ok;
@end

