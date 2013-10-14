#import "CourseTableCon.h"
#import "Header.h"

@implementation CourseTableCon

@synthesize condition;

#pragma mark - Frames
- (CGRect)locateTopLabel
{
    CGFloat topMaigin = 10.0f;
    
    UILabel* theTopLabel = topLabel;
    [theTopLabel setBounds:CGRectMake(0.0f, 0.0f, 280.0f, 30.0f)];
    [theTopLabel setCenter:CGPointMake(self.view.bounds.size.width / 2, topMaigin + theTopLabel.bounds.size.height / 2)];
    
    return theTopLabel.frame;
}

- (CGRect)locateCourseTable:(UIView*)aView
{
    CGFloat topMargin = 50.0f;
    
    CGRect bounds = self.view.bounds;
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height - topMargin;
    CGFloat x = 0.0f;
    CGFloat y = topMargin;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    
    return frame;
}

- (CGRect)locateTrashView:(UIView*)aView
{
    CGFloat horizontalMargin = 10.0f;
    CGFloat topMargin = 10.0f;
    
    CGRect bounds = self.view.bounds;
    CGFloat width = bounds.size.width - horizontalMargin - horizontalMargin;
    CGFloat height = 40.0f;;
    CGFloat x = horizontalMargin;
    CGFloat y = topMargin;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateFormManager:(UIView*)aView
{
    CGFloat topMargin = 10.0f;
    CGFloat bottomMargin = 20.0f;
    CGFloat leftMargin = 10.0f;
    CGFloat rightMargin = 10.0f;
    
    CGRect trashViewRect = [self locateTrashView:nil];
    topMargin += (trashViewRect.origin.y + trashViewRect.size.height);
    
    CGRect bounds = self.view.bounds;
    CGFloat width = bounds.size.width - leftMargin - rightMargin;
    CGFloat height = bounds.size.height - topMargin - bottomMargin;
    CGFloat x = leftMargin;
    CGFloat y = topMargin;

    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];

    return frame;
}

- (CGRect)locateFloatingView:(DFFloatingView*)aFloatingView text:(UIView*)aView
{
    CGFloat horizontalMargin;
    CGFloat vertiacalMargin;
    if (aFloatingView == floatingViewAdd) {
        horizontalMargin = 10.0f;
        vertiacalMargin = 10.0f;
    }else if (aFloatingView == floatingViewAlterAndRemove){
        horizontalMargin = 1.0f;
        vertiacalMargin = 1.0f;
    }
    
    CGRect frame = CGRectZero;
    
    if ([aFloatingView isFloating]) {
        frame = CGRectInset(aFloatingView.bounds, horizontalMargin, vertiacalMargin);
    }
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateEmptyTip:(UIView*)aView
{
    CGFloat height = 100.0f;
    CGFloat leftMargin = 20.0f;
    CGFloat rightMargin = 20.0f;
    CGFloat bottomMargin = 1.0f;
    
    CGFloat width = self.view.bounds.size.width - leftMargin - rightMargin;
    CGFloat y = self.view.bounds.size.height - bottomMargin - height;
    
    CGRect frame = CGRectMake(leftMargin, y, width, height);
    [aView setFrame:frame];
    return frame;
}

#pragma mark - Configure Subviews
- (void)setTopLabelContent
{
    NSUInteger courseCount = [dataCenter courseCount];
    NSString* topLabelString = [[NSString alloc] initWithFormat:@"%d %@",courseCount,NSLocalizedString(@"Subjects", @"Subjects")];
    [topLabel setText:topLabelString];
    [topLabelString release];
}

- (void)configureTopLabel
{
    UILabel* theTopLabel = topLabel;
    [self locateTopLabel];
    //[theTopLabel setBackgroundColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.3f]];
    [theTopLabel setBackgroundColor:[UIColor clearColor]];
    [theTopLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f]];
    [theTopLabel setTextAlignment:UITextAlignmentCenter];
    [theTopLabel setAdjustsFontSizeToFitWidth:YES];
    [theTopLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:26.0f]];
    
    /*
    NSUInteger courseCount = [dataCenter courseCount];
    NSString* topLabelString = [[NSString alloc] initWithFormat:@"%d %@",courseCount,NSLocalizedString(@"Subjects", @"Subjects")];
    
    [theTopLabel setText:topLabelString];*/
     
    [self setTopLabelContent];
}

- (void)configureTrashView
{
    UIView* theTrashView = trashView;
    [self locateTrashView:theTrashView];
    [theTrashView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    [theTrashView setAlpha:0.0f];
    
    UILabel* trashLabel = [[UILabel alloc] init];
    [theTrashView addSubview:trashLabel];

    CGFloat horizontalMargin = 10.0f;
    CGFloat verticalMargin = 5.0f;
    CGRect frame = CGRectInset(theTrashView.bounds, horizontalMargin, verticalMargin);
    [trashLabel setFrame:frame];
    [trashLabel setBackgroundColor:[UIColor clearColor]];
    [trashLabel setText:NSLocalizedString(@"TrashLabel", @"Drag Here to Delete")];
    [trashLabel setTextAlignment:UITextAlignmentCenter];
    [trashLabel setTextColor:[UIColor whiteColor]];
    [trashLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)configureFormManager:(DFFormView*)aFormManager
{
    DFFormView* theScheduleForm = aFormManager;
    
	NSUInteger colCount = [dataCenter colCountOfScheduleForm];
	NSUInteger rowCount = [dataCenter rowCountOfScheduleForm];
	
    [theScheduleForm setColCount:colCount];
    [theScheduleForm setRowCount:rowCount];
    [theScheduleForm setFrame:[self locateFormManager:nil]];
    
    [theScheduleForm setDataSource:self];
    [theScheduleForm setDelegate:self];
    //[theFormManager setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin];
    
    [theScheduleForm setTouchingConditon:DFFormViewTouchingConditonNone];
    
    NSString* chalkFramePath = [[NSBundle mainBundle] pathForResource:@"ChalkFrame" ofType:@"png"];
	UIImage* chalkFrame = [[UIImage alloc] initWithContentsOfFile:chalkFramePath];
	[theScheduleForm setCommonCellBackgroundImage:chalkFrame];
    [chalkFrame release];
    
    [theScheduleForm createForm];
    [theScheduleForm setIsTopBoundaryViewsHidden:NO];
	
}

- (void)configureCourseTable:(UITableView*)aCoursesTable
{
    UITableView* theTableView = aCoursesTable;
    //[self locateCourseTable:theTableView];
    [theTableView setDelegate:self];
    [theTableView setDataSource:self];
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [theTableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Empty Tip
- (BOOL)isSubjectNone
{
    NSUInteger numberOfSubjects = [[fetchedResultsController fetchedObjects] count];
    return (numberOfSubjects == 0);
}

- (void)loadEmptyTips
{
    DFBalloonView* tip = [[DFBalloonView alloc] init];
    [self.view addSubview:tip];
    [_emptyTip release];
    _emptyTip = tip;
    
    [self locateEmptyTip:tip];
    [tip setTailPosition:85.0f];
    
    /*
    UIImageView* tipImage = [[UIImageView alloc] initWithImage:nil];
    [tip addSubview:tipImage];
    [tipImage release];
    [tipImage setFrame:CGRectMake(10, 10, 50, 50)];
    
    [tipImage setBackgroundColor:[UIColor blueColor]];
    */
    
    UILabel* tipText = [[UILabel alloc] init];
    [tip addSubview:tipText];
    [tipText release];
    /*    
    CGFloat gapFromTipImage = 5.0f;
    CGFloat rightMargin = 10.0f;
    CGFloat bottomMargin = 10.0f + 10.0f;   //10 for ballon tail height
    
    CGFloat x = CGRectGetMaxX(tipImage.frame) + gapFromTipImage;
    CGFloat width = CGRectGetWidth(tipFrame) - x - rightMargin;
    CGFloat y = CGRectGetMinY(tipImage.frame);
    CGFloat height = CGRectGetHeight(tipFrame) - y - bottomMargin;
    */
    CGRect frame = CGRectInset(tip.bounds, 10.0f, 20.0f);
    frame = CGRectOffset(frame, 0.0f, -10.0f);
    [tipText setFrame:frame];
    [tipText setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    [tipText setTextColor:[UIColor whiteColor]];
    [tipText setFont:[UIFont fontWithName:[CSDataCenter fontChalk] size:16.0f]];
    [tipText setAdjustsFontSizeToFitWidth:YES];
    [tipText setNumberOfLines:3];
    
    [tipText setBackgroundColor:[UIColor clearColor]];
}

- (void)checkEmptyTip
{
    if ([self isSubjectNone]) {
        [self loadEmptyTips];
    }else{
        [self destroySubview:&_emptyTip];
    }
}
#pragma mark - Float View
- (void)touchBegan:(UITouch*)aTouch onCell:(CourseTableCell*)aCell
{
    [self setCondition:CourseTableControllerConditionFloat];
    
    //CourseTableCell* selectedCell = (CourseTableCell*)[courseTable cellForRowAtIndexPath:[courseTable indexPathForSelectedRow]];
    CourseTableCell* selectedCell = aCell;

    [floatingViewAdd takeOffInRect:[self.view convertRect:selectedCell.frame fromView:courseTable] withUserInfo:selectedCell.course];
    [courseTable setUserInteractionEnabled:NO];
    
}

- (void)touchMoved:(UITouch*)aTouch
{
    //DLog(@"Moved\tx:%f\ty:%f",[aTouch locationInView:self.view].x,[aTouch locationInView:self.view].y);
    
    CGPoint origin = [aTouch locationInView:self.view];
    [floatingViewAdd setCenter:origin];
}

- (void)touchEnded:(UITouch*)aTouch
{
    //DLog(@"Ended\tx:%f\ty:%f",[aTouch locationInView:self.view].x,[aTouch locationInView:self.view].y);
    
    [self setCondition:CourseTableControllerConditionAdd];
    [floatingViewAdd land];
    [courseTable setUserInteractionEnabled:YES];

}

- (void)touchCancelled:(UITouch*)aTouch
{
    [self setCondition:CourseTableControllerConditionAdd];
    [courseTable setUserInteractionEnabled:YES];

}

- (void)floatingViewLoadingSubviews:(DFFloatingView *)aFloatingView{
    UILabel* courseName = [[UILabel alloc] init];
    [aFloatingView addSubview:courseName];
    [courseName release];
    [self locateFloatingView:aFloatingView text:courseName];
    
    Course* course = nil;
    if (aFloatingView == floatingViewAdd) {
        course = (Course*)aFloatingView.userInfo;
    }else if (aFloatingView == floatingViewAlterAndRemove) {
        course = ((Schedule*)aFloatingView.userInfo).course;
    }
    
    [courseName setBackgroundColor:[UIColor clearColor]];
    [courseName setText:course.name];
    [courseName setTextAlignment:UITextAlignmentCenter];
    [courseName setTextColor:[UIColor whiteColor]];
    [courseName setAutoresizingMask:63];
    [courseName setAdjustsFontSizeToFitWidth:YES];
    [courseName setFont:[UIFont fontWithName:[CSDataCenter fontChalk] size:30.0f]];
}

- (void)floatingView:(DFFloatingView *)aFloatingView landedInViewAtIndex:(NSUInteger)anIndex withUserInfo:(id)anUserInfo{
    Course* course = nil;

    if (aFloatingView == floatingViewAdd) {
        ScheduleFormCell* destinationCell = (ScheduleFormCell*)[formManager cellAtOneDimensionIndex:anIndex];
        NSInteger destinationWeekday = [dataCenter weekDayByFormColumnIndex:destinationCell.colIndex];
        NSUInteger destinationDaySeq = destinationCell.rowIndex + 1;
        
        if (!destinationCell.course) {
            course = (Course*)anUserInfo;
            [dataCenter insertScheduleWithWeekday:destinationWeekday daySeq:destinationDaySeq course:course];
            [destinationCell setCourse:course];
            [destinationCell reloadContent];
        }
       
    }else if (aFloatingView == floatingViewAlterAndRemove) {
        Schedule* sourceSchedule = (Schedule*)anUserInfo;
        course = sourceSchedule.course;
        NSUInteger columnIndex = [dataCenter columnIndexByWeekday:[sourceSchedule.colInfo.colIndex integerValue]];
        NSUInteger rowIndex = [sourceSchedule.rowInfo.rowIndex unsignedIntegerValue] - 1;
        ScheduleFormCell* sourceCell = (ScheduleFormCell*)[formManager cellAtColumn:columnIndex row:rowIndex];
        
        NSUInteger cellCount = formManager.colCount * formManager.rowCount;
        if (cellCount == anIndex) {
            //Remove course from source Cell
            [sourceCell setCourse:nil];
            [sourceCell reloadContent];
            //Remove source schedule
            [course removeSchedulesObject:sourceSchedule];
            [dataCenter deleteCoreDataObject:sourceSchedule];
        }else{
            ScheduleFormCell* destinationCell = (ScheduleFormCell*)[formManager cellAtOneDimensionIndex:anIndex];
            if (!destinationCell.course) {
                NSInteger destinationWeekday = [dataCenter weekDayByFormColumnIndex:destinationCell.colIndex];
                NSUInteger destinationDaySeq = destinationCell.rowIndex + 1;
                
                //Add course to destination Cell
                [destinationCell setCourse:course];
                [destinationCell reloadContent];
                
                //Remove course from source Cell
                [sourceCell setCourse:nil];
                [sourceCell reloadContent];
                
                //Add new schedule
                [dataCenter insertScheduleWithWeekday:destinationWeekday daySeq:destinationDaySeq course:course];
                
                //Remove source schedule
                [course removeSchedulesObject:sourceSchedule];
                [dataCenter deleteCoreDataObject:sourceSchedule];
            }
        }
    }
}

- (BOOL)floatingView:(DFFloatingView*)aFloatingView stuckByViewAtIndex:(NSUInteger)anIndex inRect:(CGRect)aRect{
    BOOL showDefaultAnimation = YES;
    if (aFloatingView == floatingViewAlterAndRemove) {
        NSUInteger cellCount = formManager.colCount * formManager.rowCount;
        if (cellCount == anIndex) {
            showDefaultAnimation = NO;
            CGRect destinationFrame = CGRectInset(aRect, aRect.size.width / 2, aRect.size.height / 2);
            
            [UIView beginAnimations:@"floatingView:stuckByViewAtIndex:inRect:" context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationDuration:0.1f]; 
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            //[UIView setAnimationBeginsFromCurrentState:YES];
            
            [aFloatingView setFrame:destinationFrame];
                       
            [UIView commitAnimations];
        }
    }
    return showDefaultAnimation;
}

#pragma mark - Condition Change
- (void)setCondition:(CourseTableControllerCondition)aCondition
{
    if (condition == aCondition) {
        return;
    }
    condition = aCondition;
    switch (aCondition) {
        case CourseTableControllerConditionNormal:{
            [self alphaUnderNormalCondition];
            [formManager setUserInteractionEnabled:NO];
            [courseTable setUserInteractionEnabled:YES];
            break;
        }
        case CourseTableControllerConditionAdd:{
            [self alphaUnderAddConditon];
            [formManager setUserInteractionEnabled:YES];
            [courseTable setUserInteractionEnabled:YES];
            [formManager setTouchingConditon:DFFormViewTouchingConditonNone];

            break;
        }
        case CourseTableControllerConditionAlterAndRemove:{
            [self alphaUnderAlterAndRemoveConditon];
            [formManager setUserInteractionEnabled:YES];
            [courseTable setUserInteractionEnabled:NO];
            [formManager setTouchingConditon:DFFormViewTouchingConditonCell];
            break;
        }
        case CourseTableControllerConditionFloat:{
            [self alphaUnderFloatConditon];
            [formManager setUserInteractionEnabled:YES];
            [courseTable setUserInteractionEnabled:YES];
            break;
        }
        default:
            break;
    }
}

- (void)switchAmongConditions
{
    /*
     Control the order in condition cycle
     */
    switch (condition) {
        case CourseTableControllerConditionNormal:{
            [self setCondition:CourseTableControllerConditionAdd];
            break;
        }
        case CourseTableControllerConditionAdd:{
            [self setCondition:CourseTableControllerConditionAlterAndRemove];
            break;
        }
        case CourseTableControllerConditionAlterAndRemove:{
            [self setCondition:CourseTableControllerConditionNormal];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Alpha Management
- (void)alphaUnderNormalCondition
{
    [UIView beginAnimations:@"alphaUnderNormalCondition" context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.3f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    [courseTable setAlpha:1.0f];
    [formManager setAlpha:0.0f];
	
    [UIView commitAnimations];
}

- (void)alphaUnderFloatConditon
{
    [UIView beginAnimations:@"alphaUnderFloatConditon" context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationDuration:0.3f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    [courseTable setAlpha:0.0f];
    [formManager setAlpha:1.0f];
	
    [UIView commitAnimations];
}

- (void)alphaUnderAddConditon
{
    [UIView beginAnimations:@"alphaUnderAddConditon" context:UIGraphicsGetCurrentContext()];

	[UIView setAnimationDuration:0.3f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    [courseTable setAlpha:0.5f];
    [formManager setAlpha:0.5f];
	
    [UIView commitAnimations];
}

- (void)alphaUnderAlterAndRemoveConditon
{
    [UIView beginAnimations:@"alphaUnderAlterAndRemoveConditon" context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.3f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    [courseTable setAlpha:0.0f];
    [formManager setAlpha:1.0f];
	
    [UIView commitAnimations];
}

#pragma mark - UIView Animation Protocol
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"alphaUnderAlterAndRemoveConditon"]) {
		[self.view bringSubviewToFront:formManager];
	}else if ([animationID isEqualToString:@"alphaUnderNormalCondition"]){
        [self.view bringSubviewToFront:courseTable];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)configureFetchedResultsController
{
    if (fetchedResultsController) return fetchedResultsController;    
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:dataCenter.managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    NSFetchedResultsController* newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [newFetchedResultsController setDelegate:self];
    
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    return newFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    [courseTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [courseTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [courseTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                       withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath 
{
    
    UITableView *tableView = courseTable;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(CourseTableCell*)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
    [courseTable endUpdates];
    [self setTopLabelContent];
}

#pragma mark - UITableViewDataSource & DFFloatingViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CourseTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTable"];
	if (!cell) cell = [[CourseTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CourseTable"];
	
    [self configureCell:cell atIndexPath:indexPath];
	
    return (UITableViewCell*)cell;
}

- (void)configureCell:(CourseTableCell*)aDayCell atIndexPath:(NSIndexPath *)indexPath
{
    
    Course* course = [fetchedResultsController objectAtIndexPath:indexPath];
    
    [aDayCell setSuperController:self];
    [aDayCell setCourse:course];    
    [aDayCell loadSubviews];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray* allCourses = [dataCenter requestByTemplateName:@"allCourses"];
	NSUInteger courseCount = [allCourses count];
	DLog(@"Data Center keeps %d courses now.",courseCount);
	return courseCount;
}

- (void)touchedDownInsideCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex{
    ScheduleFormCell* cell = (ScheduleFormCell*)[formManager cellAtColumn:aColumnIndex row:aRowIndex];
    if (cell.course) {
        Schedule* schedule = [dataCenter scheduleAtWeekday:[dataCenter weekDayByFormColumnIndex:aColumnIndex] daySeq:aRowIndex + 1];
        [floatingViewAlterAndRemove takeOffInView:cell withUserInfo:schedule];
        [trashView setAlpha:1.0f];
    }
}

- (void)touch:(UITouch*)aTouch moveFromCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex inside:(BOOL)isInside{
    CGPoint origin = [aTouch locationInView:self.view];
    [floatingViewAlterAndRemove setCenter:origin];
}

- (void)touchedUpInside:(BOOL)isInside cellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex{
    [floatingViewAlterAndRemove land];
    [trashView setAlpha:0.0f];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (condition) {
        case CourseTableControllerConditionNormal:{
            CourseTableCell* cell = (CourseTableCell*)[tableView cellForRowAtIndexPath:indexPath];
            Course* course = cell.course;
            [(CoursesNvCon*)self.navigationController pushCourseConWithCourse:course animated:YES];
        }
            break;
            
        case CourseTableControllerConditionAdd:
            
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return COURSE_TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Course* removingCourse = [fetchedResultsController objectAtIndexPath:indexPath];
        [dataCenter deleteCoreDataObject:removingCourse];
    }    
}

#pragma mark - DFInstructor Delegate
- (void)instructorLoadingSubviews:(DFInstructor *)anInstructor{
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CourseTableConInstructor" owner:self options:nil] objectAtIndex:0];
    [anInstructor addSubview:xibView];
    
    //[_LabelB0 setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    //[_LabelB0 setBackgroundColor:[UIColor lightGrayColor]];
    
    //[_LabelB1 setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    //[_LabelB1 setBackgroundColor:[UIColor lightGrayColor]];
    
    //[_LabelB2 setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    //[_LabelB2 setBackgroundColor:[UIColor lightGrayColor]];    

    //[_LabelB3 setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    //[_LabelB3 setBackgroundColor:[UIColor lightGrayColor]];    

    
    NSString* imageName = nil;
    NSString* label03 = nil;
    switch (condition) {
        case CourseTableControllerConditionNormal:{
            imageName = @"Instructor_CourseTable_Show";
            label03 = NSLocalizedString(@"CourseTableController_03_00", kMissLocalizedString);
            break;
        }
        case CourseTableControllerConditionAdd:{
            imageName = @"Instructor_CourseTable_Add";
            label03 = NSLocalizedString(@"CourseTableController_03_01", kMissLocalizedString);
            break;
        }
        case CourseTableControllerConditionAlterAndRemove:{
            imageName = @"Instructor_CourseTable_Remove";
            label03 = NSLocalizedString(@"CourseTableController_03_02", kMissLocalizedString);
            break;
        }
        default:
            break;
    }
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    [_ImageB3 setImage:image];
    [_LabelB3 setText:label03];
}

#pragma mark - Tool Bar
- (void)addNewCourse
{
    CoursesNvCon* navCon = (CoursesNvCon*)self.navigationController;
    [navCon pushCourseConWithCourse:nil animated:YES];
}

- (void)buttonCallInstructor:(UIBarButtonItem*)sender event:(UIEvent*)event{
    UITouch* touch = [event.allTouches anyObject];
    
    DFControllerManager* manager = [DFControllerManager sharedControllerManager];
    [manager.instructor setDelegate:self];
    [manager.instructor presentByUIBarButtonItem:sender touch:touch inView:manager.superWindow animated:YES];
}

- (void)setToolBarItems
{
	//if (toolBarItems) [toolBarItems release];
	
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem* edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																		  target:self 
																		  action:@selector(switchAmongConditions)];
	
    UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self 
                                                                         action:@selector(addNewCourse)];
    
	DFControllerManager* controllerManager = [DFControllerManager sharedControllerManager];
	UIBarButtonItem* schedule = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemSchedule target:controllerManager action:@selector(resetScheduleNvConAsRootController)];
	
    UIBarButtonItem* instruction = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemInstructor target:self action:@selector(buttonCallInstructor:event:)];
    
	NSArray* toolBarItems = [[NSArray alloc] initWithObjects:edit,flexibleSpace,add,flexibleSpace,flexibleSpace,schedule,flexibleSpace,instruction,nil];
	[flexibleSpace release];
	[edit release];
	[schedule release];
	[instruction release];
	[add release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}

#pragma mark - DataSource
- (DFFormViewCell*)allocCellForFormView:(DFFormView *)aFormView{
    ScheduleFormCell* cell = [[ScheduleFormCell alloc] init];
    return (DFFormViewCell*)cell;
}

- (void)fillFormWithContent:(DFFormView *)aForm
{
    NSArray* wholeSchedule = [dataCenter requestForSchdule];
    
    Schedule* pSchedule = nil;
    ScheduleFormCell* pCell = nil;
    NSUInteger columnIndex = 0,rowIndex = 0;
    for (pSchedule in wholeSchedule) {
        columnIndex = [dataCenter columnIndexByWeekday:[pSchedule.colInfo.colIndex unsignedIntegerValue]];
        rowIndex = [pSchedule.rowInfo.rowIndex unsignedIntegerValue] - 1;
        pCell = (ScheduleFormCell*)[aForm cellAtColumn:columnIndex row:rowIndex];
        [pCell setCourse:pSchedule.course];
    }
}

#pragma mark - Memory Management

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [courseTable reloadData];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self.navigationController setToolbarHidden:NO];
	[self setToolBarItems];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self locateCourseTable:courseTable];
    [courseTable deselectRowAtIndexPath:courseTable.indexPathForSelectedRow animated:animated];
    
    [self locateFormManager:formManager];
    [formManager reloadContent];
    
    [floatingViewAdd setAccessedViews:[formManager oneDimensionCellArray]];
    
    NSMutableArray* arrayContainsCellsAndTrashView = [[NSMutableArray alloc] initWithArray:[formManager oneDimensionCellArray]];
    [arrayContainsCellsAndTrashView addObject:trashView];
    [floatingViewAlterAndRemove setAccessedViews:arrayContainsCellsAndTrashView];
    [arrayContainsCellsAndTrashView release];
    
    [self locateEmptyTip:_emptyTip];
    [self checkEmptyTip];
}

- (void)loadView
{
	[super loadView];
    
    fetchedResultsController = [self configureFetchedResultsController];
    
    if (!topLabel) {
        topLabel = [[UILabel alloc] init];
        [self.view addSubview:topLabel];
    }
    [self configureTopLabel];
    
    if (!trashView) {
        trashView = [[UIView alloc] init];
        [self.view addSubview:trashView];
    }
    [self configureTrashView];
    
    if (!formManager) {
        formManager = [[DFFormView alloc] init];
        [self.view insertSubview:formManager atIndex:0];
    }
    [self configureFormManager:formManager];
    
    if (!courseTable) {
        courseTable = [[UITableView alloc] init];
        [self.view addSubview:courseTable];
    }
    [self configureCourseTable:courseTable];
    
    if (!floatingViewAdd) {
        floatingViewAdd = [[DFFloatingView alloc] initWithStageView:self.view];
    }
    [floatingViewAdd setDelegate:self];
    [floatingViewAdd setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    
    if (!floatingViewAlterAndRemove) {
        floatingViewAlterAndRemove = [[DFFloatingView alloc] initWithStageView:self.view];
    }
    [floatingViewAlterAndRemove setDelegate:self];
    [floatingViewAlterAndRemove setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f]];
    
    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    NSError* fetchError = nil;
    if (![fetchedResultsController performFetch:&fetchError]) {
        DLog(@"%@\n%@",fetchError,fetchError.userInfo);
    }
    
    [formManager setAlpha:0.0f];
}


- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [fetchedResultsController release];
    fetchedResultsController = nil;
    
    [self destroySubview:&topLabel];
    [self destroySubview:&trashView];
    [self destroySubview:&courseTable];
    [self destroySubview:&formManager];
    [self destroySubview:&floatingViewAdd];
    [self destroySubview:&floatingViewAlterAndRemove];

}

- (id)init{
	if (self = [super init]) {
        dataCenter = [CSDataCenter sharedDataCenter];
        
        condition = CourseTableControllerConditionNormal;
	}
	return self;
}

- (void)dealloc 
{
    [fetchedResultsController release];
    fetchedResultsController = nil;
    
    [self destroySubview:&topLabel];
    [self destroySubview:&trashView];
    [self destroySubview:&courseTable];
    [self destroySubview:&formManager];
    [self destroySubview:&floatingViewAdd];
    [self destroySubview:&floatingViewAlterAndRemove];
    
    [self destroyMember:&_ImageB0];
    [self destroyMember:&_ImageB1];
    [self destroyMember:&_ImageB2];
    [self destroyMember:&_ImageB3];
    [self destroyMember:&_LabelB0];
    [self destroyMember:&_LabelB1];
    [self destroyMember:&_LabelB2];
    [self destroyMember:&_LabelB3];

    [super dealloc];
}

@end
