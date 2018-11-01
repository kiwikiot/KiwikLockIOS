//
//  KIWIKHistoryViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKHistoryViewController.h"
#import "KIWIKHistoryCell.h"
#import "KIWIKEvent+UI.h"
#import "KIWIKLockService.h"
#import "Pagination.h"

@interface KIWIKHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) KIWIKDevice *device;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) Pagination *pagination;
@end

@implementation KIWIKHistoryViewController

- (instancetype)initWithDevice:(KIWIKDevice *)device {
    self = [super init];
    if (self) {
        self.title = @"消息记录";
        self.device = device;
        self.dataArray = [NSMutableArray array];
        self.pagination = [[Pagination alloc] init];
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
    if (@available(iOS 11, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 180 - SafeInsets_2.top - SafeInsets_2.bottom);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.device getRecords:1 limit:30 block:^(id response, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (!error) {
                [weakSelf.dataArray removeAllObjects];
                
                if ([response objectForKey:@"messages"]) {
                    NSArray *messages = [response objectForKey:@"messages"];
                    for (NSString *str in messages) {
                        KIWIKEvent *event = [[KIWIKEvent alloc] initWithString:str];
                        [weakSelf.dataArray addObject:event];
                    }
                }
                if (weakSelf.dataArray.count == 0) {
                    [self.tableView showTips:NSLocalizedString(@"NoRecords", nil) centerY:self.tableView.boundsHeight * 0.5 - SafeInsets_1.bottom];
                } else {
                    [self.tableView hideTips];
                }
                [self.tableView reloadData];
                
                if ([response objectForKey:@"_pagination"]) {
                    NSDictionary *dict = [response objectForKey:@"_pagination"];
                    weakSelf.pagination = [Pagination mj_objectWithKeyValues:dict];
                }
                
                [weakSelf.tableView.mj_footer resetNoMoreData];
                
                KIWIKEvent *latest = [weakSelf.dataArray count] > 0 ? weakSelf.dataArray[0] : nil;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(latestEventChanged:)]) {
                    [weakSelf.delegate latestEventChanged:latest];
                }
            } else {
                NSLog(@"getRecords error %@", error.description);
            }
        }];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.pagination.hasMore) {
            [weakSelf.device getRecords:weakSelf.pagination.start + 1 limit:weakSelf.pagination.limit block:^(id response, NSError *error) {
                [weakSelf.tableView.mj_footer endRefreshing];
                
                if ([response objectForKey:@"messages"]) {
                    NSArray *messages = [response objectForKey:@"messages"];
                    for (NSString *str in messages) {
                        KIWIKEvent *event = [[KIWIKEvent alloc] initWithString:str];
                        [weakSelf.dataArray addObject:event];
                    }
                }
                [self.tableView reloadData];
                
                if ([response objectForKey:@"_pagination"]) {
                    NSDictionary *dict = [response objectForKey:@"_pagination"];
                    weakSelf.pagination = [Pagination mj_objectWithKeyValues:dict];
                }
            }];
        } else {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NNCDC addObserver:self selector:@selector(eventReceived:) name:kLockEventReceivedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [NNCDC removeObserver:self];
}

-(void)eventReceived:(NSNotification *)noti {
    KIWIKEvent *event = noti.object;
    NSString *did = [noti.userInfo objectForKey:@"did"];
    if ([_device.did isEqualToString:did]) {
        [_dataArray insertObject:event atIndex:0];
        [_tableView reloadData];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(latestEventChanged:)]) {
            [self.delegate latestEventChanged:event];
        }
    }
}

#pragma mark - uitableviewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
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
    return 60;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity = @"cell";
    KIWIKHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (!cell) {
        cell = [[KIWIKHistoryCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identity];
    }
    KIWIKEvent *event = self.dataArray[indexPath.row];
    cell.event = event;
    cell.detailTextLabel.text = [GKIWIKLockService userName:event device:self.device];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
