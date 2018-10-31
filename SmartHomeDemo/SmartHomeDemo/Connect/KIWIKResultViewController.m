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
    
    self.titleLabel.text = @"添加成功";
    
    self.imageView.image = [UIImage imageNamed:@"leading_right"];
    
    [self.nextBtn setTitle:@"完成" forState:UIControlStateNormal];
}

-(void)nextAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
