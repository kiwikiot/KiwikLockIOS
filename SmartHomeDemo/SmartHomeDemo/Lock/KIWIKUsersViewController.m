//
//  KIWIKUsersViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKUsersViewController.h"
#import "KIWIKUser.h"

@interface KIWIKUsersViewController ()<KIWIKDeviceDelegate>
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
        [weakSelf.device getUserIds:^(id response, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (!error) {
                [weakSelf rerfreshTableView];
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
    [self rerfreshTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.device.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.device.delegate = nil;
}

-(void)rerfreshTableView {
    [_userArray removeAllObjects];
    if ([GKIWIKSocket.userDict objectForKey:_device.did]) {
        NSDictionary *users = [GKIWIKSocket.userDict objectForKey:_device.did];
        for (NSString *key in users.allKeys) {
            KIWIKUser *user = [[KIWIKUser alloc] init];
            user.userNo = key;
            user.userName = users[key];
            [_userArray addSafeObject:user];
        }
    }
    [_userArray sortUsingComparator:^NSComparisonResult(KIWIKUser* _Nonnull obj1, KIWIKUser* _Nonnull obj2) {
        return [obj1.userNo integerValue] > [obj2.userNo integerValue];
    }];
    [self.tableView reloadData];
}

-(void)addAction:(id)sender {
    __weak __typeof(self)weakSelf = self;
    FRAlertController *alert = [KIWIKUtils alertWithTitle:@"设置用户备注名字" msg:@"请输入用户编号和用户名字" ok:^(FRAlertController *al) {
        UITextField *textField1 = [al.textFields objectAtIndex:0];
        UITextField *textField2 = [al.textFields objectAtIndex:1];
        NSInteger userId = [textField1.text integerValue];
        NSString *userName = textField2.text;
        
        [SVProgressHUD showWithStatus:@"稍等..."];
        [weakSelf.device setUserId:userId name:userName block:^(id response, NSError *error) {
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            } else {
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }
        }];
    }];
    [alert addTextFieldConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"UserNo", nil);
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addTextFieldConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"UserName", nil);
    }];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KIWIKDeviceDelegate
-(void)device:(KIWIKDevice *)device usersChanged:(NSDictionary *)users {
    [self rerfreshTableView];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    
    KIWIKUser *user = [self.userArray objectAtIndex:indexPath.row];
    cell.textLabel.text = user.userName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"UserNo", nil), user.userNo];
    return cell;
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
            [weakSelf.device deleteUserId:[user.userNo integerValue] block:^(id response, NSError *error) {
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