#import "CoursesNvCon.h"
#import "Header.h"

@implementation CoursesNvCon
@synthesize background;
#pragma mark - Push & Pop
- (void)pushCourseConWithCourse:(Course*)aCourse animated:(BOOL)animated
{
    CourseCon* courseCon = [[CourseCon alloc] initWithCourse:aCourse];
	[self pushViewController:courseCon animated:animated];
	[courseCon release];
}

- (void)pushCourseIconConWithCourse:(Course*)aCourse animated:(BOOL)animated
{
    CourseIconCon* courseIconCon = [[CourseIconCon alloc] initWithCourse:aCourse];
	[self pushViewController:courseIconCon animated:animated];
	[courseIconCon release];
}

- (void)pushCourseTableConAnimated:(BOOL)animated
{
	CourseTableCon* courseListCon = [[CourseTableCon alloc] init];
	[self pushViewController:courseListCon animated:animated];
	[courseListCon release];
}

#pragma mark - Configure Subviews
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
#pragma mark - Memory Management
- (void)loadView{
	[super loadView];
	[self pushCourseTableConAnimated:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self userDefaultBarBackground];
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
