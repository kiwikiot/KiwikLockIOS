//
//  WifiTextField.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "WifiTextField.h"

@implementation WifiTextField

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.font = [UIFont systemFontOfSize:16.0];
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 10.0f;
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [rightBtn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
        self.rightViewMode = UITextFieldViewModeAlways;
        self.rightView = rightBtn;
    }
    return self;
}

-(void)setFieldType:(WifiTextFieldType)fieldType {
    _fieldType = fieldType;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    imageview.backgroundColor = [UIColor clearColor];
    if(fieldType == WifiTextFieldTypeWifi){
        imageview.image = [UIImage imageNamed:@"wifi"];
        self.placeholder = NSLocalizedString(@"WiFi", nil);
        
        UIButton *rightBtn = (UIButton *)self.rightView;
        [rightBtn setImage:[UIImage imageNamed:@"icon_settings"] forState:UIControlStateNormal];
    } else {
        imageview.image = [UIImage imageNamed:@"password"];
        self.placeholder = NSLocalizedString(@"Password", nil);
        
        self.secureTextEntry = YES;
        
        UIImage *img_close = [[UIImage imageNamed:@"eye_close"] imageWithTintColor:[UIColor whiteColor]];
        UIImage *img_open = [[UIImage imageNamed:@"eye_open"] imageWithTintColor:[UIColor whiteColor]];
        UIButton *rightBtn = (UIButton *)self.rightView;
        [rightBtn setImage:img_close forState:UIControlStateNormal];
        [rightBtn setImage:img_open forState:UIControlStateSelected];
    }
    self.leftView = imageview;
}

-(void)touchUp:(UIButton *)sender {
    if (_fieldType == WifiTextFieldTypePassword) {
        self.secureTextEntry = !self.secureTextEntry;
        sender.selected = !sender.selected;
    }
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    UIFont *font = [UIFont systemFontOfSize:16];
    UIColor *color = [UIColor colorWithWhite:.9 alpha:.9];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    NSDictionary *attributes = @{ NSFontAttributeName: font, NSForegroundColorAttributeName: color };
    [[self placeholder] drawInRect:rect withAttributes:attributes];
#else
    [color setFill];
    [[self placeholder] drawInRect:rect withFont:font];
#endif
}

@end
