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
#import "KIWIKAddKit.h"

@interface KIWIKConnectViewController()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MDRadialProgressView *radialView2;
@end

@implementation KIWIKConnectViewController

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
    self.nextBtn.hidden = YES;
    
    self.imageView.image = [UIImage imageNamed:@"DoorLock_White"];
    
    float y = (self.imageView.bottom + SCREEN_HEIGHT) / 2.0f + 30.0f;
    
    self.radialView2 = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2.0 - 30, y, 60, 60)];
    self.radialView2.progressTotal = 100;
    self.radialView2.progressCounter = 0;
    self.radialView2.theme.thickness = 10;
    self.radialView2.theme.incompletedColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    self.radialView2.theme.completedColor = [UIColor whiteColor];
    self.radialView2.theme.sliceDividerHidden = YES;
    self.radialView2.label.textColor = [UIColor whiteColor];
    self.radialView2.label.shadowColor = [UIColor clearColor];
    [self.view addSubview:self.radialView2];
    
    [self searchDevice];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
}

-(void)backClicked:(id)sender {
    __weak __typeof(self)weakSelf = self;
    [[KIWIKUtils alertWithTitle:@"温馨提示" msg:@"您确定要停止添加吗？" ok:^(FRAlertController *al) {
        [GKIWIKSDK stop];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }] show];
}

-(void)searchDevice {
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK connectWithSSID:GKIWIKAddKit.ssid key:GKIWIKAddKit.key isLock:YES progressBlock:^(float progress) {
//    [GKIWIKSDK connectWithSSID:GKIWIKAddKit.ssid key:GKIWIKAddKit.key progressBlock:^(float progress) {
        [NSThread mainTask:^{
            weakSelf.radialView2.progressCounter = 100 * progress;
        }];
    } finishBlock:^(KIWIKDevice_Add *device) {
        [NSThread mainTask:^{
            KIWIKResultViewController *resultVC = [[KIWIKResultViewController alloc] initWithDevice:device];
            [weakSelf gotoVC:resultVC];
        }];
    }];
}

-(void)gotoVC:(UIViewController *)viewController {
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
    [array replaceObjectAtIndex:array.count - 1 withObject:viewController];
    self.navigationController.viewControllers = array;
}

-(void)timerFire {
    CALayer *waveLayer = [CALayer layer];
    waveLayer.frame = CGRectMake(0, 0, 120, 120);
    waveLayer.borderColor = [UIColor whiteColor].CGColor;
    waveLayer.borderWidth = 0.5;
    waveLayer.cornerRadius = 60.0;
    [self.imageView.layer addSublayer:waveLayer];
    [waveLayer begainScale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
