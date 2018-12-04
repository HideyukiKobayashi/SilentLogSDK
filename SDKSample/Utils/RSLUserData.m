//
//  RFLUserData.m
//  SilentLog
//
//  Created by kazuhisa on 2015/03/04.
//  Copyright (c) 2015年 Rei-Frontier. All rights reserved.
//

#import "RSLUserData.h"
#import "NSDate+Util.h"

#define kRSLUserDataRootKey       @"kRSLUserDataRootKey"
#define kRSLUserDataAppInstallKey @"kRSLUserDataAppInstallKey"

@implementation RSLUserData

#pragma mark - Public

+ (NSMutableDictionary *)loadRootData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* root = [ud dictionaryForKey:kRSLUserDataRootKey];
    
    if (!root) {
        return [NSMutableDictionary dictionary];
    }
    return [NSMutableDictionary dictionaryWithDictionary:root];
}

+ (BOOL)saveRootData:(NSDictionary *)rootData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:rootData forKey:kRSLUserDataRootKey];
    return [ud synchronize];
}

+ (void)deleteRootData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kRSLUserDataRootKey];
    [ud synchronize];
}

+ (BOOL)saveArrayForKey:(NSString *)key array:(NSArray *)array
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData setObject:array forKey:key];
    return [self saveRootData:rootData];
}

+ (NSArray *)loadArrayForKey:(NSString *)key
{
    NSDictionary* rootData = [self loadRootData];
    NSArray* array = (NSArray*)[rootData objectForKey:key];
    return array;
}

+ (BOOL)saveDictionaryForKey:(NSString *)key dictionary:(NSDictionary *)dict
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData setObject:dict forKey:key];
    return [self saveRootData:rootData];
}

+ (NSDictionary *)loadDictionaryForKey:(NSString *)key
{
    NSDictionary* rootData = [self loadRootData];
    NSDictionary* dict = (NSDictionary*)[rootData objectForKey:key];
    return dict;
}

+ (BOOL)saveDataForKey:(NSString *)key data:(NSData *)data
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData setObject:data forKey:key];
    return [self saveRootData:rootData];
}

+ (NSData *)loadDataForKey:(NSString *)key
{
    NSDictionary* rootData = [self loadRootData];
    NSData* data = (NSData*)[rootData objectForKey:key];
    if (data) {
        return data;
    }
    return nil;
}

+ (BOOL)saveNumberForKey:(NSString *)key data:(NSNumber *)data
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData setObject:data forKey:key];
    return [self saveRootData:rootData];
}

+ (NSNumber *)loadNumberForKey:(NSString *)key
{
    NSDictionary* rootData = [self loadRootData];
    NSNumber* data = (NSNumber*)[rootData objectForKey:key];
    return data;
}

+ (BOOL)saveBoolForKey:(NSString *)key data:(BOOL)data
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData setObject:[NSNumber numberWithBool:data] forKey:key];
    return [self saveRootData:rootData];
}

+ (BOOL)loadBoolForKey:(NSString *)key
{
    NSDictionary* rootData = [self loadRootData];
    BOOL firstBoot = NO;
    id value = rootData[key];
    if (value)
    {
        firstBoot = [value boolValue];
    }
    
    return firstBoot;
}

+ (BOOL)deleteForKey:(NSString *)key
{
    NSMutableDictionary* rootData = [self loadRootData];
    [rootData removeObjectForKey:key];
    return [self saveRootData:rootData];
}

+ (void)deleteAll
{
    [self deleteRootData];
}

+ (BOOL)saveAppInstallDate:(NSDate *)date
{
    NSMutableDictionary* rootData = [self loadRootData];
    if (date) {
        [rootData setObject:date forKey:kRSLUserDataAppInstallKey];
    }
    return [self saveRootData:rootData];
}

+ (NSDate *)loadAppInstallDate
{
    NSDictionary* rootData = [self loadRootData];
    
    NSDate* value = rootData[kRSLUserDataAppInstallKey];
    if (value) {
        return [value ext_beginningOfDay];
    } else {
        return [[NSDate date] ext_beginningOfDay];
    }
}

@end
