//
//  KIWIKUsersViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKUsersViewController.h"
#import "KIWIKUserAddViewController.h"
#import "KIWIKUser.h"

@interface KIWIKUsersViewController ()
@property (nonatomic, strong) KIWIKDevice *device;
@property (nonatomic, strong) NSMutableArray *userArray;
@end

@implementation KIWIKUsersViewController

- (instancetype)initWithDevice:(KIWIKDevice *)device {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedString(@"UserList", nil);
        self.device = device;
        self.userArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_THEME_BG_COLOR;
    self.hidesBottomBarWhenPushed = YES;
    if(OS_VERSION >= 7.0){
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction:)];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.device getUsers:^(id response, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (!error) {
                [weakSelf refreshTableView];
            } else {
                NSLog(@"error %@", error.description);
            }
        }];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = MAIN_THEME_COLOR;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshTableView];
}

-(void)refreshTableView {
    [_userArray removeAllObjects];
    NSDictionary *users = _device.userDict;
    for (NSString *key in users.allKeys) {
        KIWIKUser *user = [[KIWIKUser alloc] initWithId:[key integerValue] name:users[key]];
        [_userArray addSafeObject:user];
    }
    
    if (_userArray.count == 0) {
        [self.tableView showTips:NSLocalizedString(@"NoRecords", nil)];
    } else {
        [self.tableView hideTips];
    }
    
    [self.tableView reloadData];
}

-(void)addAction:(id)sender {
    KIWIKUserAddViewController *addVC = [[KIWIKUserAddViewController alloc] initWithDevice:self.device];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    KIWIKUser *user = [self.userArray objectAtIndex:indexPath.row];
    cell.imageView.image = [user userImage];
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"UserNo", nil), (long)user.userNo];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KIWIKUserAddViewController *addVC = [[KIWIKUserAddViewController alloc] initWithDevice:self.device];
    addVC.user = [self.userArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KIWIKUser *user = [self.userArray objectAtIndex:indexPath.row];
        __weak __typeof(self)weakSelf = self;
        [[KIWIKUtils alertWithTitle:@"温馨提示" msg:@"你确定要删除该备注名吗？" ok:^(FRAlertController *al) {
            [SVProgressHUD showWithStatus:@"稍等..."];
            [weakSelf.device deleteUser:user.userType userNo:user.userNo block:^(id response, NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"删除失败"];
                }
            }];
        }] show];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
@end
