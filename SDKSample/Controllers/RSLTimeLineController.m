//
//  RSLTimeLineController.m
//  SilentLogSDKTest
//
//  Created by kazuhisa on 2016/09/13.
//  Copyright © 2016年 kazuhisa. All rights reserved.
//

#import "RSLTimeLineController.h"
#import "NSDate+Util.h"
#import "RSLUserData.h"
@import SilentLogSDK;
@import Masonry;

@interface RSLTimeLineController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation RSLTimeLineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *superview = self.tableView.superview;
    if (superview) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(superview);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    self.dataSource = @[];
    [self setUpDataSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)setupNavigationBar
{
    self.title = self.titleString;
    
    self.navigationController.navigationBarHidden = NO;
    
    [self.navigationController.navigationBar setNeedsLayout];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)setUpDataSource
{
    NSDateComponents *components = [self dateComponentsFrom:_date];
    [[SilentLogOperation sharedInstance] getDataForYear:components.year month:components.month day:components.day withCompletion:^(id responseObject){
        if (!responseObject) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tableView reloadData];
            });
        }
        
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *segments = responseObject[@"segments"];
            NSMutableArray *dataActivities = [NSMutableArray new];
            for (NSDictionary *segment in segments) {
                NSArray *activities = segment[@"activities"];
                for (NSDictionary *act in activities) {
                    [dataActivities addObject:act];
                }
            }
            self.dataSource = dataActivities;
            
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tableView reloadData];
            });
        }
    }];
}

- (NSDateComponents *)dateComponentsFrom:(NSDate *)date
{
    NSCalendar *cal = [NSDate ext_gregorianCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitHour |
                                    NSCalendarUnitMinute |
                                    NSCalendarUnitSecond
                                          fromDate:date];
    return components;
}

- (NSString *)getCellInfo:(NSDictionary *)dict
{
    NSString *actName = [self getActivityName:dict[@"activity"]];
    NSString *step = dict[@"steps"];
    NSTimeInterval start = [dict[@"startTime"] doubleValue];
    NSTimeInterval end = [dict[@"endTime"] doubleValue];
    NSDate *startTime = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:[NSDate dateWithTimeIntervalSince1970:start]];
    NSDate *endTime = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:[NSDate dateWithTimeIntervalSince1970:end]];
    NSArray *trackPoints = dict[@"trackPoints"];
    NSString *tag = @"noTag";
    if (dict[@"activityTag"]) {
        tag = dict[@"activityTag"][@"tagName"];
    }
    
    return [NSString stringWithFormat:@"type:%@\ntag:%@\n開始:%@\n終了:%@\n歩数:%@\n位置情報数:%@",actName,tag,startTime,endTime,step,@(trackPoints.count)];
}

- (NSString *)getActivityName:(NSString *)activityType
{
    NSString *activityName;
    if ([activityType isEqualToString:@"sty"]) {
        activityName = @"滞在";
    } else if ([activityType isEqualToString:@"trp"]) {
        activityName = @"乗り物";
    } else if ([activityType isEqualToString:@"wlk"]) {
        activityName = @"徒歩";
    }
    
    if (!activityName) {
        activityName = @"なし";
    }
    
    return activityName;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    __unused NSInteger row = indexPath.row;
    
    NSDictionary *dict = self.dataSource[row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [self getCellInfo:dict];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

@end
