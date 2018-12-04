//
//  NSDate+Util.h
//  SilentLog
//
//  Created by FukuyamaShingo on 3/3/16.
//  Copyright © 2016 Rei-Frontier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Util)
NS_ASSUME_NONNULL_BEGIN
+ (NSCalendar *)ext_gregorianCalendar;
+ (NSDateFormatter *)ext_gregorianDateFormatter;
+ (NSLocale *)ext_h24Locale;
+ (NSInteger)ext_getHourIn24;
- (NSDate *)ext_beginningOfDay;
- (NSDate *)ext_endOfDay;
- (NSDate *)gmtDateFromLocalDate;
+ (NSInteger)daysBetweenFrom:(NSDate *)from to:(NSDate *)to;
NS_ASSUME_NONNULL_END
@end
