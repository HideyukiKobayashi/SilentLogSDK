//
//  AppDelegate.m
//  SDKSample
//
//  Created by kazuhisa on 2016/11/09.
//  Copyright © 2016年 Rei Frontier. All rights reserved.
//

#import "AppDelegate.h"
#import "RSLDateController.h"
@import SilentLogSDK;

#define VER_10_0_OR_LATER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0f)

@interface AppDelegate ()<SilentLogOperationDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    [[SilentLogOperation sharedInstance] setClientId:@"ca80i1I5j1IHx1amOGuPC1JMppZVia0mm4"
                                        clientSecret:@"xbpRXmp81FJuo4RAeqUQ9ZmoiwoLli8pvFBB2DqUzxkFeI8SCwI76riGXRS04I3e7gSMEqJYCWf8dk9MrBGLlJLUml"];
    [SilentLogOperation sharedInstance].delegate = self;

    [[SilentLogOperation sharedInstance] setDangerousDrivingDetect:YES];
    [[SilentLogOperation sharedInstance] setOverTrackingMode:YES];
    [[SilentLogOperation sharedInstance] setTrackingPriortyType:SLSTrackingPriorityTypeEnergySavingAccuracyAndAutoPause];
    [[SilentLogOperation sharedInstance] startDangerousDrivingDetect]; //added

    UIApplicationState applicationState = application.applicationState;
    if (applicationState == UIApplicationStateBackground) {
        if ([SilentLogOperation isAuthorized]) {
            [[SilentLogOperation sharedInstance] startTimer];
        }
    }

    if ([SilentLogOperation isAuthorized] && [SilentLogOperation isLogin]) {
        RSLDateController *vc = [[RSLDateController alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.window setRootViewController:nc];
    }

    NSLog(@"%s isAuthorized:%d",__PRETTY_FUNCTION__,[SilentLogOperation isAuthorized]);

    // 5秒後にスタート
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[SilentLogOperation sharedInstance] startDangerousDrivingDetect];
    });

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([SilentLogOperation isAuthorized]) {
        [[SilentLogOperation sharedInstance] startTimer];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([SilentLogOperation isAuthorized]) {
        [[SilentLogOperation sharedInstance] startTimer];
        [[SilentLogOperation sharedInstance] startTracker];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([SilentLogOperation isAuthorized]) {
        [[SilentLogOperation sharedInstance] startTracker];
        // [[SilentLogOperation sharedInstance] setDangerousDrivingDetect:NO];
    }

    NSDictionary *message = [[SilentLogOperation sharedInstance] getEventMessage];
    if (message) {
        [self alertFromNotificationStay:message];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if ([SilentLogOperation isAuthorized]) {
        [[SilentLogOperation sharedInstance] startTracker];
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        [self alertFromNotificationStay:userInfo];
    }

}

#pragma mark Push Notification And Alert

- (void)sendLocalNotification:(NSDate *)date withMessage:(NSString *)message event:(NSDictionary *)event
{
    if (!message) {
        return;
    }

    UILocalNotification *notification = [[UILocalNotification alloc] init];

    notification.fireDate = date;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = [NSString stringWithFormat:@"%@",message];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertTitle = message;

    if (event) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:event];
        notification.userInfo = userInfo;
    }

    NSInteger badgeCount = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeCount];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)alertFromNotificationStay:(NSDictionary *)event
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    //メッセージ内容を設定内容（POI, イベントID, 距離）
    NSString *pushTitle = @"title";
    if (event[@"message"][@"title"]) {
        pushTitle = event[@"message"][@"title"][@"ja"];
    }
    NSString *pushBody = @"body";
    if (event[@"message"][@"body"]) {
        pushBody = event[@"message"][@"body"][@"ja"];
        NSInteger eventId = [event[@"eventId"] integerValue];
        NSString *eventName = event[@"eventName"];
        NSDictionary *poi = event[@"poi"];
        NSString *poiName = poi[@"poiName"];

        pushBody = [NSString stringWithFormat:@"%@ \neventId:%ld\neventName:%@\npoiName:%@",pushBody,eventId,eventName,poiName];
    }

    //    RFLLogInfo(@"%s %@",__PRETTY_FUNCTION__,event);

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:pushTitle
                                                                             message:pushBody
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
                                                        NSInteger eventId = [event[@"eventId"] integerValue];
                                                        NSInteger poi = [event[@"poi"][@"poiId"] integerValue];
                                                        [[SilentLogOperation sharedInstance] postResponseWithEventId:eventId poiId:poi type:@"touch"];
                                                    }];
    [alertController addAction:aAction];

    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - SilentLogOperation Delegate

- (void)resultForConnectApi:(BOOL)result
{
    NSLog(@"%s result:%d",__PRETTY_FUNCTION__,result);
    [self sendLocalNotification:nil withMessage:@"アカウント作成完了" event:nil];
}

- (void)resultForBackgroundFactory:(NSDictionary *)daily
{
}

- (void)resultForAcquiredEvent:(NSDictionary *)event
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSString *pushTitle = event[@"message"][@"title"][@"ja"];
    [self sendLocalNotification:nil withMessage:pushTitle event:event];
}

- (void)resultForDetectDangerDriving:(NSDictionary *)messages
{
    /*
     messages
     keys:
      message: detected message
      type: "accel", "brake", "handle"
      location: NSLocation object
      start_time: NSDate object
      end_time: NSDate object
     */
    NSString *message = messages[@"message"];

    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = message;
//    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.hasAction = NO;

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    [UIApplication sharedApplication].applicationIconBadgeNumber += 1;

}


@end
