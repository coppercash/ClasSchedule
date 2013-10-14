//
//  Schedule.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ColsInfo, Course, RowsInfo;

@interface Schedule : NSManagedObject

@property (nonatomic, retain) RowsInfo *rowInfo;
@property (nonatomic, retain) ColsInfo *colInfo;
@property (nonatomic, retain) Course *course;

@end
