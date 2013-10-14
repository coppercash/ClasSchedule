#import "CSDataCenter.h"

#import "Header.h"

@implementation CSDataCenter
@synthesize appDelegate,managedObjectContext;

NSString* colAndRowCountKey = @"colAndRowCount";
NSString* formInfoKey = @"FormInfo";
NSString* wholeScheduleKey = @"wholeSchedule";
NSString* allRowsInfoKey = @"allRowsInfo";

#pragma mark - Insert
- (Note*)insertNoteWithContent:(NSString*)aContent intoCourse:(Course*)aCourse
{
    if (!aContent && ![aContent length]) {
        DLog(@"insertNoteWithContent: aContent does not exist");
        return nil;
    }
    //NSSet* notes = aCourse.notes;
    
    NSManagedObjectContext* context = managedObjectContext;  //Need rewrite this sentence when use this method in other environment
	//RowsInfo* newRowInfo = [NSEntityDescription insertNewObjectForEntityForName:@"RowsInfo" inManagedObjectContext:context];    
	Note* newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    
    NSDate* now = [[NSDate alloc] init];
    [newNote setBornDate:now];
    [now release];
	
    [newNote setContent:aContent];
    
    [aCourse addNotesObject:newNote];
    
    
	return newNote;
}

- (RowsInfo*)insertRowInfoWithRowIndex:(NSUInteger)aRowIndex startTime:(NSDate*)aStartTime endTime:(NSDate*)anEndTime
{
    
	if (!(0 < aRowIndex && aRowIndex < 11)) {
		DLog(@"Current version only support aRowIndex in the range from 1 to 10,%d",aRowIndex);
		return nil;
	}
    
    NSUInteger lastRowIndex = [self rowCountOfScheduleForm];
    
    RowsInfo* newRowInfo = [self rowInfoByRowIndex:aRowIndex];
    if (newRowInfo) {
    }else{
        NSManagedObjectContext* context = managedObjectContext;  //Need rewrite this sentence when use this method in other environment
        newRowInfo = [NSEntityDescription insertNewObjectForEntityForName:@"RowsInfo" inManagedObjectContext:context];    
        
        NSNumber* rowIndex = [[NSNumber alloc] initWithInt:aRowIndex];
        [newRowInfo setRowIndex:rowIndex];  
        [rowIndex release];
    }
    
    if (aStartTime) [newRowInfo setStartTime:aStartTime];
    if (anEndTime) [newRowInfo setEndTime:anEndTime];
    
    if (!aStartTime || !anEndTime) {
        //Get last rowInfo
        NSDate* lastEndTime = nil;
        if (lastRowIndex > 0) {
            RowsInfo* lastRowInfo = [self rowInfoByRowIndex:lastRowIndex];
            lastEndTime = lastRowInfo.endTime;
        }else{
            lastEndTime = [CSDataCenter getStandardTimeWithHour:7 minute:50 second:0];
        }
        
        NSTimeInterval classBreakInterval = 10 * 60;
        
        if (!aStartTime) {
            NSDate* defaultNewStartTime = [lastEndTime dateByAddingTimeInterval:classBreakInterval];
            [newRowInfo setStartTime:defaultNewStartTime];
        }
        
        if (!anEndTime) {
            NSTimeInterval classDuration = 45 * 60;
            NSDate* defaultNewEndTime = [lastEndTime dateByAddingTimeInterval:classBreakInterval + classDuration];
            [newRowInfo setEndTime:defaultNewEndTime];
        }
    }
	return newRowInfo;
}

- (ColsInfo*)insertColInfoWithWeekday:(NSUInteger)aWeekday
{
    if (!(0 < aWeekday && aWeekday < 8)) {
		DLog(@"Only support aColIndex in the range from 1(Monday) to 7(Sunday),%d",aWeekday);
		return nil;
	}
    ColsInfo* newColInfo = [self colInfoByColIndex:aWeekday];
    if (newColInfo) {
        
    }else{
        NSManagedObjectContext* context = managedObjectContext;  //Need rewrite this sentence when use this method in other environment
        newColInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ColsInfo" inManagedObjectContext:context];    
        
        NSNumber* colIndex = [[NSNumber alloc] initWithInt:aWeekday];
        [newColInfo setColIndex:colIndex];  
        [colIndex release];
    }
    
	return newColInfo;
}

- (Schedule*)insertScheduleWithWeekday:(int)aSeqWeek daySeq:(int)aSeqDay course:(Course*)aCourse
{
	if (!aCourse) {
		DLog(@"Can not insert new Schedule without aCourse");
		return nil;
	}
	if (!(0 < aSeqWeek && aSeqWeek < 8)) {
		DLog(@"Can not insert new Schedule with illegal aSeqWeek:%d",aSeqWeek);
		return nil;
	}
	if (!(0 < aSeqDay)) {
		DLog(@"Can not insert new Schedule with illegal aSeqDay:%d",aSeqDay);
		return nil;
	}
	
    Schedule* newSchedule = nil;
    
    ColsInfo* colInfo = [self colInfoByColIndex:aSeqWeek];
    RowsInfo* rowInfo = [self rowInfoByRowIndex:aSeqDay];
    
    if (colInfo && rowInfo) {
        //Need rewrite this sentence when use this method in other environment
        NSManagedObjectContext* context = managedObjectContext;          
        newSchedule = [NSEntityDescription insertNewObjectForEntityForName:@"Schedule" inManagedObjectContext:context];; 
        [newSchedule setColInfo:colInfo];
        [newSchedule setRowInfo:rowInfo];
        [newSchedule setCourse:aCourse];
    }
    
    
	/*
     NSNumber* seqWeek = [[NSNumber alloc] initWithInt:aSeqWeek];
     [newSchedule setSeq_week:seqWeek];  
     
     NSNumber* seqDay = [[NSNumber alloc] initWithInt:aSeqDay];
     [newSchedule setSeq_day:seqDay];
     */
	
	//[seqWeek release];
	//[seqDay release];
	
	return newSchedule;
}

- (Course*)insertCourseWithName:(NSString*)aName teacher:(NSString*)aTeacher room:(NSString*)aRoom
{
    if (!(aName)) {
		DLog(@"Can not insert new Course without aName");
		return nil;
	}
    NSManagedObjectContext* context = managedObjectContext;  //Need rewrite this sentence when use this method in other environment
	Course* newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];  
	
    [newCourse setName:aName];
    if (aTeacher)[newCourse setTeacher:aTeacher];
	if (aRoom)[newCourse setRoom:aRoom];
    
    CourseExtension* newCourseExtension = [NSEntityDescription insertNewObjectForEntityForName:@"CourseExtension" inManagedObjectContext:context];
    [newCourse setCourseExtension:newCourseExtension];
    NSString* defaultIconPath = [[NSBundle mainBundle] pathForResource:@"DefaultCourseIcon" ofType:@"png"];
    [newCourseExtension setIconPath:defaultIconPath];
    UIColor* newColor = [self colorByIndex:[self courseCount] % 8];
    const CGFloat* components = CGColorGetComponents(newColor.CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];
    [newCourseExtension setRed:[NSNumber numberWithFloat:red]];
    [newCourseExtension setGreen:[NSNumber numberWithFloat:green]];
    [newCourseExtension setBlue:[NSNumber numberWithFloat:blue]];
    
    return newCourse;
}

- (void)setColsInfoWithColCount:(NSUInteger)aColCount
{
    NSUInteger oldColCount = [self colCountOfScheduleForm];
    NSUInteger newColCount = aColCount;
    
    if (newColCount == oldColCount) {
    } else if (newColCount > oldColCount) {
        /*
         for (counter = oldColCount + 1; counter <= newColCount; counter++) {
         [self insertColInfoWithRowIndex:counter - 1];
         }*/
        [self insertColInfoWithWeekday:1];
        [self insertColInfoWithWeekday:7];
    } else if (newColCount < oldColCount) {
        ColsInfo* cuColInfo = nil;
        /*
         for (counter = oldColCount; counter > newColCount; counter--) {
         cuColInfo = [self colInfoByColIndex:counter - 1];
         [context deleteObject:cuColInfo];
         }*/
        cuColInfo = [self colInfoByColIndex:1];
        //[context deleteObject:cuColInfo];
        [self removeColumeInfo:cuColInfo];
        cuColInfo = [self colInfoByColIndex:7];
        //[context deleteObject:cuColInfo];
        [self removeColumeInfo:cuColInfo];

    }
}

- (void)setRowsInfoWithRowCount:(NSUInteger)aRowCount
{
    NSUInteger oldRowCount = [self rowCountOfScheduleForm];
    NSUInteger newRowCount = aRowCount;
    NSUInteger index = 0;
    
    if (newRowCount == oldRowCount) {
    } else if (newRowCount > oldRowCount) {
        for (index = oldRowCount + 1; index <= newRowCount; index++) {
            [self insertRowInfoWithRowIndex:index startTime:nil endTime:nil];
        }
    } else if (newRowCount < oldRowCount) {
        RowsInfo* cuRowInfo = nil;
        for (index = oldRowCount ; index > newRowCount ; index--) {
            cuRowInfo = [self rowInfoByRowIndex:index];
            //[context deleteObject:cuRowInfo];
            [self removeRowInfo:cuRowInfo];
        }
    }
}

#pragma mark - Delete
- (void)deleteCoreDataObject:(NSManagedObject *)aManagedObjext
{
    if (aManagedObjext) {
        [managedObjectContext deleteObject:aManagedObjext];
    }
}

- (void)removeColumeInfo:(ColsInfo*)aColInfo
{
    ColsInfo* colInfo = aColInfo;
    [managedObjectContext deleteObject:colInfo];
}

- (void)removeRowInfo:(RowsInfo*)aRowInfo
{
    RowsInfo* rowInfo = aRowInfo;
    [managedObjectContext deleteObject:rowInfo];
}

#pragma mark - Request
- (NSArray*)sortedNotesOfCourse:(Course*)aCourse
{
    NSSet* theNotes = aCourse.notes;
    NSSortDescriptor* sortDescriper = [[NSSortDescriptor alloc] initWithKey:@"bornDate" ascending:YES];
    NSArray* sortDescripers = [[NSArray alloc] initWithObjects:sortDescriper, nil];
    NSArray* sortedNotes = [[theNotes allObjects] sortedArrayUsingDescriptors:sortDescripers];
    //NSArray* sortedContent = [sortedNotes valueForKey:@"content"];
    
    [sortDescripers release];
    [sortDescriper release];
    
    return sortedNotes;
}

- (Schedule*)scheduleAtWeekday:(NSUInteger)aWeekday daySeq:(NSUInteger)aDaySeq
{
    NSManagedObjectContext* context = managedObjectContext;
    Schedule* returnedSchedule = nil;
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:context];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"colInfo.colIndex" ascending:NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"colInfo.colIndex == %d AND rowInfo.rowIndex == %d",aWeekday,aDaySeq];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
	
    NSArray* results = [context executeFetchRequest:fetchRequest error:nil];
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    NSUInteger resultCount = [results count];
    if (resultCount == 1) {
        returnedSchedule = [results objectAtIndex:0];
    }else {
        DLog(@"You have %d schedule information at Column:%d Row:%d",resultCount,aWeekday,aDaySeq);
    }
    
    return returnedSchedule;
}

- (NSArray*)schedulesAtWeekday:(NSUInteger)aWeekday
{
    NSManagedObjectContext* context = managedObjectContext;
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:context];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"colInfo.colIndex" ascending:NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"colInfo.colIndex == %d",aWeekday];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSArray* results = [context executeFetchRequest:fetchRequest error:nil];
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    return results;
}

- (Course*)courseInScheduleBySeqWeek:(NSUInteger)aSeqWeek seqDay:(NSUInteger)aSeqDay
{
    Schedule* theSchedule = [self scheduleAtWeekday:aSeqWeek daySeq:aSeqDay];
    Course* returnedCourse = theSchedule.course;
    return returnedCourse;
}

- (NSUInteger)courseCount
{
    return [[self requestByTemplateName:@"allCourses"] count];
}

- (NSUInteger)colCountOfScheduleForm
{
    return [[self requestByTemplateName:@"allColsInfo"] count];
}

- (ColsInfo*)colInfoByColIndex:(NSUInteger)aColIndex
{
    NSManagedObjectContext* context = managedObjectContext;
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"colIndex" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"ColsInfo" inManagedObjectContext:context];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"colIndex == %d",aColIndex];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
	NSArray* results = [context executeFetchRequest:fetchRequest error:nil];
    
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    ColsInfo* colInfo = nil;
    NSUInteger resultCount = [results count];
    if (resultCount == 1) {
        colInfo = [results objectAtIndex:0];
    }else if (resultCount > 1) {
        DLog(@"You have %d pieces of information for col %d",[results count],aColIndex);
    }
    
    //DLog(@"test %d",[colInfo.colIndex unsignedIntegerValue]);
    return colInfo;
}

- (NSUInteger)rowCountOfScheduleForm
{
    return [[self requestByTemplateName:@"allRowsInfo"] count];
}

- (RowsInfo*)rowInfoByRowIndex:(NSUInteger)aRowIndex
{
    NSManagedObjectContext* context = managedObjectContext;
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowIndex" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"RowsInfo" inManagedObjectContext:context];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"rowIndex == %d",aRowIndex];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
	NSArray* results = [context executeFetchRequest:fetchRequest error:nil];
    
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    RowsInfo* rowInfo = nil;
    NSUInteger resultCount = [results count];
    if (resultCount == 1) {
        rowInfo = [results objectAtIndex:0];
    }else if(resultCount > 1){
        DLog(@"You have %d pieces of information for row %d",[results count],aRowIndex);
    }
    
    return rowInfo;
}

- (NSArray*)requestForSchdule
{
	return [self requestByTemplateName:wholeScheduleKey];
}

- (NSArray*)requestByTemplateName:(NSString*)aTemplateName
{
	if (!aTemplateName) {
		DLog(@"Can not fetch request without aTemplateName");
		return nil;
	}
	NSManagedObjectContext* context = managedObjectContext;	//Need rewrite this sentence when use this method in other environment
	NSManagedObjectModel* model = [appDelegate managedObjectModel];	//Need rewrite this sentence when use this method in other environment
	
	NSFetchRequest *fetchRequest = [model fetchRequestFromTemplateWithName:aTemplateName substitutionVariables: nil];
	NSArray* results = [context executeFetchRequest:fetchRequest error:nil];
	
	return results;
}

#pragma mark - Font Name
+ (NSString*)fontChalk
{
    return @"ChalkboardSE-Bold";
}

#pragma mark - Map of Weekday to/from ColumnIndex
- (NSUInteger)columnIndexByWeekday:(NSInteger)aWeekday
{
    return [self columnIndexByWeekday:aWeekday weekendOn:[self isWeekendOn]];
}

- (NSUInteger)columnIndexByWeekday:(NSInteger)aWeekday weekendOn:(BOOL)isWeekendOn
{
    NSUInteger columnIndex = 0;
    if (isWeekendOn) {
        //1S 2M 3T 4W 5T 6F 7S
        //0  1  2  3  4  5  6
        columnIndex = aWeekday - 1;
    }
    else{
        //2M 3T 4W 5T 6F
        //0  1  2  3  4
        columnIndex = aWeekday - 2;
    }
    return columnIndex;
}

- (NSString*)weekdayStringByWeekday:(NSInteger)aWeekday
{
    NSString* weekdayString = @"NL";
    switch (aWeekday) {
        case 1:
            weekdayString = NSLocalizedString(@"Sun",nil);
            break;
        case 2:
            weekdayString = NSLocalizedString(@"Mon",nil);
            break;
        case 3:
            weekdayString = NSLocalizedString(@"Tue",nil);
            break;
        case 4:
            weekdayString = NSLocalizedString(@"Wed",nil);
            break;
        case 5:
            weekdayString = NSLocalizedString(@"Thu",nil);
            break;
        case 6:
            weekdayString = NSLocalizedString(@"Fri",nil);
            break;
        case 7:
            weekdayString = NSLocalizedString(@"Sat",nil);
            break;
        default:
            break;
    }
    return weekdayString;
}

- (NSInteger)weekDayByFormColumnIndex:(NSUInteger)aColumnIndex
{
    return [self weekDayByFormColumnIndex:aColumnIndex weekendOn:[self isWeekendOn]];
}

- (NSInteger)weekDayByFormColumnIndex:(NSUInteger)aColumnIndex weekendOn:(BOOL)isWeekendOn
{
    NSInteger weekDay = 0;
    if (isWeekendOn) {
        //0  1  2  3  4  5  6
        //1S 2M 3T 4W 5T 6F 7S
        weekDay = aColumnIndex + 1;
    }else{
        //0  1  2  3  4
        //2M 3T 4W 5T 6F
        weekDay = aColumnIndex + 2;
    }
    return weekDay;
}

- (BOOL)isWeekendOn
{
    BOOL isWeekendOn = NO;
    NSUInteger colCount = [self colCountOfScheduleForm];
    switch (colCount) {
        case 5:
            isWeekendOn = NO;
            break;
        case 7:
            isWeekendOn = YES;
            break;
        default:
            break;
    }
    return isWeekendOn;
}

#pragma mark - FirstRunning

-(BOOL)isFirstRunning
{
    Boolean isFirstRunning = NO;
    NSArray* allRowsInfo = [self requestByTemplateName:allRowsInfoKey];
    if (![allRowsInfo count]) {
        isFirstRunning = YES;
    }
    return isFirstRunning;
}

-(void)initCoreDataWhenFirstRunning
{
    [self initColsInfoWhenFirstRunning];
    [self initRowsInfoWhenFirstRunning];
}

-(void)initRowsInfoWhenFirstRunning
{
    [self insertRowInfoWithRowIndex:1 
                          startTime:[CSDataCenter getStandardTimeWithHour:8 minute:0 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:8 minute:45 second:0]];
    
    [self insertRowInfoWithRowIndex:2 
                          startTime:[CSDataCenter getStandardTimeWithHour:8 minute:55 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:9 minute:40 second:0]];    
    
    [self insertRowInfoWithRowIndex:3 
                          startTime:[CSDataCenter getStandardTimeWithHour:10 minute:5 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:10 minute:50 second:0]];    
    
    [self insertRowInfoWithRowIndex:4 
                          startTime:[CSDataCenter getStandardTimeWithHour:11 minute:0 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:11 minute:45 second:0]];
    
    [self insertRowInfoWithRowIndex:5 
                          startTime:[CSDataCenter getStandardTimeWithHour:13 minute:20 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:14 minute:5 second:0]];
    
    [self insertRowInfoWithRowIndex:6 
                          startTime:[CSDataCenter getStandardTimeWithHour:14 minute:10 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:14 minute:55 second:0]];    
    
    [self insertRowInfoWithRowIndex:7 
                          startTime:[CSDataCenter getStandardTimeWithHour:15 minute:15 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:16 minute:0 second:0]];    
    
    [self insertRowInfoWithRowIndex:8 
                          startTime:[CSDataCenter getStandardTimeWithHour:16 minute:5 second:0] 
                            endTime:[CSDataCenter getStandardTimeWithHour:16 minute:50 second:0]];
}

-(void)initColsInfoWhenFirstRunning
{
    NSUInteger counter = 0;
    for (counter = 2; counter <= 6; counter++) {
        [self insertColInfoWithWeekday:counter];
    }
}

#pragma mark - Useful Functions
- (UIColor*)colorByIndex:(NSUInteger)anIndex
{
    UIColor* color = nil;
    switch (anIndex) {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor greenColor];
            break;
        case 2:
            color = [UIColor blueColor];
            break;
        case 3:
            color = [UIColor cyanColor];
            break;
        case 4:
            color = [UIColor yellowColor];
            break;
        case 5:
            color = [UIColor magentaColor];
            break;
        case 6:
            color = [UIColor orangeColor];
            break;
        case 7:
            color = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return color;
}

+ (UIColor*)getColorFromCourseExtensionInfo:(CourseExtension*)extensionInfo
{
    CGFloat red = [extensionInfo.red floatValue];
    CGFloat green = [extensionInfo.green floatValue];
    CGFloat blue = [extensionInfo.blue floatValue];
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(CGRect)frameFromLable:(UILabel*)label point:(CGPoint)aPoint
{
	CGSize lableSize=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(300,300) lineBreakMode:UILineBreakModeWordWrap];
	return CGRectMake(aPoint.x,aPoint.y,lableSize.width,lableSize.height);
}

+(CGRect)frameFromLable:(UILabel*)label x:(CGFloat)x y:(CGFloat)y
{
	CGSize lableSize=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(300,1200) lineBreakMode:UILineBreakModeWordWrap];
	return CGRectMake(x,y,lableSize.width,lableSize.height);
}

+ (CGSize)sizeDependOnLabel:(UILabel*)label
{
    CGSize labelSize=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(300,1200) lineBreakMode:UILineBreakModeWordWrap];
    return labelSize;
}

+ (CGSize)sizeDependOnTextField:(UITextField*)aTextField
{
    CGSize labelSize = CGSizeZero;
    if (aTextField.text) {
        labelSize = [aTextField.text sizeWithFont:aTextField.font constrainedToSize:CGSizeMake(300,1200) lineBreakMode:UILineBreakModeWordWrap];
    }else{
        labelSize = [aTextField.placeholder sizeWithFont:aTextField.font constrainedToSize:CGSizeMake(300,1200) lineBreakMode:UILineBreakModeWordWrap];
    }
    return labelSize;
}

+ (NSDate*)getNextMinute
{
    NSDate* now = [[NSDate alloc] init];
    NSDate* returningDate = nil;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comingComps = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:now];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setEra:comingComps.era];
    [comps setYear:comingComps.year];
    [comps setMonth:comingComps.month];
    [comps setDay:comingComps.day];
    [comps setHour:comingComps.hour];
    [comps setMinute:comingComps.minute + 1];
    returningDate = [calendar dateFromComponents:comps];
    
    [comps release];
    [calendar release];
    [now release];
    
    return returningDate;
}

+ (NSDate*)getStandardTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond
{
    NSDate* returningDate = nil;
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2000];
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:anHour];
    [comps setMinute:aMinute];
    [comps setSecond:aSecond];
    returningDate = [calendar dateFromComponents:comps];
    
    [comps release];
    [calendar release];
    
	return returningDate;
}

+ (NSDate*)getStandardDateFromDate:(NSDate*)aDate
{
	NSDate* comingDate = aDate;
    NSDate* returningDate = nil;
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comingComps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:comingDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:2000];
    [comps setMonth:1];
    [comps setDay:1];
    [comps setHour:comingComps.hour];
    [comps setMinute:comingComps.minute];
    returningDate = [calendar dateFromComponents:comps];
    
    [comps release];
    [calendar release];
    
	return returningDate;
}

+ (NSDate*)getStandardRightNow
{
    NSDate* rightNow = [[NSDate alloc] init];
    NSDate* standardRightNow = [CSDataCenter getStandardDateFromDate:rightNow];
    [rightNow release];
    
    return standardRightNow;
}

+ (NSString*)getStringFromDate:(NSDate*)aDate withFormat:(NSString*)aFormat
{
	/*
	 Return a string contains "aDate" information format into "aFormat" or default format like "".
	 */
	
	NSDateFormatter* formatterGT = [[NSDateFormatter alloc] init];
	if (aFormat) {
		[formatterGT setDateFormat:aFormat];
	}else{
		[formatterGT setDateFormat:@"hh:mm a"];
	}
	NSString* stringGT = nil;
	if(aDate){
		stringGT = [formatterGT stringFromDate:aDate];
	}else{
		NSDate* now = [[NSDate alloc] init];
		stringGT = [formatterGT stringFromDate:now];
		[now release];
	}
	[formatterGT release];
	return stringGT;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    BOOL isBetween = YES;
    
    if (!(date && beginDate && endDate)) isBetween = NO;
    
    if ([date compare:beginDate] == NSOrderedAscending) isBetween = NO;
    
    if ([date compare:endDate] == NSOrderedDescending) isBetween = NO;
    
    return isBetween;
}

+ (NSString *)getLanguageCode
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    return preferredLang;
}

#pragma mark Work With Directory
+ (void)checkSubDocunmentsDirectory:(NSString*)aPath
{
	/*
	 Ensure whether the directory that "aPath" points exists.If not,create it.
	 */
	
	NSString* directory = [CSDataCenter documentsDirectoryAppend:aPath];
	
	NSFileManager* manager = [[NSFileManager alloc] init];
	if ([manager fileExistsAtPath:directory]) {
		DLog(@"Directory *%@* exists",aPath);
	}else {
		[manager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:nil];
		DLog(@"Creating directory *%@*",aPath);
	}
	[manager release];
}

+ (NSString*)documentsDirectoryAppend:(NSString*)fileName
{
	/*
	 Return absolute path of files in "Documents" directory.
	 */
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

#pragma mark - File Path
+ (NSString*)fileNameByCurrentTimeWithExtension:(NSString*)anExtension
{
	/*
	 Return file name with extension.Just a name not whole path.
	 */
	if (anExtension) {
		return [[self getStringFromDate:nil withFormat:@"yMMddHHmmss"] stringByAppendingPathExtension:anExtension];
	}else {
		return [self getStringFromDate:nil withFormat:@"yMMddHHmmss"];
	}
}

#pragma mark - Memory Management
+ (CSDataCenter*)sharedDataCenter
{
	static CSDataCenter* dataCenter;
	@synchronized(self){
		if (!dataCenter) {
			dataCenter = [[CSDataCenter alloc] init];
		}
	}
	return dataCenter;
}

- (id)init
{
	if (self = [super init]) {
	}
	return self;
}

- (void)setAppDelegate:(AppDelegate *)aDelegate
{
	appDelegate = aDelegate;
	managedObjectContext = [appDelegate managedObjectContext];
    
    if ([self isFirstRunning]){
        [self initCoreDataWhenFirstRunning];
    }
}

- (void)dealloc
{
    appDelegate = nil;
	managedObjectContext = nil;
}
@end
