//
//  RSLDateController.m
//  SilentLogSDKTest
//
//  Created by kazuhisa on 2016/09/13.
//  Copyright © 2016年 kazuhisa. All rights reserved.
//

#import "RSLDateController.h"
#import "NSDate+Util.h"
#import "RSLUserData.h"
#import "RSLTimeLineController.h"
#import "AppDelegate.h"
@import SilentLogSDK;
@import Masonry;
@import SSZipArchive;
@import MessageUI;

#define kRSLDateTimeFormat_Display_Date    @"MMM d"

@interface RSLDateController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation RSLDateController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

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
    self.title = @"Sample";

    self.navigationController.navigationBarHidden = NO;

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] init];
    [leftButtonItem setTitle:@"log"];
    [leftButtonItem setTarget:self];
    [leftButtonItem setAction:@selector(zipLog:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] init];
    [rightButtonItem setTitle:@"detect"];
    [rightButtonItem setTarget:self];
    [rightButtonItem setAction:@selector(updateDetect:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

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
    NSDate *from = [RSLUserData loadAppInstallDate];
    NSDate *to   = [[NSDate date] ext_endOfDay];

    NSMutableArray *dateArray = [NSMutableArray new];
    NSInteger count = [NSDate daysBetweenFrom:from to:to] + 1;
    NSCalendar *calendar = [NSDate ext_gregorianCalendar];
    for (NSInteger i = 0; i < count; i++) {
        NSDateComponents *comps1 = [[NSDateComponents alloc]init];
        comps1.day = i;
        NSDate *result1 = [calendar dateByAddingComponents:comps1 toDate:from options:0];
        [dateArray addObject:result1];
    }

    self.dataSource = dateArray;

    dispatch_async(dispatch_get_main_queue(),^{
        [self.tableView reloadData];
    });

}

- (NSString *)stringFromDate:(NSDate *)date template:(NSString *)templateString withLocale:(NSLocale *)locale
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDate ext_gregorianDateFormatter];
    });
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:templateString options:0 locale:locale];
    dateFormatter.locale = locale;
    NSString *s = [dateFormatter stringFromDate:date];

    return s;
}

- (void)zipLog:(id)sender
{
    NSArray *logPaths = [[SilentLogOperation sharedInstance] getSDKLogPaths];
    NSString *firstLogPath = [logPaths firstObject];
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [array firstObject];
    NSString *filePath = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", [firstLogPath lastPathComponent]]];

    // 圧縮
    NSString *zippedFilePath = filePath;
    NSMutableArray *inputFilePaths = [NSMutableArray array];
    for (NSString *logPath in logPaths) {
        [inputFilePaths addObject:logPath];
    }
    BOOL isSuccess = [SSZipArchive createZipFileAtPath:zippedFilePath withFilesAtPaths:inputFilePaths];
    if (isSuccess) {
//        メールで添付
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        [controller setToRecipients:@[@"shihommatsu@rei-frontier.jp"]];
        [controller addAttachmentData:[NSData dataWithContentsOfFile:zippedFilePath]
                             mimeType:@"application/x-zip-compressed"
                             fileName:[zippedFilePath lastPathComponent]];
        controller.mailComposeDelegate = self;

        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)updateDetect:(id)sender
{
    [[SilentLogOperation sharedInstance] stopDangerousDrivingDetectWithHander:^(NSArray<NSDictionary*> *results) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@件 検知\n検知を続けますか？", @(results.count)] preferredStyle:UIAlertControllerStyleAlert];

            // 左から順にボタンが配置
            [alertController addAction:[UIAlertAction actionWithTitle:@"はい" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [[SilentLogOperation sharedInstance] startDangerousDrivingDetect];
                });
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"いいえ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            }]];

            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
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

    NSDate *date = self.dataSource[row];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *text = [self stringFromDate:date template:kRSLDateTimeFormat_Display_Date withLocale:locale];

    cell.textLabel.text = text;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __unused NSInteger row = indexPath.row;

    NSDate *date = self.dataSource[row];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *text = [self stringFromDate:date template:kRSLDateTimeFormat_Display_Date withLocale:locale];

    RSLTimeLineController *vc = [[RSLTimeLineController alloc] init];
    vc.date = date;
    vc.titleString = text;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Mail Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
