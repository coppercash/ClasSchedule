#import "DFBarButtonItem.h"

@implementation UIBarButtonItem (DFBarButtonItem)
- (id)initWithBarButtonCustomItem:(DFBarButtonCustomItem)customItem target:(id)target action:(SEL)action
{
    NSString* imageName = nil;
    switch (customItem) {
        case DFBarButtonCustomItemInstructor:
            imageName = @"Instructor_BarItem";
            break;
        case DFBarButtonCustomItemSchedule:
            imageName = @"Schedule_BarItem";
            break;
        case DFBarButtonCustomItemSubjects:
            imageName = @"Subjects_BarItem";
            break;
        case DFBarButtonCustomItemEnterAssist:
            imageName = @"EnterAssistant_BarItem";
            break;
        case DFBarButtonCustomItemEnterDismissKeyboard:
            imageName = @"DimissKeyboard_BarItem";
            break;
        default:
            break;
    }
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
       
    if (self = [self initWithImage:image style:UIBarButtonItemStylePlain target:target action:action]) {
    }
    [image release];
    return self;
}

@end
