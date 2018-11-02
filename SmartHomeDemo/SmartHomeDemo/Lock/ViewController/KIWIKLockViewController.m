//
//  KIWIKLockViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKLockViewController.h"
#import "KIWIKHistoryViewController.h"
#import "KIWIKUsersViewController.h"
#import "KIWIKEvent+UI.h"
#import "KIWIKLockService.h"

@interface KIWIKLockViewController ()<KIWIKHistoryDelegate>
@property (nonatomic, strong) KIWIKDevice *device;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *circleImageView2;
@property (nonatomic, strong) UIImageView *shadowImage;
@property (nonatomic, strong) KIWIKHistoryViewController *vc1;
@end

@implementation KIWIKLockViewController

- (instancetype)initWithDevice:(KIWIKDevice *)device {
    self = [super init];
    if (self) {
        self.device = device;
    }
    return self;
}

-(void)dealloc {
    [NNCDC removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_THEME_BG_COLOR;
    self.hidesBottomBarWhenPushed = YES;
    if(OS_VERSION >= 7.0){
        self.extendedLayoutIncludesOpaqueBars=YES;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    self.title = self.device.name.length ? self.device.name : @"LOCK";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"More", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onNavButtonTapped:event:)];
    
    AXStretchableHeaderView *headerView = [[AXStretchableHeaderView alloc]initWithFrame:CGRectMake(0, 0.0f, SCREEN_WIDTH, 180.0f)];
    headerView.bounces = NO;
    headerView.minimumOfHeight = 180.0f;
    headerView.maximumOfHeight = 180.0f;
    self.headerView = headerView;
    self.shouldBounceHeaderView = NO;
    
    _lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 160) * 0.5, 5.0f, 160.0f, 160.0f)];
    [headerView addSubview:_lockImageView];
    
    UIImageView *circleImageView1 = [[UIImageView alloc]initWithFrame:_lockImageView.frame];
    circleImageView1.image = [UIImage imageNamed:@"DoorCircle1"];
    [headerView addSubview:circleImageView1];
    
    _circleImageView2 = [[UIImageView alloc]initWithFrame:_lockImageView.frame];
    _circleImageView2.image = [UIImage imageNamed:@"DoorCircle2"];
    [headerView addSubview:_circleImageView2];
    
    _vc1 = [[KIWIKHistoryViewController alloc] initWithDevice:self.device];
    _vc1.delegate = self;
    self.viewControllers = @[ _vc1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    //隐藏导航栏下的线
    NSArray *subViews = [KIWIKUtils allSubviews:self.navigationController.navigationBar];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height < 1){
            self.shadowImage =  (UIImageView *)view;
            self.shadowImage.hidden = YES;
            break;
        }
    }
    [self latestEventChanged:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shadowImage.hidden = NO;//恢复导航栏下的线
}

#pragma mark - KIWIKHistoryDelegate
-(void)latestEventChanged:(KIWIKEvent *)event {
    if (event) {
        UIColor *color = [event headerColor];
        self.navigationController.navigationBar.barTintColor = color;
        self.headerView.backgroundColor = color;
        self.lockImageView.image = [event headerImage];
    } else {
        self.navigationController.navigationBar.barTintColor = MAIN_THEME_COLOR;
        self.headerView.backgroundColor = MAIN_THEME_COLOR;
        self.lockImageView.image = [UIImage imageNamed:@"Door_Lock"];
    }
    
    if ([event remoteRequestValid] && GKIWIKLockService.lockState == 0) {
        [GKIWIKLockService remoteUnlock:self.device event:event];
    }
}

#pragma mark - Menu
-(void)onNavButtonTapped:(UIBarButtonItem *)sender event:(UIEvent *)event {
    __weak __typeof(self)weakSelf = self;
    NSArray *array = @[ NSLocalizedString(@"Rename", nil), NSLocalizedString(@"UserInfo", nil), NSLocalizedString(@"DeleteDevice", nil) ];
    
    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.backgroundColor = [UIColor whiteColor];
    config.textAlignment = NSTextAlignmentCenter;
    config.textFont = [UIFont systemFontOfSize:16];
    config.textAlignment = NSTextAlignmentCenter;
    config.textColor = [UIColor blackColor];
    
    [FTPopOverMenu showFromEvent:event withMenuArray:array imageArray:nil configuration:config doneBlock:^(NSInteger selectedIndex) {
        if (selectedIndex == 0) {
            [weakSelf renameAction];
        } else if (selectedIndex == 1) {
            KIWIKUsersViewController *userVC = [[KIWIKUsersViewController alloc] initWithDevice:self.device];
            [weakSelf.navigationController pushViewController:userVC animated:YES];
        } else {
            [weakSelf deleteAction];
        }
    } dismissBlock: nil];
}

-(void)renameAction {
    __weak __typeof(self)weakSelf = self;
    FRAlertController *alert = [KIWIKUtils alertWithTitle:NSLocalizedString(@"Rename", nil) msg:@"输入设备名" ok:^(FRAlertController *al){
        UITextField *textField = [al.textFields firstObject];
        [SVProgressHUD showWithStatus:@"稍等..."];
        NSString *name = textField.text;
        if (name.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"输入的名字为空"];
            return;
        }
        [weakSelf.device setDeviceName:name block:^(id response, NSError *error) {
            if (!error) {
                self.title = name.length ? name : @"LOCK";
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"修改失败"];
            }
        }];
    }];
    [alert addTextFieldConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = weakSelf.device.name;
        textField.placeholder = @"设备名";
    }];
    [alert show];
}

-(void)deleteAction {
    __weak __typeof(self)weakSelf = self;
    [[KIWIKUtils alertWithTitle:@"删除设备" msg:@"你确定要删除设备吗？" ok:^(FRAlertController *al){
        [weakSelf.device deleteDevice:^(id response, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"删除失败"];
            }
        }];
    }] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
