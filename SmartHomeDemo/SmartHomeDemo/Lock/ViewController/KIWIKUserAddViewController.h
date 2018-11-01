//
//  KIWIKUserAddViewController.h
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/8/2.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIWIKUser.h"

@interface KIWIKUserAddViewController : UIViewController

@property(nonatomic, strong) KIWIKUser *user;

- (instancetype)initWithDevice:(KIWIKDevice *)device;

@end
