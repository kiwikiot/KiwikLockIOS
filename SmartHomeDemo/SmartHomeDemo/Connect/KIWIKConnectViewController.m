//
//  KIWIKConnectViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKConnectViewController.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "CALayer+Animation.h"
#import "KIWIKResultViewController.h"

@interface KIWIKConnectViewController()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) KIWIKDevice_Add *device;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger times;
@property (nonatomic, strong) MDRadialProgressView *radialView;
@end

@implementation KIWIKConnectViewController

-(instancetype)initWithDevice:(KIWIKDevice_Add *)device {
    self = [super init];
    if(self){
        self.device = device;
    }
    return self;
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"Connecting", nil);
    self.tishiLabel.hidden = YES;
    
    [self.nextBtn setTitle:@"重试" forState:UIControlStateNormal];
    self.nextBtn.hidden = YES;
    
    self.imageView.image = [UIImage imageNamed:@"DoorLock_White"];
    
    float y = (self.imageView.bottom + SCREEN_HEIGHT - 60.0f - SafeInsets_1.bottom) / 2 - 30.0f;
    
    _radialView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30, y, 60, 60)];
    _radialView.progressTotal = 100;
    _radialView.progressCounter = 0;
    _radialView.theme.thickness = 10;
    _radialView.theme.incompletedColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    _radialView.theme.completedColor = [UIColor whiteColor];
    _radialView.theme.sliceDividerHidden = YES;
    _radialView.label.textColor = [UIColor whiteColor];
    _radialView.label.shadowColor = [UIColor clearColor];
    [self.view addSubview:_radialView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self nextAction:nil];
}

-(void)nextAction:(id)sender {
    self.times = 0;
    self.nextBtn.hidden = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

-(void)timerFire {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.frame = CGRectMake(0, 0, 120, 120);
    waveLayer.borderColor = [UIColor whiteColor].CGColor;
    waveLayer.borderWidth = 0.5;
    waveLayer.cornerRadius = 60.0;
    [self.imageView.layer addSublayer:waveLayer];
    [waveLayer begainScale];
    
    _radialView.progressCounter = 100 * _times / 60.0;
    
    if (_times >= 60) {
        self.nextBtn.hidden = NO;
        [self stopTimer];
    }
    
    if (_times % 8 == 0) {
        __weak __typeof(self) weakSelf = self;
        [_device bind:^(id response, NSError *error) {
            if (response) {
                KIWIKResultViewController *resultVC = [[KIWIKResultViewController alloc] initWithDevice:weakSelf.device];
                [weakSelf gotoVC:resultVC];
            }
        }];
    }
    _times += 1;
}

-(void)backClicked:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [[KIWIKUtils alertWithTitle:@"温馨提示" msg:@"您确定要停止添加吗？" ok:^(FRAlertController *al) {
        [weakSelf stopTimer];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }] show];
}

-(void)gotoVC:(UIViewController *)viewController {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [array replaceObjectAtIndex:array.count - 1 withObject:viewController];
    self.navigationController.viewControllers = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
