//
//  KIWIKWIFIListViewController.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import "KIWIKWIFIListViewController.h"
#import "KIWIKWifiListCell.h"
#import "KIWIKWifiViewController.h"

@interface KIWIKWIFIListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray *wifiList;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation KIWIKWIFIListViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.wifiList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"附近Wi-Fi列表";
    self.tishiLabel.text = @"选择设备将要连接的Wi-Fi";
    [self.tishiLabel kw_fitSize];
    
    CGFloat height = SCREEN_HEIGHT - self.tishiLabel.bottom - 20 - 60.0f - SafeInsets_1.bottom;
    CGRect frame = CGRectMake(20, self.tishiLabel.bottom + 20, SCREEN_WIDTH - 40, height);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self)weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [KIWIKConnect wifiScan:^(NSArray * _Nonnull wifiList, NSError * _Nonnull error) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSLog(@"%s list %@", __func__, wifiList);
            [weakSelf.wifiList removeAllObjects];
            
            if (wifiList) {
                [weakSelf.wifiList addObjectsFromArray:wifiList];
            }
            [NSThread mainTask:^{
                [weakSelf.tableView reloadData];
            }];
        }];
    }];
    [_tableView.mj_header beginRefreshing];
}

-(void)nextAction:(id)sender {
    if (!_selectedIndexPath || _selectedIndexPath.row >= _wifiList.count) {
        [SVProgressHUD showInfoWithStatus:@"请选择Wi-Fi"];
        return;
    }
    KIWIKWifi *wifi = _wifiList[_selectedIndexPath.row];
    
    KIWIKWifiViewController *wifiVC = [[KIWIKWifiViewController alloc] init];
    wifiVC.ssid = wifi.ssid;
    [self.navigationController pushViewController:wifiVC animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_wifiList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    KIWIKWifiListCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[KIWIKWifiListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    cell.wifi = _wifiList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndexPath = indexPath;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    if (_selectedIndexPath) {
        KIWIKWifiListCell *cell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
        cell.selected = NO;
    }
    _selectedIndexPath = selectedIndexPath;
    
    KIWIKWifiListCell *cell1 = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    cell1.selected = YES;
}

@end
