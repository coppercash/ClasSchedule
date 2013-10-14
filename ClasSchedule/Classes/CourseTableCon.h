#import <UIKit/UIKit.h>
#import "DFFloatingView.h"
#import "DFFormView.h"
#import "DFInstructor.h"

typedef enum {
    CourseTableControllerConditionNormal,
    CourseTableControllerConditionAdd,
    CourseTableControllerConditionAlterAndRemove,
    CourseTableControllerConditionFloat
}CourseTableControllerCondition;

@class CSDataCenter,CoursesNvCon,CourseTableCell,DFFloatingView,DFBalloonView;
@interface CourseTableCon : UIViewController <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,DFFormViewDataSource,DFFormViewDelegate,DFFloatingViewDelegate,DFInstructorDelegate> {
    CSDataCenter* dataCenter;
    
    NSFetchedResultsController* fetchedResultsController;
    
    CourseTableControllerCondition condition;
    DFFloatingView* floatingViewAdd;
    DFFloatingView* floatingViewAlterAndRemove;
    
    /*Views*/
    UILabel* topLabel;

    UIView* trashView;
    DFFormView* formManager;
    UITableView* courseTable;
    
    DFBalloonView* _emptyTip;
    
    
    IBOutlet UIImageView* _ImageB0;
    IBOutlet UIImageView* _ImageB1;
    IBOutlet UIImageView* _ImageB2;
    IBOutlet UIImageView* _ImageB3;
    IBOutlet UILabel* _LabelB0;
    IBOutlet UILabel* _LabelB1;
    IBOutlet UILabel* _LabelB2;
    IBOutlet UILabel* _LabelB3;

}
@property(nonatomic)CourseTableControllerCondition condition;

- (void)configureCell:(CourseTableCell*)aDayCell atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Frames
- (CGRect)locateTopLabel;
- (CGRect)locateCourseTable:(UIView*)aView;
- (CGRect)locateFormManager:(UIView*)aView;
- (CGRect)locateFloatingView:(DFFloatingView*)aFloatingView text:(UIView*)aView;
- (CGRect)locateTrashView:(UIView*)aView;
#pragma mark - Float View
- (void)touchBegan:(UITouch*)aTouch onCell:(CourseTableCell*)aCell;
- (void)touchMoved:(UITouch*)aTouch;
- (void)touchEnded:(UITouch*)aTouch;
- (void)touchCancelled:(UITouch*)aTouch;
#pragma mark - Alpha Management
- (void)alphaUnderNormalCondition;
- (void)alphaUnderFloatConditon;
- (void)alphaUnderAddConditon;
- (void)alphaUnderAlterAndRemoveConditon;
#pragma mark - Condition Change
- (void)setCondition:(CourseTableControllerCondition)aCondition;
- (void)switchAmongConditions;
#pragma mark - Tool Bar
- (void)setToolBarItems;
#pragma mark - Configure Subviews
- (void)configureTopLabel;
- (void)configureTrashView;
- (void)configureFormManager:(DFFormView*)aFormManager;
- (void)configureCourseTable:(UITableView*)aCoursesTable;

@end
