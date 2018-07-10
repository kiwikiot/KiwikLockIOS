//
//  AddSuccessViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKResultViewController.h"

@interface KIWIKResultViewController ()
@property (nonatomic, strong) KIWIKDevice_Add *device;
@end

@implementation KIWIKResultViewController

-(instancetype)initWithDevice:(KIWIKDevice_Add *)device {
    self = [super init];
    if(self){
        self.device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_device) {
        self.titleLabel.text = @"添加成功";
        self.imageView.image = [UIImage imageNamed:@"leading_right"];
        [self.nextBtn setTitle:@"注册设备" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = @"添加失败";
        self.imageView.image = [UIImage imageNamed:@"leading_wrong"];
        [self.nextBtn setTitle:@"重试" forState:UIControlStateNormal];
    }
}

-(void)nextAction:(id)sender {
    if (_device) {
        __weak __typeof(self)weakSelf = self;
        [SVProgressHUD showWithStatus:@"注册中..."];
        [_device bind:^(id response, NSError *error) {
            NSLog(@"response %@ error %@", response, error.description);
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if (error.code == 10001) {
                    [SVProgressHUD dismiss];
                    [[KIWIKUtils alertWithTitle:@"请连接Wi-Fi" msg:@"请进入‘设置’-‘Wi-Fi’，连接可以上网的Wi-Fi之后再重试。" ok:^(FRAlertController *al) {
                        [KIWIKUtils go2Wifi];
                    }] show];
                } else {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }
        }];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
