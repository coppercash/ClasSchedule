//
//  DFControllerManager.h
//  ClasSchedule
//
//  Created by Remaerd on 12-1-7.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFInstructor;
@interface DFControllerManager : NSObject {
	UIWindow* superWindow;
    DFInstructor* instructor;
}
@property(nonatomic,assign)UIWindow* superWindow;

+ (DFControllerManager*)sharedControllerManager;
- (void)animateNamed:(NSString*)aName from:(UIViewController*)aGoingCon to:(UIViewController*)aComingCon 
		  transition:(UIViewAnimationTransition)aTransition duration:(NSTimeInterval)aDuration curve:(UIViewAnimationCurve)aCurve;
- (void)animateFrom:(UIViewController*)aGoingCon to:(UIViewController*)aComingCon flipFrom:(BOOL)leftOrRight;
- (UIViewController*)defaultRootController;
- (void)resetCoursesNvConAsRootController;
- (void)resetScheduleNvConAsRootController;
- (DFInstructor*)instructor;
@end
