//
//  SilentLogOperation.h
//  SilentLogSDK
//
//  Created by 四本松和悠 on 2016/01/06.
//  Copyright © 2016年 rei-frontier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLSConst.h"
@import CoreLocation;


@protocol SilentLogOperationDelegate <NSObject>
@optional
- (void)resultForConnectApi:(BOOL)result;
- (void)resultForBackgroundFactory:(NSDictionary *)daily;
- (void)resultForAcquiredEvent:(NSDictionary *)event;
- (void)resultForDetectDangerDriving:(NSDictionary *)messages;
@end

@interface SilentLogOperation : NSObject

/*!
 Delegate
 */
@property (weak, nonatomic) id<SilentLogOperationDelegate> delegate;

/*!
 Check Device has Motion Co-prosessor
 */
+ (BOOL)isDeviceSupport;

/*!
 Check User Did Auth Location and M7
 */
+ (BOOL)isAuthorized;

/*!
 Check User Did Connect SilentLog API
 */
+ (BOOL)isLogin;

/*!
 SilentLogSDK Initiarization
 */
+ (instancetype)sharedInstance;

/*!
 Set SilentLogSDK Service ClientID and ClientSecret
 */
- (void)setClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

/*!
 Set Backgroud Daily Factory Timer (Default 2 hours 2.0 * 60.0 * 60.0, minimum 30 minites 0.5 * 60.0 * 60.0)
 */
- (void)setDailyFactoryTimer:(double)dailyFactoryTimer;

/*!
 Set Tracking PriorityType (Defalut SLSTrackingPriorityTypeEnergySavingAccuracy)
 SLSTrackingPriorityTypeBestAccuracy. CLLocationManager distansfiler 10m
 SLSTrackingPriorityTypeEnergySavingAccuracy. CLLocationManager distansfiler 100m
 SLSTrackingPriorityTypeEnergySavingAccuracyAndAutoPause. CLLocationManager distansfiler 100m and Stop LocationService When SDK detect Stay.
 
 Get Tracking PriorityType which it is set.
 */
- (void)setTrackingPriortyType:(SLSTrackingPriorityType)type;
- (SLSTrackingPriorityType)getTrackingPriorityType;

/*!
 If overTrackingMode is True, SilentLogSDK tracks more when battery charging.
 */
- (void)setOverTrackingMode:(BOOL)overTrackingMode;

/*!
 Request Authorization for Location Updates and Motion & Fitness
 */
- (void)requestLocationAuth;
- (void)requestMotionActivityAuth;

/*!
 Connect Api with Your AccountId(optional) gender(optional set default 0) birthday(optional)
 */
- (BOOL)connectApi:(NSString *)accountId gender:(SLSAccountGenderType)gender birthday:(NSDate *)birthday;

/*!
 Connect Api with Your AccountId(optional) gender(optional set default 0) birthday(optional)
 */
- (void)logoutFromSilentLogAPI;

- (NSString *)silentLogId;

/*!
 Set Location Logging ON or OFF
 */
- (void)setLocationAlwaysOn:(BOOL)on;

/*!
 Start Location Logging
 */
- (void)startTracker;

/*!
 Stop Location Logging
 */
- (void)stopTracker;

/*!
 Set Dangerous driving sensor
 */
- (void)setDangerousDrivingDetect:(BOOL)on;

/*
 Start Dangerous driving Detect
 */
- (void)startDangerousDrivingDetect;

/*
 Stop Dangerous driving Detect
 */
- (void)stopDangerousDrivingDetect;

/*
 Stop Dangerous driving Detect
 handler: resultForDetectDangerDriving parameters
 */
- (void)stopDangerousDrivingDetectWithHander:(void (^)(NSArray<NSDictionary*> *))handler;


/*!
 Start and Stop Background Timer for create and upload Timeline.
 */
- (void)startTimer;
- (void)stopTimer;

/*!
 Get Latest CLLocation of request day
 */
- (CLLocation *)latestLocation:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

/*!
 Get Timeline data set year, month, day (localtime). ResponseObject is NSDictionary
 */
- (void)getDataForYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day withCompletion:(void(^)(id responseObject))completion;

/*!
 If saving activityTag succeed, return YES.
 If activityType or from or to or tag is null, return NO
 */
- (BOOL)saveActivityTag:(NSString *)activityTag activityType:(NSString *)activityType from:(double)from to:(double)to lat:(double)lat lon:(double)lon;

/*!
 Get SDKLog path
 */
- (NSArray *)getSDKLogPaths;

/*!
 Get Event Message
 */
- (NSDictionary *)getEventMessage;

/*!
 Post Event Response
 */
- (void)postResponseWithEventId:(NSInteger)eventId poiId:(NSInteger)poiId type:(NSString *)type;

/*!
 Write Log to SilentLog SDK Log File
 */
- (void)writeLog:(NSString *)logMessage;

@end
