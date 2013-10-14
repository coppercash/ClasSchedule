#import "DFObject.h"
#import "DFView.h"
#import "DFTime.h"
#import "CustomNavigationController.h"
#import "CustomNavigationBar.h"
#import "CustomToolBar.h"
#import "DFBarButtonItem.h"

#import "CSDataCenter.h"
#import "Schedule.h"
#import "Course.h"
#import <QuartzCore/QuartzCore.h>

#import "RowsInfo.h"
#import "ColsInfo.h"
#import "Note.h"
#import "NotePaper.h"
#import "CourseExtension.h"
#import "EnterHelperTableCell.h"

#import "DFControllerManager.h"
#import "ScheduleNvCon.h"
#import "WeekCon.h"
#import "DayCon.h"
#import "CoursesNvCon.h"
#import "CourseTableCon.h"
#import "CourseCon.h"
#import "CourseIconCon.h"

#import "ScheduleFormCell.h"
#import "DayCell.h"
#import "CourseTableCell.h"

#import "DFScrollScheduleBoundaryView.h"
#import "DFScheduleBoundaryManagerCell.h"
#import "DFFloatingView.h"
#import "DFFormView.h"
#import "DFInstructor.h"
#import "NotesPad.h"
#import "DFCourseIconView.h"
#import "EnterHelper.h"
#import "DFBalloonView.h"

#define ARC4RANDOM_MAX 0x100000000 
#define kMissLocalizedString @"MissLocalizedString"

//#define DEBUG_MODE
#ifdef DEBUG_MODE

#define	DLog(...);      NSLog(__VA_ARGS__);
#define DLogPoint(p)	NSLog(@"%f,%f", p.x, p.y);
#define DLogSize(p)     NSLog(@"%f,%f", p.width, p.height);
#define DLogRect(p)     NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#else

#define DLog(...);      // NSLog(__VA_ARGS__);
#define DLogPoint(p)	// NSLog(@"%f,%f", p.x, p.y);
#define DLogSize(p)     // NSLog(@"%f,%f", p.width, p.height);
#define DLogRect(p)     // NSLog(@"%f,%f %f,%f", p.origin.x, p.origin.y, p.size.width, p.size.height);

#endif
