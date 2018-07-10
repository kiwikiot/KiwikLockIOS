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

@interface KIWIKHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property NSInteger selectedIndex;
@property (nonatomic, strong) KIWIKDevice *device;
@property (nonatomic, assign) HistoryType type;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation KIWIKHistoryViewController

- (instancetype)initWithDevice:(KIWIKDevice *)device type:(HistoryType)type {
    self = [super init];
    if (self) {
        self.device = device;
        self.type = type;
        self.dataArray = [NSMutableArray array];
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
    
    if (_type == HistoryTypeAlarm) {
        self.title = NSLocalizedString(@"AlarmRecords", nil);
    } else {
        self.title = NSLocalizedString(@"UnlockRecords", nil);
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
        [weakSelf.device getRecords:0 idMax:-1 count:10000 block:^(id response, NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (!error) {
                NSDictionary *list = [response objectForKey:@"list"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(eventListChanged:)]) {
                    [weakSelf.delegate eventListChanged:list];
                }
            } else {
                NSLog(@"getRecords error %@", error.description);
            }
        }];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)setEventList:(NSArray *)events {
    [_dataArray removeAllObjects];
    NSMutableArray *tmp = [NSMutableArray array];
    NSString *string = nil;
    for (int i = 0; i < events.count; i++) {
        KIWIKEvent *model = events[i];
        NSString *str = [model dayString];
        
        if (![str isEqualToString:string]) {
            if (tmp.count > 0) {
                NSArray *array = [[NSArray alloc]initWithArray:tmp];
                [_dataArray addObject:array];
                [tmp removeAllObjects];
            }
            string = str;
            [tmp addObject:model];
        }else{
            [tmp addObject:model];
        }
        
        if (i == events.count - 1) {
            if (tmp.count > 0) {
                NSArray *array = [[NSArray alloc]initWithArray:tmp];
                [_dataArray addObject:array];
                [tmp removeAllObjects];
            }
        }
    }
    
    if (events.count == 0) {
        [self.tableView showTips:NSLocalizedString(@"NoRecords", nil) centerY:self.tableView.boundsHeight * 0.5 - SafeInsets_1.bottom];
    }else{
        [self.tableView hideTips];
    }
    [self.tableView reloadData];
}

-(void)reload {
    [self.tableView reloadData];
}

#pragma mark - uitableviewdelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectedIndex == section) {
        return [self.dataArray[section] count];
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KIWIKEvent *event = self.dataArray[section][0];
    NSDate *date = [event dateTime];
    
    UIColor *color = [UIColor colorWithWhite:0.4 alpha:0.8];
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *ymLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 30)];
    ymLabel.font = [UIFont systemFontOfSize:20];
    ymLabel.textColor = color;
    ymLabel.text = [NSString stringWithFormat:@"%d/%02d/%02d", (int)date.year, (int)date.month, (int)date.day];
    [view addSubview:ymLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 10, 30, 30)];
    [view addSubview:imageView];
    if (section == self.selectedIndex) {
        imageView.image = [[UIImage imageNamed:@"arrow_down"] imageWithTintColor:color];
    } else {
        imageView.image = [[UIImage imageNamed:@"arrow_right"] imageWithTintColor:color];
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 50 - PixelOne, SCREEN_WIDTH, PixelOne);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view.layer addSublayer:layer];
    
    view.tag = section;
    [view addTarget:self action:@selector(headClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

-(void)headClicked:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (self.selectedIndex == button.tag) {
        self.selectedIndex = -1;
    } else {
        self.selectedIndex = button.tag;
    }
    [self.tableView reloadData];
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
    NSArray *tmp = self.dataArray[indexPath.section];
    KIWIKEvent *event = tmp[indexPath.row];
    cell.event = event;
    
    cell.detailTextLabel.text = [GKIWIKLockService userName:event device:self.device];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
