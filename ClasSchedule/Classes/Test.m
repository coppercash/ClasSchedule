#import "Test.h"
#import "Header.h"

@implementation Test
+ (void)test
{
    [Test testInsert];
    [Test testDelete];
}

+ (void)testDelete
{
	
    CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
	NSManagedObjectContext* context = dataCenter.managedObjectContext;  //Need rewrite this sentence when use this method in other environment
    
	NSArray* schedule = [dataCenter requestByTemplateName:@"wholeSchedule"];
	for (Schedule* aSchedule in schedule) {
		[context deleteObject:aSchedule];
	}
    
    NSArray* couses = [dataCenter requestByTemplateName:@"allCourses"];
	for (Course* aCourse in couses) {
		[context deleteObject:aCourse];
	}
    
}

+ (void)testInsert
{
	CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
	//NSManagedObjectContext* context = dataCenter.managedObjectContext;  //Need rewrite this sentence when use this method in other environment
    
    Course* QRS = [dataCenter insertCourseWithName:@"嵌入式与通信处理器" teacher:@"彭健均" room:@"A234"];
	Course* MG = [dataCenter insertCourseWithName:@"毛概" teacher:@"王丽娟" room:@"A322/A629"];
	Course* WJYLYJKJS = [dataCenter insertCourseWithName:@"微机原理与接口技术" teacher:@"聂聪" room:@"A325"];
	Course* CZXTYL = [dataCenter insertCourseWithName:@"操作系统原理" teacher:@"金桂月" room:@"A132"];
	Course* WLGHYSJ = [dataCenter insertCourseWithName:@"网络规划与设计" teacher:@"肖鹏" room:@"A428"];
	Course* WLGL = [dataCenter insertCourseWithName:@"网络管理" teacher:@"蒙会民" room:@"A429/A416"];
    
	[dataCenter insertScheduleWithWeekday:2 daySeq:1 course:QRS];
    [dataCenter insertScheduleWithWeekday:2 daySeq:2 course:QRS];
	
    [dataCenter insertScheduleWithWeekday:2 daySeq:3 course:MG];
    [dataCenter insertScheduleWithWeekday:2 daySeq:4 course:MG];
    
    
    [dataCenter insertScheduleWithWeekday:3 daySeq:1 course:WJYLYJKJS];
    [dataCenter insertScheduleWithWeekday:3 daySeq:2 course:WJYLYJKJS];
    
    [dataCenter insertScheduleWithWeekday:3 daySeq:3 course:CZXTYL];
    [dataCenter insertScheduleWithWeekday:3 daySeq:4 course:CZXTYL];
	
	[dataCenter insertScheduleWithWeekday:3 daySeq:5 course:WLGL];
	[dataCenter insertScheduleWithWeekday:3 daySeq:6 course:WLGL];
    
    
    
    [dataCenter insertScheduleWithWeekday:4 daySeq:1 course:QRS];
    [dataCenter insertScheduleWithWeekday:4 daySeq:2 course:QRS];
    [dataCenter insertScheduleWithWeekday:4 daySeq:3 course:WLGHYSJ];
    [dataCenter insertScheduleWithWeekday:4 daySeq:4 course:WLGHYSJ];
    
    [dataCenter insertScheduleWithWeekday:5 daySeq:1 course:WJYLYJKJS];
    [dataCenter insertScheduleWithWeekday:5 daySeq:2 course:WJYLYJKJS];
    [dataCenter insertScheduleWithWeekday:5 daySeq:3 course:WLGL];
    [dataCenter insertScheduleWithWeekday:5 daySeq:4 course:WLGL];
    [dataCenter insertScheduleWithWeekday:5 daySeq:5 course:CZXTYL];
    [dataCenter insertScheduleWithWeekday:5 daySeq:6 course:CZXTYL];
    
    [dataCenter insertScheduleWithWeekday:6 daySeq:3 course:MG];
    [dataCenter insertScheduleWithWeekday:6 daySeq:4 course:MG];
    
    /*
     Course* a = [self insertCourseWithName:@"a" teacher:@"彭健均" room:@"A234"];
     Course* b = [self insertCourseWithName:@"b" teacher:@"彭健均" room:@"A234"];
     Course* c = [self insertCourseWithName:@"b" teacher:@"彭健均" room:@"A234"];
     Course* d = [self insertCourseWithName:@"d" teacher:@"彭健均" room:@"A234"];
     
     [self insertScheduleWithWeekday:1 daySeq:1 course:a];
     [self insertScheduleWithWeekday:1 daySeq:2 course:b];
     [self insertScheduleWithWeekday:1 daySeq:3 course:c];
     [self insertScheduleWithWeekday:1 daySeq:4 course:d];
     */
}

+ (void)testLog{
    CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
    
	printf("\n\n\n");
	
	NSArray* courses = [dataCenter requestByTemplateName:@"allCourses"];
	printf("Courses\n");
	for (Course* aCourse in courses) {
		NSLog(@"*name:%@ *teacher:%@ *room:%@ *notes:%@",aCourse.name,aCourse.teacher,aCourse.room,aCourse.notes); 
	}
	
	printf("\n\n\n");
	
	NSArray* schedule = [dataCenter requestByTemplateName:@"wholeSchedule"];
	Course* ctCourse = nil;
	printf("Schedule\n");
	for (Schedule* aSchedule in schedule) {
		//NSLog(@"*seq_week:%d *seq_day:%d",[aSchedule.seq_week intValue],[aSchedule.seq_day intValue]); 
		ctCourse = aSchedule.course;
		if(ctCourse) NSLog(@"*name:%@ *teacher:%@ *room:%@ *notes:%@",ctCourse.name,ctCourse.teacher,ctCourse.room,ctCourse.notes); 
	}
}

@end
