//
//  KIWIKUserAddViewController.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/8/2.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKUserAddViewController.h"

#define kUserTypeArray @[NSLocalizedString(@"DefaultUser", nil), NSLocalizedString(@"FingerprintUser", nil), NSLocalizedString(@"PasswordUser", nil), NSLocalizedString(@"CardUser", nil), NSLocalizedString(@"KeyUser", nil), NSLocalizedString(@"PhoneUser", nil), NSLocalizedString(@"user_face", nil), NSLocalizedString(@"user_palmprint", nil), NSLocalizedString(@"user_iris", nil)]

@interface KIWIKUserAddViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) KIWIKDevice *device;
@property(nonatomic, strong) UITextField *textField0;
@property(nonatomic, strong) UITextField *textField1;
@property(nonatomic, strong) UITextField *textField2;
@property(nonatomic, assign) NSInteger userType;
@end

@implementation KIWIKUserAddViewController

- (instancetype)initWithDevice:(KIWIKDevice *)device {
    self = [super init];
    if (self) {
        self.title = @"设置用户备注名字";
        self.device = device;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MAIN_THEME_BG_COLOR;
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    _textField0 = [self addTextField:NSLocalizedString(@"UserType", nil) y:20];
    _textField0.text = kUserTypeArray[_userType];
    _textField1 = [self addTextField:NSLocalizedString(@"UserNo", nil) y:20 + 56];
    _textField1.keyboardType = UIKeyboardTypeNumberPad;
    _textField2 = [self addTextField:NSLocalizedString(@"UserName", nil) y:20 + 56 * 2];
    _textField2.keyboardType = UIKeyboardTypeDefault;
}

-(UITextField *)addTextField:(NSString *)title y:(CGFloat)y {
    UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(20, y + 6, 80, 24)];
    label0.font = [UIFont systemFontOfSize:16.0f];
    label0.text = title;
    [self.view addSubview:label0];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, y, SCREEN_WIDTH-120, 36)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 36)];
    textField.font = [UIFont systemFontOfSize:16.0f];
    textField.layer.borderWidth = PixelOne;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.cornerRadius = 5;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    return textField;
}

-(void)saveAction {
    if (_textField1.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户编号"];
        return;
    }
    if (_textField2.text.length == 0) {
        [SVProgressHUD showInfoWithStatus:@"请输入用户名字"];
        return;
    }
    
    NSInteger userNo = [_textField1.text integerValue];
    NSString *userName = _textField2.text;
    
    NSInteger userId = (_userType << 16) + userNo;
    
    [SVProgressHUD showWithStatus:@"稍等..."];
    [self.device setUserId:userId name:userName block:^(id response, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"添加失败"];
        }
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _textField0) {
        [FRAlertController showSelectArrayController:self
                                               title:@"选择用户类型"
                                             message:nil
                                      preferredStyle:FRAlertControllerStyleAlert
                                         selectArray:kUserTypeArray
                                configurationHandler:^(NSInteger row) {
                                    self.userType = row;
                                    self.textField0.text = kUserTypeArray[row];
                                }];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
