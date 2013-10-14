#import <UIKit/UIKit.h>
#import "EnterHelper.h"
#import "WeekCon.h"
#import "NotesPad.h"
#import "DFInstructor.h"

@class CoursesNvCon,Course,EnterHelper,DFCourseIconView;

@interface CourseCon : UIViewController <EnterHelperDelegate,UITextFieldDelegate,NotesPadDelegate,DFInstructorDelegate>{
	CSDataCenter* dataCenter;
	
	Course* course;
    
    EditingMode editingMode;
    
    EnterHelper* _enterHelper;
    BOOL _enterHelperOn;
    
    /*View*/
    IBOutlet DFCourseIconView* iconView;
    IBOutlet UITextField* courseName;
    
    IBOutlet UIImageView* teacherIcon;
    IBOutlet UITextField* teacherName;
    
    IBOutlet UIImageView* roomIcon;
    IBOutlet UITextField* roomLabel;
    
    NotesPad* notesPad;
    
    /*Instructor*/
    IBOutlet UIImageView* _imageView0;
    IBOutlet UILabel* _label0;
    IBOutlet UIImageView* _imageView1;
    IBOutlet UILabel* _label1;
    IBOutlet UIImageView* _imageView2;
    IBOutlet UILabel* _label2;
}
@property(nonatomic,retain)Course* course;

#pragma mark - Frames
- (CGRect)locateIconView:(UIView*)aView;
- (CGRect)locateTeacherIcon:(UIView*)aView;
- (CGRect)locateRoomIcon:(UIView*)aView;
- (CGRect)locateNotesPad;
- (CGRect)notePaperExpandedFrame;
#pragma mark - Push Pop Controller
- (void)callCourseIconController;
#pragma mark - Subviews
- (void)configureIconView;
- (void)configureCourseName;
- (void)configureRoomLabel;
- (void)configureNotesPad;
- (void)loadSubviews;
- (void)unLoadSubviews;
#pragma mark - EnterHelperDelegate & Event
- (CGRect)stageFrame;
- (void)presentEnterHelper;
- (void)tranformSubviewsForEnterHelper;
- (void)tranformSubviewsForEnterHelperDismissing;
#pragma mark - NotePaper Event
- (void)contentViewResignFirstResponder;
- (void)registerForKeyboardNotifications;
- (void)keyboardWillBeShown:(NSNotification*)aNotification;
- (void)keyboardWillBeHidden:(NSNotification*)aNotification;
#pragma mark - Bar Functions
- (void)toolBarSaveNotePaper;
- (void)toolBarCancelNotePaper;
- (void)toolBarDeleteNotePaper;
- (void)toolBarCallInstructor:(UIBarButtonItem*)sender event:(UIEvent*)event;
- (void)toolBarEnterEditingMode;
- (void)navigatinBarCancelEditingModeWithSaving;
- (void)navigatinBarCancelEditongModeWithoutSaving;
- (void)navigationBarAddNewCourse;
#pragma mark - Tool Bar
- (void)setToolBarItemsNormalMode;
- (void)setToolBarItemsEnterEditingMode;
- (void)setToolBarForNotePaper;
#pragma mark - Navigation Bar
- (void)setNavigationBarEnterEditingMode;
- (void)setNavigationBarNormalMode;
- (void)checkAddSubjectButtonByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement;
#pragma mark - Mode Transform
- (void)enterEditingMode;
- (void)cancelEditingMode;
- (void)enterAddingMode;
- (void)cancelAddingMode;
#pragma mark - Memory Management
- (id)initWithCourse:(Course*)aCourse;

@end
