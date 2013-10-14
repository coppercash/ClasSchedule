#import "ScheduleNvCon.h"
#import "Header.h"

@implementation ScheduleNvCon

#pragma mark - Push & Pop
- (void)pushDayControllerWithWeekday:(NSInteger)aWeekday focused:(BOOL)aFocused animated:(BOOL)animated
{
    DayCon* dayCon = [[DayCon alloc] initWithWeekday:aWeekday];
    [dayCon setIsFocused:aFocused];
    
    [self pushViewController:dayCon animated:animated];
    [dayCon release];
}

- (void)pushCourseIconConWithCourse:(Course*)aCourse animated:(BOOL)animated
{
    CourseIconCon* courseIconCon = [[CourseIconCon alloc] initWithCourse:aCourse];
	[self pushViewController:courseIconCon animated:animated];
	[courseIconCon release];
}

- (void)pushWeekControllerAnimated:(BOOL)animated
{
	WeekCon* weekCon = [[WeekCon alloc] init];
    [self pushViewController:weekCon animated:animated];
	[weekCon release];
}

- (void)pushCourseConWithCourse:(Course*)aCourse animated:(BOOL)animated
{
	//CourseCon* courseCon = [[CourseCon alloc] initWithSuperNavController:self course:aCourse];
    CourseCon* courseCon = [[CourseCon alloc] initWithCourse:aCourse];
    [self pushViewController:courseCon animated:animated];
	[courseCon release];
}

- (void)loadBackgroundImageView
{
    NSString* backgroundPath = [[NSBundle mainBundle] pathForResource:@"Blackboard" ofType:@"png"];
	UIImage* backgroundImage = [[UIImage alloc] initWithContentsOfFile:backgroundPath];
    if (!background) {
        background = [[UIImageView alloc] initWithImage:backgroundImage];
        [backgroundImage release];
        [self.view insertSubview:background atIndex:0];
    }
    [background setFrame:self.view.bounds];
    [background setHeight:self.view.bounds.size.height - 44.0f];
    [background setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

#pragma mark - System Given
- (void)loadView{
	[super loadView];
    DLog(@"ScheduleNvCon loadView");
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self userDefaultBarBackground];
	[self pushWeekControllerAnimated:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self destroySubview:&background];
	
	DLog(@"ScheduleNvCon viewDidUnload");
}

- (id)init{
	if (self = [super init]) {
        [self loadBackgroundImageView];
	}
	return self;
}

- (void)dealloc {
    [self destroySubview:&background];
    [super dealloc];
}

@end
