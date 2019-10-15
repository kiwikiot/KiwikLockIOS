//
//  KIWIKDevicesViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKDevicesViewController.h"
#import "KIWIKHotspotViewController.h"
#import "KIWIKLockViewController.h"
#import "FRAlertController.h"

@interface KIWIKDevicesViewController ()<KIWIKSDKDelegate, KIWIKSocketDelegate>
@property(nonatomic, strong) UIBarButtonItem *leftItem;
@end

@implementation KIWIKDevicesViewController

- (void)dealloc {
    GKIWIKSocket.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设备列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.hidesBottomBarWhenPushed = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
    
    NSDictionary *dict = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.leftItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(loginAction:)];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [GKIWIKSocket getLocks:^(id response, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }
        }];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    GKIWIKSocket.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = MAIN_THEME_COLOR;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    GKIWIKSDK.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self deviceListChanged:nil];
}

-(void)loginAction:(id)sender {
    if (GKIWIKSDK.isLogin) {
        [[KIWIKUtils alertWithTitle:@"确定要退出登录吗？" msg:nil ok:^(FRAlertController *al) {
            [APPDelegate logout];
        }] show];
    } else {
        [APPDelegate login];
    }
}

-(void)addAction:(id)sender {
    KIWIKHotspotViewController *hotspotVC = [[KIWIKHotspotViewController alloc] init];
    [self.navigationController pushViewController:hotspotVC animated:YES];
}

#pragma mark - KIWIKSDKDelegate
-(void)loginChanged:(BOOL)success {
    [NSThread mainTask:^{
        self.leftItem.title = success ? @"退出登录" : @"登录";
    }];
}

#pragma mark - KIWIKSocketDelegate
-(void)deviceListChanged:(NSArray *)deviceList {
    [NSThread mainTask:^{
        if (GKIWIKSocket.deviceList.count == 0) {
            [self.tableView showTips:NSLocalizedString(@"NoRecords", nil)];
        } else {
            [self.tableView hideTips];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [GKIWIKSocket.deviceList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identi];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor whiteColor];
    }
    KIWIKDevice *device = GKIWIKSocket.deviceList[indexPath.row];
    cell.imageView.image = [[UIImage imageNamed:@"DoorLock_White"] imageWithTintColor:MAIN_THEME_COLOR];
    cell.textLabel.text = device.name.length ? device.name : @"LOCK";
    cell.detailTextLabel.text = device.did;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KIWIKDevice *device = GKIWIKSocket.deviceList[indexPath.row];
    KIWIKLockViewController *vc = [[KIWIKLockViewController alloc] initWithDevice:device];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
