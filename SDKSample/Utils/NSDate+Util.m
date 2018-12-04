//
//  NSDate+Util.m
//  SilentLog
//
//  Created by FukuyamaShingo on 3/3/16.
//  Copyright © 2016 Rei-Frontier. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

+ (NSCalendar *)ext_gregorianCalendar
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    return calendar;
}

+ (NSDateFormatter *)ext_gregorianDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSDate ext_gregorianCalendar];
    dateFormatter.calendar = calendar;
    dateFormatter.locale = calendar.locale;
    return dateFormatter;
}

+ (NSLocale *)ext_h24Locale
{
    // Force 12 hour settings to 24 hour
    return [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
}

+ (NSInteger)ext_getHourIn24
{
    NSCalendar *gregorian = [NSDate ext_gregorianCalendar];
    gregorian.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents *components = [gregorian components:
                                    //NSCalendarUnitYear |
                                    //NSCalendarUnitMonth |
                                    //NSCalendarUnitDay |
                                    NSCalendarUnitHour
                                                fromDate:[NSDate date]];
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    return components.hour;
}

- (NSDate *)ext_beginningOfDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //gregorian.timeZone = [NSTimeZone systemTimeZone];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    //components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *beginningOfDay = [gregorian dateFromComponents:components];
    return beginningOfDay;
}

- (NSDate *)ext_endOfDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
    components.day += 1;
    components.second -= 1;
    NSDate *endOfDay = [gregorian dateFromComponents:components];
    return endOfDay;
}

- (NSDate *)gmtDateFromLocalDate
{
    NSDate* gmtDateTime = [NSDate dateWithTimeInterval:-[[NSTimeZone systemTimeZone] secondsFromGMT] sinceDate:self];
    return gmtDateTime;
}

+ (NSInteger)daysBetweenFrom:(NSDate *)from to:(NSDate *)to
{
    NSTimeInterval fromInterval = [from timeIntervalSince1970];
    NSTimeInterval toInterval = [to timeIntervalSince1970];
    
    double interval = toInterval - fromInterval;
    NSInteger intInterval = (NSInteger)(interval / (60 * 60 * 24));
    
    return intInterval;
}

@end
