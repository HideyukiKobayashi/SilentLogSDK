//
//  ViewController.m
//  SilentLogSDKTest
//
//  Created by kazuhisa on 2016/09/13.
//  Copyright © 2016年 kazuhisa. All rights reserved.
//

#import "ViewController.h"
#import "RSLDateController.h"
@import SilentLogSDK;
@import Masonry;

@interface ViewController ()

//@property (nonatomic, strong) UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *safeDrive; // added
@property (weak, nonatomic) IBOutlet UIButton *dangerousDrive; // added
@property (weak, nonatomic) IBOutlet UIImageView *safeDriveImage; // added
@property (weak, nonatomic) IBOutlet UIImageView *dangerousDriveImage; // added
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _safeDrive.enabled = NO; //added
    _dangerousDrive.enabled = YES; // added
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];

//    {
//        UIView *buttonView1 = [[UIView alloc] init];
//        buttonView1.layer.cornerRadius = 2;
//        [view addSubview:buttonView1];
//        [buttonView1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@0);
//            make.left.equalTo(@0);
//            make.right.equalTo(@0);
//            make.height.equalTo(@60);
//        }];
//
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.text = @"位置情報の取得に許可する";
//        [buttonView1 addSubview:label1];
//        [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(@0);
//        }];
//
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonA:)];
//        [buttonView1 addGestureRecognizer:tap];
//    }
    
//    {
//        UIView *buttonView1 = [[UIView alloc] init];
//        buttonView1.layer.cornerRadius = 2;
//        [view addSubview:buttonView1];
//        [buttonView1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@70);
//            make.left.equalTo(@0);
//            make.right.equalTo(@0);
//            make.height.equalTo(@60);
//        }];
//
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.text = @"モーションとアクティビティの取得に許可する";
//        [buttonView1 addSubview:label1];
//        [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(@0);
//        }];
//
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonB:)];
//        [buttonView1 addGestureRecognizer:tap];
//    }
    
//    {
//        UIView *buttonView1 = [[UIView alloc] init];
//        buttonView1.layer.cornerRadius = 2;
//        [view addSubview:buttonView1];
//        [buttonView1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@140);
//            make.left.equalTo(@0);
//            make.right.equalTo(@0);
//            make.height.equalTo(@60);
//        }];
//        
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.text = @"プッシュ通知に許可する";
//        [buttonView1 addSubview:label1];
//        [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(@0);
//        }];
//        
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonC:)];
//        [buttonView1 addGestureRecognizer:tap];
//    }
    
//    {
//        UIView *buttonView1 = [[UIView alloc] init];
//        buttonView1.layer.cornerRadius = 2;
//        [view addSubview:buttonView1];
//        [buttonView1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@210);
//            make.left.equalTo(@0);
//            make.right.equalTo(@0);
//            make.height.equalTo(@60);
//        }];
//
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.text = @"アカウントを作成し、タイムラインを見る";
//        [buttonView1 addSubview:label1];
//        [label1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(@0);
//        }];
//
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonD:)];
//        [buttonView1 addGestureRecognizer:tap];
//    }
    
//    [view mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(@0);
//        make.left.equalTo(@30);
//        make.right.equalTo(@(-30));
//        make.height.equalTo(@270);
//        make.centerY.equalTo(@0);
//    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    
}

//- (void)buttonA:(UITapGestureRecognizer *)tap
//{
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        [[SilentLogOperation sharedInstance] setLocationAlwaysOn:YES];
//        [[SilentLogOperation sharedInstance] requestLocationAuth];
//        if ([SilentLogOperation isAuthorized]) {
//            _button3.enabled = YES;
//        }
//    }
//}

//- (void)buttonB:(UITapGestureRecognizer *)tap
//{
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        [[SilentLogOperation sharedInstance] requestMotionActivityAuth];
//        if ([SilentLogOperation isAuthorized]) {
//            _button3.enabled = YES;
//        }
//    }
//}

//- (void)buttonC:(UITapGestureRecognizer *)tap
//{
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        UIApplication *application = [UIApplication sharedApplication];
//
//        if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
//        {
//            UIUserNotificationSettings *settings =
//            [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
//                                              categories:nil];
//            [application registerUserNotificationSettings:settings];
//        }
//    }
//}

//- (void)buttonD:(UITapGestureRecognizer *)tap
//{
//    if (tap.state == UIGestureRecognizerStateEnded) {
//        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
//        NSString *name = [NSString stringWithFormat:@"%0.f%@",now,[[NSUUID UUID] UUIDString]];
//
//        if ([SilentLogOperation isAuthorized]) {
//            [[SilentLogOperation sharedInstance] connectApi:name gender:SLSAccountGender_Unknown birthday:nil];
//        }
//
//        RSLDateController *vc = [[RSLDateController alloc] init];
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//        [[[UIApplication sharedApplication] delegate].window setRootViewController:nc];
//    }
//}

// added start

- (void)safeDriveTapped:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [[SilentLogOperation sharedInstance] requestMotionActivityAuth];
        [[SilentLogOperation sharedInstance] setLocationAlwaysOn:NO];
        [[SilentLogOperation sharedInstance] stopDangerousDrivingDetect];
        
        
        if ([SilentLogOperation isAuthorized]) {
            _safeDrive.enabled = NO;
            _dangerousDrive.enabled = YES;
        }
    }
}

- (void)dangerousDriveTapped:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        [[SilentLogOperation sharedInstance] requestMotionActivityAuth];
        [[SilentLogOperation sharedInstance] setLocationAlwaysOn:YES];
        [[SilentLogOperation sharedInstance] startDangerousDrivingDetect];
        
        
        if ([SilentLogOperation isAuthorized]) {
            _safeDrive.enabled = YES;
            _dangerousDrive.enabled = NO;
        }
    }
}

// added end
@end
