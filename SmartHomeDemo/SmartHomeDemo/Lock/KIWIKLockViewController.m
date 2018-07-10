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
#import "KIWIKPasswordView.h"
#import "KIWIKEvent+UI.h"

@interface KIWIKLockViewController ()<KIWIKHistoryDelegate, KIWIKDeviceDelegate>
@property (nonatomic, strong) KIWIKDevice *device;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *circleImageView2;
@property (nonatomic, strong) UIImageView *shadowImage;
@property (nonatomic, strong) KIWIKHistoryViewController *vc1;
@property (nonatomic, strong) KIWIKHistoryViewController *vc2;
@property (nonatomic, strong) KIWIKEvent *eventLatest;
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
    
    self.title = self.device.name ? self.device.name : @"LOCK";
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
    
    _vc1 = [[KIWIKHistoryViewController alloc] initWithDevice:self.device type:HistoryTypeUnlocking];
    _vc1.delegate = self;
    _vc2 = [[KIWIKHistoryViewController alloc] initWithDevice:self.device type:HistoryTypeAlarm];
    _vc2.delegate = self;
    self.viewControllers = @[ _vc1, _vc2 ];
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
    
    [self updateTopView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.device.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.device.delegate = nil;
    self.shadowImage.hidden = NO;//恢复导航栏下的线
}

-(void)updateTopView {
    if (_eventLatest) {
        UIColor *color = [_eventLatest headerColor];
        self.navigationController.navigationBar.barTintColor = color;
        self.headerView.backgroundColor = color;
        self.lockImageView.image = [_eventLatest headerImage];
    } else {
        self.navigationController.navigationBar.barTintColor = MAIN_THEME_COLOR;
        self.headerView.backgroundColor = MAIN_THEME_COLOR;
        self.lockImageView.image = [UIImage imageNamed:@"Door_Lock"];
    }
}

#pragma mark - KIWIKDeviceDelegate
-(void)device:(KIWIKDevice *)device usersChanged:(NSDictionary *)users {
    if (self.selectedIndex == 1) {
        [self.vc2 reload];
    } else {
        [self.vc1 reload];
    }
}

#pragma mark - KIWIKHistoryDelegate
-(void)eventListChanged:(NSDictionary *)list {
    NSMutableArray *eventArray = [NSMutableArray array];
    NSMutableArray *alarmArray = [NSMutableArray array];
    
    _eventLatest = nil;
    for (NSString *key in list.allKeys) {
        NSString *str = [list objectForKey:key];
        KIWIKEvent *event = [[KIWIKEvent alloc] initWithString:str];
        if ([event isLockWarning]) {
            [alarmArray addObject:event];
        } else {
            [eventArray addObject:event];
        }
        if (!_eventLatest || _eventLatest.time < event.time) {
            _eventLatest = event;
        }
    }
    [eventArray sortUsingComparator:^NSComparisonResult(KIWIKEvent* _Nonnull obj1, KIWIKEvent* _Nonnull obj2) {
        return obj1.time < obj2.time;
    }];
    [_vc1 setEventList:eventArray];
    
    [alarmArray sortUsingComparator:^NSComparisonResult(KIWIKEvent* _Nonnull obj1, KIWIKEvent* _Nonnull obj2) {
        return obj1.time < obj2.time;
    }];
    [_vc2 setEventList:alarmArray];
    
    [self updateTopView];
}

#pragma mark - Menu
-(void)onNavButtonTapped:(UIBarButtonItem *)sender event:(UIEvent *)event {
    __weak __typeof(self)weakSelf = self;
    NSArray *array = @[ NSLocalizedString(@"Rename", nil), NSLocalizedString(@"UserInfo", nil), NSLocalizedString(@"DeleteDevice", nil) ];
    [FTPopOverMenu showFromEvent:event withMenuArray:array doneBlock:^(NSInteger selectedIndex) {
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
                self.title = name ? name : @"LOCK";
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
        [KIWIKPasswordView showWithTimes:PasswordOnce pwdBlock:^(KIWIKPasswordView *pwdView, NSString *password) {
            [pwdView waitingWith:@"稍等..."];
            [weakSelf.device deleteDevice:password block:^(id response, NSError *error) {
                if (!error) {
                    [pwdView dismiss:^{
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                } else {
                    [pwdView showErrorWith:@"删除失败"];
                }
            }];
        }];
    }] show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
