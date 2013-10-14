//
//  FormInfo.h
//  ClasSchedule
//
//  Created by Remaerd on 12-1-6.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface FormInfo :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * rowCount;
@property (nonatomic, retain) NSNumber * colCount;

@end



