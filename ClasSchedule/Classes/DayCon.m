#import "DayCon.h"
#import "Header.h"

@implementation DayCon

@synthesize focus,isFocused;

#pragma mark - Frames
- (CGRect)frameOfDayCourseTable
{
	return self.view.bounds;
}

#pragma mark - Title
- (void)configureTitle
{
    NSUInteger theWeekday = weekday;
    NSString* newTitle = [dataCenter weekdayStringByWeekday:theWeekday];
    [self setTitle:newTitle];
}

#pragma mark - Focus
- (NSIndexPath*)configureDefaultFocus
{
    NSIndexPath* defaultFocus = nil;
    if (isFocused) {
        NSDate* standardRightNow = [CSDataCenter getStandardRightNow];
        
        NSUInteger count = [[fetchedResultsController fetchedObjects] count];
        NSUInteger index = 0;
        NSIndexPath* pIndexPath = nil;
        Schedule* pSchedule = nil;
        NSDate* pFirstDate = nil;
        NSDate* pSecondDate = nil;
        for (index = 0; index < count; index++) {
            pIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
            pSchedule = [fetchedResultsController objectAtIndexPath:pIndexPath];
            pFirstDate = pSchedule.rowInfo.startTime;
            pSecondDate = pSchedule.rowInfo.endTime;
            if ([CSDataCenter date:standardRightNow isBetweenDate:pFirstDate andDate:pSecondDate]) {
                defaultFocus = pIndexPath;
                break;
            }
        }
    }
    return defaultFocus;
}

- (void)focusOn:(NSIndexPath*)anIndexPath withAnimation:(BOOL)anAnimation
{
    if (focus && anIndexPath && focus.row == anIndexPath.row) {
        return;
    }
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:2];

    NSIndexPath* oldFocus = nil;
    if (focus) {
        oldFocus = [NSIndexPath indexPathForRow:focus.row inSection:0];
        DayCell* oldCell = (DayCell*)[self.tableView cellForRowAtIndexPath:oldFocus];
        [oldCell setIsFocused:NO];
        [array addObject:oldFocus];
    }
    
    NSIndexPath* newFocus = nil;
    if (anIndexPath) {
        newFocus = [NSIndexPath indexPathForRow:anIndexPath.row inSection:0];
        DayCell* newCell = (DayCell*)[self.tableView cellForRowAtIndexPath:newFocus];
        [newCell setIsFocused:YES];
        [array addObject:newFocus];
    }
    
    [self setFocus:newFocus];
    
    [self.tableView scrollToRowAtIndexPath:focus atScrollPosition:UITableViewScrollPositionMiddle animated:anAnimation];
    
    if (anAnimation) {
        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    }
    [array release];
}

- (void)focusOnDefaultAnimated
{
    [self focusOn:[self configureDefaultFocus] withAnimation:YES];
}

- (void)renewFocusTimer
{    
    NSTimeInterval timeInterval = 3.0;
    
    NSTimer* theTimer = focusTimer;
    if (theTimer) {
        [theTimer invalidate];
        [theTimer release];
    }
    NSDate* fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeInterval];
    theTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:0.0f target:self selector:@selector(refocusOnDefaultRowByTimer:) userInfo:nil repeats:NO];
    NSRunLoop* currentRunRoop = [NSRunLoop currentRunLoop];
    [currentRunRoop addTimer:theTimer forMode:NSDefaultRunLoopMode];
    [fireDate release];
    focusTimer = theTimer;
}

- (void)focusByUser:(NSIndexPath*)anIndexPath
{
    [self focusOn:anIndexPath withAnimation:YES];
    //[self.tableView scrollToRowAtIndexPath:anIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self renewFocusTimer];
}

- (void)refocusOnDefaultRowByTimer:(NSTimer*)theTimer
{
    if (theTimer == focusTimer) {
        [self focusOnDefaultAnimated];
        [focusTimer invalidate];
        [focusTimer release];
        focusTimer = nil;
    }else if (theTimer == focusMinuteTimer && focusTimer == nil) {
        [self focusOnDefaultAnimated];
    }
}

- (void)newFocusMinuteTimer
{
    if (focusMinuteTimer) {
        [focusMinuteTimer invalidate];
        [focusMinuteTimer release];
    }
    NSTimer* newTimer = [[NSTimer alloc] initWithFireDate:[CSDataCenter getNextMinute] interval:60.0 target:self selector:@selector(refocusOnDefaultRowByTimer:) userInfo:nil repeats:YES];
    NSRunLoop* currentRunRoop = [NSRunLoop currentRunLoop];
    [currentRunRoop addTimer:newTimer forMode:NSDefaultRunLoopMode];
    focusMinuteTimer = newTimer;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)configureFetchedResultsController
{
    if (fetchedResultsController) return fetchedResultsController;    
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Schedule" inManagedObjectContext:dataCenter.managedObjectContext];
    
    //NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"seq_day" ascending:YES];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rowInfo.rowIndex" ascending:YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"seq_week == %d",seqInWeek];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"colInfo.colIndex == %d",weekday];

    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    //NSFetchedResultsController* newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:@"DayConFRC"];
    NSFetchedResultsController* newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [newFetchedResultsController setDelegate:self];
    
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    return newFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
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
            [self configureCell:(DayCell*)[tableView cellForRowAtIndexPath:indexPath]
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource
- (void)configureCell:(DayCell*)aDayCell atIndexPath:(NSIndexPath *)indexPath
{
    Schedule* schedule = [fetchedResultsController objectAtIndexPath:indexPath];
    [aDayCell setSchedule:schedule];    
    
    BOOL isCellFocused = NO;
    if (focus && (focus.row == indexPath.row)) isCellFocused = YES;
    [aDayCell setIsFocused:isCellFocused];
    
    BOOL isWeekdayFocused = isFocused;
    [aDayCell setIsWeekdayFocused:isWeekdayFocused];
    [aDayCell loadSubviews];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	DayCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DayCourseTable"];
    if (!cell) cell = [[DayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DayCourseTable"];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return (UITableViewCell*)cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[fetchedResultsController fetchedObjects] count];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Schedule* deletingScheduel = [fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectContext* managedObjectContext = [CSDataCenter sharedDataCenter].managedObjectContext;
        [managedObjectContext deleteObject:deletingScheduel];
    }    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DayCell* cell = (DayCell*)[tableView cellForRowAtIndexPath:indexPath];
    BOOL isCellFocused = cell.isFocused;
    if (isCellFocused) {
        Course* course = cell.schedule.course;
        [(ScheduleNvCon*)self.navigationController pushCourseConWithCourse:course animated:YES];
    }else{
        [self focusByUser:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [DayCell heightWhenNotFocused];
    
    if (focus) {
        if (focus.row == indexPath.row) {
            height = [DayCell heightWhenFocused];
        }
    }
    return height;
}

#pragma mark - DFInstructorDelegate
- (void)instructorLoadingSubviews:(DFInstructor *)anInstructor{
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"DayConInstructor" owner:self options:nil] objectAtIndex:0];
    [anInstructor addSubview:xibView];
    
    //[_Label0 setText:NSLocalizedString(@"NoneSubjectsTip", nil)];
    //[_Label0 setBackgroundColor:[UIColor lightGrayColor]];
    
}

#pragma mark - Tool Bar
- (void)enterDeletingConditon
{
    [self setToolBarItemsToDeletingConditon];
    if (focus) {
        [self focusOn:nil withAnimation:YES];
        [self performSelector:@selector(tableViewSetEditingYes) withObject:nil afterDelay:0.5];
    }else{
        [self tableViewSetEditingYes];
    }
}

- (void)tableViewSetEditingYes
{
    [self.tableView setEditing:YES animated:YES];
}

- (void)cancelDeletingMode
{
    [self setToolBarItems];
    [self.tableView setEditing:NO animated:YES];
    [self performSelector:@selector(focusOnDefaultAnimated) withObject:nil afterDelay:0.5];
}

- (void)buttonCallInstructor:(UIBarButtonItem*)sender event:(UIEvent*)event
{
    UITouch* touch = [event.allTouches anyObject];
    
    DFControllerManager* manager = [DFControllerManager sharedControllerManager];
    [manager.instructor setDelegate:self];
    [manager.instructor presentByUIBarButtonItem:sender touch:touch inView:manager.superWindow animated:YES];
}

#pragma mark - Set Tool Bar
- (void)setToolBarItemsToDeletingConditon
{
    UIBarButtonItem* returnButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelDeletingMode)];
	
	NSArray* toolBarItems = [[NSArray alloc] initWithObjects:returnButton,nil];
	[returnButton release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}

- (void)setToolBarItems
{
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(enterDeletingConditon)];
	
    UIBarButtonItem* instruction = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemInstructor target:self action:@selector(buttonCallInstructor:event:)];
	
    NSArray* toolBarItems = [[NSArray alloc] initWithObjects:delete,flexibleSpace,instruction,nil];
	[flexibleSpace release];
	[delete release];
	[instruction release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}
#pragma mark - Memory Management
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isFocused) {
        [self focusOn:[self configureDefaultFocus] withAnimation:NO];
    }
    [self.tableView reloadData];
    
    [self.navigationController setToolbarHidden:NO];
	[self setToolBarItems];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView scrollToRowAtIndexPath:focus atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
}

- (void)loadView{
	[super loadView];

	[self configureTitle];
    
    fetchedResultsController = [self configureFetchedResultsController];
    NSError* fetchError = nil;
    if (![fetchedResultsController performFetch:&fetchError]) { DLog(@"%@\n%@",fetchError,fetchError.userInfo) };
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
    [fetchedResultsController release];
    fetchedResultsController = nil;
}

- (id)init{
	if (self = [super init]) {
        weekday = NSUIntegerMax;
        dataCenter = [CSDataCenter sharedDataCenter];
	}
	return self;
}

- (id)initWithWeekday:(NSInteger)aWeekDay
{
    if (self = [self init]) {
        weekday = aWeekDay;
        if (isFocused) {
            [self newFocusMinuteTimer];
        }
	}
    return self;
}

- (void)dealloc {
    weekday = NSUIntegerMax;
    
    [focus release];
    focus = nil;
    
    [focusTimer invalidate];
    [focusTimer release];
    focusTimer = nil;
    
    [focusMinuteTimer invalidate];
    [focusMinuteTimer release];
    focusMinuteTimer = nil;
    
    [fetchedResultsController release];
    fetchedResultsController = nil;
    
    [self destroyMember:&_Image0];
    [self destroyMember:&_Label0];
    
    [super dealloc];
}

@end
