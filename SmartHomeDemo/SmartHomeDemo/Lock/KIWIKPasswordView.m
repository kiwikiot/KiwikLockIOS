//
//  PatternPasswordView.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKPasswordView.h"

#define kPasswordLength  6
#define kDotTag 3000
#define kLineTag 1000

@interface KIWIKPasswordView()<UITextFieldDelegate>
@property (nonatomic, assign) PasswordTimes times;
@property (nonatomic, copy) PWDBlock pwdBlock;
@property (nonatomic, strong) YLPasswordTextFiled *textFiled;//输入文本框
@property (nonatomic, assign) PasswordStatus passwordStatus;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *circleImageView2;
@property (nonatomic, strong) NSString *lastPassword;
@property (strong, nonatomic) UILabel *infoLabel;
@property (nonatomic, assign) BOOL animationStarted;
@property (nonatomic, assign) NSInteger unlockTime;//10秒超时
@property (nonatomic, strong) NSTimer *unlockTimer;

@end

@implementation KIWIKPasswordView

+(KIWIKPasswordView *)showWithTimes:(PasswordTimes)times pwdBlock:(PWDBlock)pwdBlock {
    KIWIKPasswordView *pwdView = [[KIWIKPasswordView alloc] initWithTimes:times pwdBlock:pwdBlock];
    [KEY_WINDOW addSubview:pwdView];
    [KEY_WINDOW bringSubviewToFront:pwdView];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        pwdView.top = 0;
        KEY_WINDOW.isPasswordViewShown = YES;
    } completion:^(BOOL finished) {
        
    }];
    return pwdView;
}

+(BOOL)isShown {
    return KEY_WINDOW.isPasswordViewShown;
}

- (instancetype)initWithTimes:(PasswordTimes)times pwdBlock:(PWDBlock)pwdBlock {
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        self.backgroundColor = MAIN_THEME_BG_COLOR;
        self.times = times;
        self.pwdBlock = [pwdBlock copy];
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SafeInsets_1.top + 230)];
        headerView.backgroundColor = MAIN_THEME_COLOR;
        [self addSubview:headerView];
        
        UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, SafeInsets_1.top, 90, 44)];
        [backBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backBtn setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:backBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, SafeInsets_1.top, SCREEN_WIDTH - 200, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLabel.textColor = [UIColor whiteColor];
        [headerView addSubview:titleLabel];
        
        _lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 160) / 2.0f, titleLabel.bottom, 160, 160)];
        _lockImageView.image = [UIImage imageNamed:@"Door_Lock"];
        [headerView addSubview:_lockImageView];
        
        UIImageView *circleImageView1 = [[UIImageView alloc]initWithFrame:self.lockImageView.frame];
        circleImageView1.image = [UIImage imageNamed:@"DoorCircle1"];
        [headerView addSubview:circleImageView1];
        
        _circleImageView2 = [[UIImageView alloc]initWithFrame:self.lockImageView.frame];
        _circleImageView2.image = [UIImage imageNamed:@"DoorCircle2"];
        [headerView addSubview:_circleImageView2];
        
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, headerView.height - 25, SCREEN_WIDTH - 40, 20.0f)];
        _infoLabel.font = [UIFont systemFontOfSize:14];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:_infoLabel];
        
        _textFiled = [[YLPasswordTextFiled alloc]init];
        _textFiled.frame = CGRectMake(20, headerView.bottom + 20, SCREEN_WIDTH - 40, 40);
        _textFiled.backgroundColor = [UIColor whiteColor];
        _textFiled.layer.masksToBounds = YES;
        _textFiled.layer.borderColor = [UIColor grayColor].CGColor;
        _textFiled.layer.borderWidth = 1;
        _textFiled.layer.cornerRadius = 5;
        _textFiled.secureTextEntry = YES;
        _textFiled.delegate = self;
        _textFiled.tintColor = [UIColor clearColor];//看不到光标
        _textFiled.textColor = [UIColor clearColor];//看不到输入内容
        _textFiled.font = [UIFont systemFontOfSize:30];
        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        _textFiled.pattern = [NSString stringWithFormat:@"^\\d{%li}$",(long)kPasswordLength];
        [_textFiled addTarget:self action:@selector(textFiledEdingChanged) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textFiled];
        
        [_textFiled becomeFirstResponder];
        
        if (_times == PasswordOnce) {
            titleLabel.text = NSLocalizedString(@"InputPassword", nil);
            self.passwordStatus = PasswordStatusDrawAPattern;
        } else {
            titleLabel.text = NSLocalizedString(@"SetPassword", nil);
            self.passwordStatus = PasswordStatusFirstSetting;
        }
    }
    return self;
}

-(void)backAction:(id)sender {
    if (!self.animationStarted) {
        [self dismiss:nil];
    }
}

-(void)textFiledEdingChanged {
    NSInteger length = _textFiled.text.length;
    NSString *text = _textFiled.text;
    
    for(NSInteger i = 0; i < kPasswordLength; i++){
        UILabel *dotLabel = (UILabel *)[_textFiled viewWithTag:kDotTag + i];
        if(dotLabel){
            dotLabel.hidden = length <= i;
        }
    }
    [_textFiled sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (length < 6) {
        self.passwordStatus = PasswordStatusLessThan4;
        return;
    }
    NSString *password = [text substringToIndex:kPasswordLength];
    if (_times == PasswordOnce) {
        !_pwdBlock ?: _pwdBlock(self, password);
        return;
    }
    switch (_passwordStatus) {
        case PasswordStatusFirstSetting:
            self.lastPassword = password;
            self.textFiled.text = @"";
            self.passwordStatus = PasswordStatusConfirmSetting;
            break;
        case PasswordStatusLessThan4:
            if ([NSString isBlankString:_lastPassword]) {
                self.lastPassword = password;
                self.textFiled.text = @"";
                self.passwordStatus = PasswordStatusConfirmSetting;
            } else {
                if ([_lastPassword isEqualToString:password]) {
                    !_pwdBlock ?: _pwdBlock(self, password);
                } else {
                    self.textFiled.text = @"";
                    self.passwordStatus = PasswordStatusConfirmFailed;
                }
            }
            break;
        case PasswordStatusConfirmFailed:
            self.lastPassword = password;
            self.textFiled.text = @"";
            self.passwordStatus = PasswordStatusConfirmSetting;
            break;
        case PasswordStatusConfirmSetting:
            if ([_lastPassword isEqualToString:password]) {
                !_pwdBlock ?: _pwdBlock(self, password);
            } else {
                self.textFiled.text = @"";
                self.passwordStatus = PasswordStatusConfirmFailed;
            }
            break;
        case PasswordStatusDrawAPattern:
        case PasswordStatusPasswordError:
        default:
            break;
    }
}

-(void)setPasswordStatus:(PasswordStatus)passwordStatus {
    _passwordStatus = passwordStatus;
    
    switch (passwordStatus) {
        case PasswordStatusFirstSetting:
            _infoLabel.text = NSLocalizedString(@"InputPassword", nil);
            break;
        case PasswordStatusConfirmSetting:
            _infoLabel.text = NSLocalizedString(@"ConfirmPassword", nil);
            break;
        case PasswordStatusConfirmFailed:
            _infoLabel.text = NSLocalizedString(@"FailedConfirm", nil);
            break;
        case PasswordStatusLessThan4:
            _infoLabel.text = NSLocalizedString(@"NoLessThanSix", nil);
            break;
        case PasswordStatusDrawAPattern:
            _infoLabel.text = NSLocalizedString(@"InputPassword", nil);
            break;
        case PasswordStatusWaiting:
            _infoLabel.text = NSLocalizedString(@"Waiting", nil);
            break;
        case PasswordStatusPasswordError:
            _infoLabel.text = NSLocalizedString(@"UnlockFailed", nil);
            break;
        default:
            break;
    }
}

- (void)setAnimationStarted:(BOOL)animationStarted {
    if (_animationStarted == animationStarted) {
        return;
    }
    _animationStarted = animationStarted;
    if (animationStarted) {
        self.passwordStatus = PasswordStatusWaiting;
        self.userInteractionEnabled = NO;
        [self.circleImageView2.layer addRotateWithDuration:1.0];
        
    } else {
        self.passwordStatus = PasswordStatusPasswordError;
        self.userInteractionEnabled = YES;
        [self.circleImageView2.layer removeRotate];
        
    }
}

-(void)startUnlock {
    self.unlockTime = 10;
    self.unlockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeOut) userInfo:nil repeats:YES];
    self.animationStarted = YES;
    self.infoLabel.text = [NSString stringWithFormat:@"开锁中...(%02ld秒)", (long)self.unlockTime];
}

-(void)stopUnlock:(PWDFinish)block {
    [self.unlockTimer invalidate];
    self.unlockTimer = nil;
    self.animationStarted = NO;
    [self dismiss:block];
}

-(void)timeOut {
    _unlockTime -= 1;
    if (_unlockTime <= 0) {
        self.animationStarted = NO;
        self.infoLabel.text = @"超时";
        [self.unlockTimer invalidate];
        self.unlockTimer = nil;
    } else {
        self.infoLabel.text = [NSString stringWithFormat:@"开锁中...(%02ld秒)", (long)_unlockTime];
    }
}

-(void)waitingWith:(NSString *)string {
    self.animationStarted = YES;
    self.infoLabel.text = string;
}

-(void)showErrorWith:(NSString *)errStr {
    self.animationStarted = NO;
    self.infoLabel.text = errStr;
}

-(void)dismiss:(PWDFinish)finish {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        KEY_WINDOW.isPasswordViewShown = NO;
        !finish ?: finish();
    }];
}
@end

@implementation YLPasswordTextFiled
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat perWidth = (frame.size.width - kPasswordLength + 1)*1.0/kPasswordLength;
    for(NSInteger i = 0; i < kPasswordLength; i++){
        if(i < kPasswordLength - 1){
            UILabel *vLine = (UILabel *)[self viewWithTag:kLineTag + i];
            if(!vLine){
                vLine = [[UILabel alloc]init];
                vLine.tag = kLineTag + i;
                [self addSubview:vLine];
            }
            vLine.frame = CGRectMake(perWidth + (perWidth + 1)*i, 0, 1, frame.size.height);
            vLine.backgroundColor = [UIColor grayColor];
        }
        UILabel *dotLabel = (UILabel *)[self viewWithTag:kDotTag + i];
        if(!dotLabel){
            dotLabel = [[UILabel alloc]init];
            dotLabel.tag = kDotTag + i;
            [self addSubview:dotLabel];
        }
        dotLabel.frame = CGRectMake((perWidth + 1)*i + (perWidth - 10)*0.5, (frame.size.height - 10)*0.5, 10, 10);
        dotLabel.layer.masksToBounds = YES;
        dotLabel.layer.cornerRadius = 5;
        dotLabel.backgroundColor = [UIColor blackColor];
        dotLabel.hidden = YES;
    }
}

//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}

@end

#import <objc/runtime.h>
@implementation UIWindow(KIWIK)

-(BOOL)isPasswordViewShown {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)setIsPasswordViewShown:(BOOL)isPasswordViewShown {
    objc_setAssociatedObject(self, @selector(isPasswordViewShown), @(isPasswordViewShown), OBJC_ASSOCIATION_ASSIGN);
}

@end
