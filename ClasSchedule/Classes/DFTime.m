//
//  DFTime.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFTime.h"

@implementation NSDate (DFTime)
/*
- (NSTimeInterval)timeIntervalSinceTime:(NSDate *)anotherTime
{
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* selfComponents = [calendar components:flags fromDate:self];
    NSDateComponents* anotherComponents = [calendar components:flags fromDate:anotherTime];

    NSDate* sSelf = [calendar dateFromComponents:selfComponents];
    NSDate* sAnother = [calendar dateFromComponents:anotherComponents];
    
    NSTimeInterval interval = [sSelf timeIntervalSinceDate:sAnother];
    return interval;
}*/

- (NSTimeInterval)timeIntervalSinceTime:(NSDate *)anotherTime
{
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* selfComponents = [calendar components:flags fromDate:self];
    NSDateComponents* anotherComponents = [calendar components:flags fromDate:anotherTime];

    NSTimeInterval hourInterval = (selfComponents.hour - anotherComponents.hour) * 60 * 60;
    NSTimeInterval minuteInterval = (selfComponents.minute - anotherComponents.minute) * 60;
    NSTimeInterval secondInterval = selfComponents.second - anotherComponents.second;
    NSTimeInterval interval = hourInterval + minuteInterval + secondInterval;
    return interval;
}


+ (NSDate*)timeWithHour:(NSInteger)anHour minute:(NSInteger)aMinute second:(NSInteger)aSecond
{
    NSDate* now = [[NSDate alloc] init];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *nowComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setEra:nowComponents.era];
    [comps setYear:nowComponents.year];
    [comps setMonth:nowComponents.month];
    [comps setDay:nowComponents.day];
    [comps setHour:anHour];
    [comps setMinute:aMinute];
    [comps setSecond:aSecond];
    NSDate* date = [calendar dateFromComponents:comps];
    
    [comps release];
    [calendar release];
    [now release];
    
    return date;
}

+ (id)timeWithTimeInterval:(NSTimeInterval)seconds sinceTime:(NSDate *)date
{
    return [NSDate dateWithTimeInterval:seconds sinceDate:date];
}

- (id)timeByAddingTimeInterval:(NSTimeInterval)seconds
{
    return [self dateByAddingTimeInterval:seconds];
}

- (NSString*)stringInFormat:(NSString*)aFormat
{
	/*
	 Return a string contains "aDate" information format into "aFormat" or default format like "".
	 */
	
	NSDateFormatter* formatterGT = [[NSDateFormatter alloc] init];
	if (aFormat) {
		[formatterGT setDateFormat:aFormat];
	}else{
		[formatterGT setDateFormat:@"hh:mm a"];
	}
	NSString* stringGT = [formatterGT stringFromDate:self];
	[formatterGT release];
	return stringGT;
}

@end
