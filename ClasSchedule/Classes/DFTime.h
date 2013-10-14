//
//  DFTime.h
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (DFTime) 
- (NSTimeInterval)timeIntervalSinceTime:(NSDate *)anotherTime;
+ (NSDate*)timeWithHour:(NSInteger)anHour minute:(NSInteger)aMinute second:(NSInteger)aSecond;
+ (id)timeWithTimeInterval:(NSTimeInterval)seconds sinceTime:(NSDate *)date;
- (id)timeByAddingTimeInterval:(NSTimeInterval)seconds;
- (NSString*)stringInFormat:(NSString*)aFormat;
@end
