//
//  RFLUserData.h
//  SilentLog
//
//  Created by kazuhisa on 2015/03/04.
//  Copyright (c) 2015年 Rei-Frontier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSLUserData : NSObject

+ (NSMutableDictionary *)loadRootData;

+ (BOOL)saveRootData:(NSDictionary *)rootData;
+ (void)deleteRootData;

+ (BOOL)saveArrayForKey:(NSString *)key array:(NSArray *)array;
+ (NSArray *)loadArrayForKey:(NSString *)key;

+ (BOOL)saveDictionaryForKey:(NSString *)key dictionary:(NSDictionary *)dict;
+ (NSDictionary *)loadDictionaryForKey:(NSString *)key;

+ (BOOL)saveDataForKey:(NSString *)key data:(NSData *)data;
+ (NSData *)loadDataForKey:(NSString *)key;

+ (BOOL)saveNumberForKey:(NSString *)key data:(NSNumber *)data;
+ (NSNumber *)loadNumberForKey:(NSString *)key;

+ (BOOL)saveBoolForKey:(NSString *)key data:(BOOL)data;
+ (BOOL)loadBoolForKey:(NSString *)key;

+ (BOOL)deleteForKey:(NSString *)key;
+ (void)deleteAll;

+ (BOOL)saveAppInstallDate:(NSDate *)date;
+ (NSDate *)loadAppInstallDate;

@end
