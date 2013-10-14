#import <Foundation/Foundation.h>

@class AppDelegate,Schedule,Course,CourseExtension,ColsInfo,RowsInfo,Note;

@interface CSDataCenter : NSObject {
	AppDelegate* appDelegate;
	NSManagedObjectContext* managedObjectContext;
}
@property(nonatomic,assign)AppDelegate* appDelegate;
@property(nonatomic,assign)NSManagedObjectContext* managedObjectContext;

+ (CSDataCenter*)sharedDataCenter;

#pragma mark - Font Name
+ (NSString*)fontChalk;
#pragma mark - Map of Weekday to/from ColumnIndex
- (NSUInteger)columnIndexByWeekday:(NSInteger)aWeekday;
- (NSUInteger)columnIndexByWeekday:(NSInteger)aWeekday weekendOn:(BOOL)isWeekendOn;
- (NSString*)weekdayStringByWeekday:(NSInteger)aWeekday;
- (NSInteger)weekDayByFormColumnIndex:(NSUInteger)aColumnIndex;
- (NSInteger)weekDayByFormColumnIndex:(NSUInteger)aColumnIndex weekendOn:(BOOL)isWeekendOn;
- (BOOL)isWeekendOn;
#pragma mark - Request
- (NSArray*)sortedNotesOfCourse:(Course*)aCourse;
- (Schedule*)scheduleAtWeekday:(NSUInteger)aWeekday daySeq:(NSUInteger)aDaySeq;
- (NSArray*)schedulesAtWeekday:(NSUInteger)aWeekday;
- (Course*)courseInScheduleBySeqWeek:(NSUInteger)aSeqWeek seqDay:(NSUInteger)aSeqDay;
- (NSUInteger)courseCount;
- (NSUInteger)colCountOfScheduleForm;
- (ColsInfo*)colInfoByColIndex:(NSUInteger)aColIndex;
- (NSUInteger)rowCountOfScheduleForm;
- (RowsInfo*)rowInfoByRowIndex:(NSUInteger)aRowIndex;
- (NSArray*)requestForSchdule;
- (NSArray*)requestByTemplateName:(NSString*)aTemplateName;
#pragma mark - Delete
- (void)deleteCoreDataObject:(NSManagedObject *)aManagedObjext;
- (void)removeColumeInfo:(ColsInfo*)aColInfo;
- (void)removeRowInfo:(RowsInfo*)aRowInfo;
#pragma mark - Insert
- (Note*)insertNoteWithContent:(NSString*)aContent intoCourse:(Course*)aCourse;
- (RowsInfo*)insertRowInfoWithRowIndex:(NSUInteger)aRowIndex startTime:(NSDate*)aStartTime endTime:(NSDate*)anEndTime;
- (ColsInfo*)insertColInfoWithWeekday:(NSUInteger)aWeekday;
- (Schedule*)insertScheduleWithWeekday:(int)aSeqWeek daySeq:(int)aSeqDay course:(Course*)aCourse;
- (Course*)insertCourseWithName:(NSString*)aName teacher:(NSString*)aTeacher room:(NSString*)aRoom;
- (void)setColsInfoWithColCount:(NSUInteger)aColCount;
- (void)setRowsInfoWithRowCount:(NSUInteger)aRowCount;
#pragma mark - Useful Functions
- (UIColor*)colorByIndex:(NSUInteger)anIndex;
+(CGRect)frameFromLable:(UILabel*)label point:(CGPoint)aPoint;
+(CGRect)frameFromLable:(UILabel*)label x:(CGFloat)x y:(CGFloat)y;
+ (CGSize)sizeDependOnLabel:(UILabel*)label;
+ (CGSize)sizeDependOnTextField:(UITextField*)aTextField;
+ (UIColor*)getColorFromCourseExtensionInfo:(CourseExtension*)extensionInfo;
+ (NSDate*)getNextMinute;
+ (NSDate*)getStandardDateFromDate:(NSDate*)aDate;
+ (NSDate*)getStandardTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond;
+ (NSString*)getStringFromDate:(NSDate*)aDate withFormat:(NSString*)aFormat;
+ (NSString*)fileNameByCurrentTimeWithExtension:(NSString*)anExtension;
+ (NSDate*)getStandardRightNow;
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSString *)getLanguageCode;
#pragma mark Work With Directory
+ (void)checkSubDocunmentsDirectory:(NSString*)aPath;
+ (NSString*)documentsDirectoryAppend:(NSString*)fileName;
#pragma mark - FirstRunning
-(BOOL)isFirstRunning;
-(void)initCoreDataWhenFirstRunning;
-(void)initRowsInfoWhenFirstRunning;
-(void)initColsInfoWhenFirstRunning;

@end

