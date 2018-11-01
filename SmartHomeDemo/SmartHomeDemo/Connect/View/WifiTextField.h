//
//  WifiTextField.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WifiTextFieldType){
    WifiTextFieldTypeWifi,
    WifiTextFieldTypePassword
};

@interface WifiTextField : UITextField

@property (nonatomic, assign) WifiTextFieldType fieldType;

@end
