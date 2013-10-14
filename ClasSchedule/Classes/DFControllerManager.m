#import "DFControllerManager.h"

#import "Header.h"

@implementation DFControllerManager
@synthesize superWindow;

#pragma mark - Replace Controllers 
- (UIViewController*)defaultRootController
{
	ScheduleNvCon* scheduleNvCon = [[ScheduleNvCon alloc] init];
	//ScheduleNvCon* scheduleNvCon = [[ScheduleNvCon alloc] initWithRootViewController:[[WeekCon alloc] initWithSuperNavController:scheduleNvCon]];

	[superWindow setRootViewController:scheduleNvCon];
	[scheduleNvCon release];
	return scheduleNvCon;
}

- (void)resetCoursesNvConAsRootController
{
	CoursesNvCon* coursesNvCon = [[CoursesNvCon alloc] init];
    [self animateFrom:superWindow.rootViewController to:coursesNvCon flipFrom:YES];
    [superWindow setRootViewController:coursesNvCon];
	[coursesNvCon release];
}

- (void)resetScheduleNvConAsRootController
{
	ScheduleNvCon* scheduleNvCon = [[ScheduleNvCon alloc] init];
    [self animateFrom:superWindow.rootViewController to:scheduleNvCon flipFrom:NO];
	[superWindow setRootViewController:scheduleNvCon];
	[scheduleNvCon release];
}

#pragma mark - Animation
- (void)animateFrom:(UIViewController*)aGoingCon to:(UIViewController*)aComingCon flipFrom:(BOOL)leftOrRight
{
    UIViewAnimationTransition transition;
	
    if (leftOrRight) transition = UIViewAnimationTransitionFlipFromLeft;
	else transition = UIViewAnimationTransitionFlipFromRight;
	
	[self animateNamed:@"View Flip" from:aGoingCon to:aComingCon 
			transition:transition duration:0.5 curve:UIViewAnimationCurveEaseInOut];
}

- (void)animateNamed:(NSString*)aName from:(UIViewController*)aGoingCon to:(UIViewController*)aComingCon 
		 transition:(UIViewAnimationTransition)aTransition duration:(NSTimeInterval)aDuration curve:(UIViewAnimationCurve)aCurve
{
	[UIView beginAnimations:aName context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration:aDuration];
	[UIView setAnimationCurve:aCurve];
	[UIView setAnimationTransition:aTransition forView:superWindow cache:YES];
	[UIView setAnimationBeginsFromCurrentState:YES];
    //[aComingCon viewWillAppear:YES];
    //[aGoingCon viewWillDisappear:YES];
	
    [UIView commitAnimations];
}

#pragma mark - Instructor
- (DFInstructor*)instructor
{
    return instructor;
}

#pragma mark - Memory Management
+ (DFControllerManager*)sharedControllerManager
{
	static DFControllerManager* controllerManager;
	@synchronized(self){
		if (!controllerManager) {
			controllerManager = [[DFControllerManager alloc] init];
		}
	}
	return controllerManager;
}

- (id)init{
    if (self = [super init]) {
        instructor = [[DFInstructor alloc] init];
    }
    return self;
}

- (void)dealloc{
    superWindow = nil;
    
    [instructor release];
    instructor = nil;
    
    [super dealloc];
}
@end
