//
//  KIWIKPasswordView.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PasswordOnce,
    PasswordTwice,
} PasswordTimes;

typedef NS_ENUM(NSInteger, PasswordStatus) {
    PasswordStatusFirstSetting = 0,
    PasswordStatusConfirmSetting,
    PasswordStatusConfirmFailed,
    PasswordStatusLessThan4,
    PasswordStatusDrawAPattern,
    PasswordStatusWaiting,
    PasswordStatusPasswordError,
};

@class KIWIKPasswordView;
typedef void(^PWDBlock)(KIWIKPasswordView *pwdView, NSString *password);
typedef void(^PWDFinish)(void);

@interface KIWIKPasswordView : UIView

+(BOOL)isShown;

+(KIWIKPasswordView *)showWithTimes:(PasswordTimes)times pwdBlock:(PWDBlock)pwdBlock;

-(void)startUnlock;

-(void)stopUnlock:(PWDFinish)block;

-(void)waitingWith:(NSString *)string;

-(void)showErrorWith:(NSString *)errStr;

-(void)dismiss:(PWDFinish)finish;

@end

//禁止复制粘贴的UITextField
#import "WTReTextField.h"
@interface YLPasswordTextFiled : WTReTextField

@end

@interface UIWindow(KIWIK)
@property(nonatomic, assign) BOOL isPasswordViewShown;
@end
