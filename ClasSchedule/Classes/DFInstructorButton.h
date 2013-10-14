//
//  DFInstructorButton.h
//  trapezium
//
//  Created by DreamerMac on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFInstructor;
@interface DFInstructorButton : UIButton{
    DFInstructor* instructor;
}
- (id)initWithInstructor:(DFInstructor*)anInstructor;
@end
