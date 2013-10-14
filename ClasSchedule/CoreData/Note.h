//
//  Note.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * bornDate;
@property (nonatomic, retain) Course *course;

@end
