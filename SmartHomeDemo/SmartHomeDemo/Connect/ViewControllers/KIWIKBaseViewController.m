//
//  KIWIKBaseViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKBaseViewController.h"

@interface KIWIKBaseViewController ()

@end

@implementation KIWIKBaseViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_THEME_COLOR;
    self.hidesBottomBarWhenPushed = YES;
    if(OS_VERSION >= 7.0){
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, SafeInsets_1.top, 100, 40)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal];
    [button setImagePosition:LXMImagePositionLeft spacing:2];
    [button addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, button.bottom + 5.0f, SCREEN_WIDTH - 60, 25)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [self.view addSubview:_titleLabel];
    
    _tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, _titleLabel.bottom + 20.0f, SCREEN_WIDTH - 60, 100)];
    _tishiLabel.backgroundColor = [UIColor clearColor];
    _tishiLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _tishiLabel.textAlignment = NSTextAlignmentCenter;
    _tishiLabel.textColor = [UIColor whiteColor];
    _tishiLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    _tishiLabel.numberOfLines = 0;
    [self.view addSubview:_tishiLabel];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 60, self.titleLabel.top + 120, 120, 120)];
    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(30, SCREEN_HEIGHT - 60.0f - SafeInsets_1.bottom, SCREEN_WIDTH - 60, 40);
    [_nextBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.5] forState:UIControlStateHighlighted];
    [_nextBtn setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:0.5] forState:UIControlStateDisabled];
    [_nextBtn setTitle:NSLocalizedString(@"NextStep", nil) forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _nextBtn.layer.borderWidth = 1.0f;
    _nextBtn.layer.cornerRadius = 5.0f;
    [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
}

-(void)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextAction:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
