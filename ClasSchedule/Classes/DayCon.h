#import <UIKit/UIKit.h>
#import "DFInstructor.h"

@class CSDataCenter,DayCell;

@interface DayCon : UITableViewController <NSFetchedResultsControllerDelegate,DFInstructorDelegate>{
	CSDataCenter* dataCenter;
    
    NSUInteger weekday;

    BOOL isFocused;
    
    NSTimer* focusTimer;
    NSTimer* focusMinuteTimer;
    NSIndexPath* focus;
    
    NSFetchedResultsController* fetchedResultsController;
    
    IBOutlet UIImageView* _Image0;
    IBOutlet UILabel* _Label0;
}
@property(nonatomic)BOOL isFocused;
@property(nonatomic,retain)NSIndexPath* focus;

#pragma mark - Frames
- (CGRect)frameOfDayCourseTable;
#pragma mark - Title
- (void)configureTitle;
#pragma mark - Focus
- (NSIndexPath*)configureDefaultFocus;
- (void)focusOn:(NSIndexPath*)anIndexPath withAnimation:(BOOL)anAnimation;
- (void)focusOnDefaultAnimated;
- (void)renewFocusTimer;
- (void)focusByUser:(NSIndexPath*)anIndexPath;
- (void)refocusOnDefaultRowByTimer:(NSTimer*)theTimer;
- (void)newFocusMinuteTimer;
#pragma mark - UITableViewDataSource
- (void)configureCell:(DayCell*)aDayCell atIndexPath:(NSIndexPath *)indexPath;
#pragma mark - Tool Bar
- (void)setToolBarItemsToDeletingConditon;
- (void)setToolBarItems;
- (void)enterDeletingConditon;
- (void)tableViewSetEditingYes;
- (void)cancelDeletingMode;
#pragma mark - Memory Management
- (id)initWithWeekday:(NSInteger)aWeekDay;
@end
