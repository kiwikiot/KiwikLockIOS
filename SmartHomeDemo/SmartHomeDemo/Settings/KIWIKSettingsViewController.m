//
//  KIWIKSettingsViewController.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/7/2.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKSettingsViewController.h"
#import "KIWIKPasswordView.h"

@interface KIWIKSettingsViewController ()

@end

@implementation KIWIKSettingsViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dict = @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    [self.navigationController.navigationBar setTitleTextAttributes:dict];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = MAIN_THEME_COLOR;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identi = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"设置安全密码";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[KIWIKUtils alertWithTitle:@"设置安全密码" msg:@"请设置长度为6的安全密码" ok:^(FRAlertController *al){
        [KIWIKPasswordView showWithTimes:PasswordOnce pwdBlock:^(KIWIKPasswordView *pwdView, NSString *password) {
            [pwdView waitingWith:@"稍等..."];
            [GKIWIKSDK setDevicePassword:password block:^(id response, NSError *error) {
                NSLog(@"%s response %@ error %@", __func__, response, error.description);
                [NSThread mainTask:^{
                    if (!error) {
                        [pwdView dismiss:^{
                            [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
                        }];
                    } else {
                        [pwdView showErrorWith:@"密码设置失败"];
                    }
                }];
            }];
        }];
    }] show];
}

@end
