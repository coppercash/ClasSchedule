#import <UIKit/UIKit.h>

@class Schedule,DFCourseIconView,RowsInfo;

@interface DayCell : UITableViewCell
{
    Schedule* schedule;
    BOOL isFocused;
    BOOL isWeekdayFocused;
    //CGSize shadowOffset;
    NSTimer* classProgressUpdater;

    /*View*/
    IBOutlet DFCourseIconView* _IconView;
    IBOutlet UILabel* _CourseName;

    IBOutlet UIImageView* _InstructorIcon;
    IBOutlet UILabel* _InstructorName;
    
    IBOutlet UIImageView* _LocationIcon;
    IBOutlet UILabel* _LocationLabel;
    
    IBOutlet UIImageView* _NotesIcon;
    IBOutlet UILabel* _NotesLabel;
    
    IBOutlet UIProgressView* _ClassProgress;
}

@property(nonatomic,retain)Schedule* schedule;
@property(nonatomic)BOOL isFocused;
@property(nonatomic)BOOL isWeekdayFocused;
//@property(nonatomic)CGSize shadowOffset;

#pragma mark - Frames
+ (CGFloat)heightWhenFocused;
+ (CGFloat)heightWhenNotFocused;
- (CGRect)gradientBackgroundFrame;
#pragma mark - loadSubviews
- (void)loadSubviews;
- (void)loadFocusedSubviews;
- (void)loadNotFocusedSubviews;
#pragma mark - Shadow
- (void)setShadowOffset:(CGSize)aShadowOffset;
- (CGPathRef)shadowPath;
#pragma mark - Progress
- (NSTimer*)newClassProgressUpdater;
- (float)progressDuringClassByRowInfo:(RowsInfo*)aRowInfo;
- (void)updateClassProgressByTimer:(NSTimer*)theTimer;
#pragma mark - Gradient Background
- (void)drawGradientBackground:(CGRect)aRect;
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;
@end
