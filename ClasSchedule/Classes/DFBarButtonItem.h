#import <UIKit/UIKit.h>

typedef enum {
    DFBarButtonCustomItemInstructor,
    DFBarButtonCustomItemSchedule,
    DFBarButtonCustomItemSubjects,
    DFBarButtonCustomItemEnterAssist,
    DFBarButtonCustomItemEnterDismissKeyboard
}DFBarButtonCustomItem;

@interface UIBarButtonItem (DFBarButtonItem)
- (id)initWithBarButtonCustomItem:(DFBarButtonCustomItem)customItem target:(id)target action:(SEL)action;
@end
