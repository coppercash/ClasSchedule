#import "WeekCon.h"
#import "Header.h"

@implementation WeekCon

#pragma mark - Frames
- (CGRect)locateTopLabel
{
    CGFloat topMaigin = 10.0f;
    
    UILabel* theTopLabel = topLabel;
    [theTopLabel setBounds:CGRectMake(0.0f, 0.0f, 280.0f, 30.0f)];
    [theTopLabel setCenter:CGPointMake(self.view.bounds.size.width / 2, topMaigin + theTopLabel.bounds.size.height / 2)];
    
    return theTopLabel.frame;
}

- (CGRect)locateScheduleForm:(UIView*)aView
{
    CGFloat x;
    CGFloat width ;
    CGFloat y;
    CGFloat height;
    
    switch (editingMode) {
        case EditingModeOff:{
            CGFloat horizontalMargin = 10.0f;
            x = horizontalMargin;
            y = 70.0f;
            width = self.view.bounds.size.width - 2* horizontalMargin;
            height = self.view.bounds.size.height - y - 10.0f;

            break;
        }
        case EditingModeOn:{
            CGFloat leftlMargin = 50.0f;
            CGFloat rightMargin = 40.0f;

            x = leftlMargin;
            y = 70.0f;
            width = self.view.frame.size.width - leftlMargin - rightMargin;
            height = 280.0f;
            
            break;
        }
        default:
            break;
    }
    
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateScheduleBoundaryView:(UIView*)aView
{
    CGFloat leftMargin = 10.0f;
    
    CGRect scheduleFormFrame = [self locateScheduleForm:nil];
    
    CGFloat x = leftMargin;
    CGFloat width = scheduleFormFrame.origin.x - leftMargin - 5.0f;
    
    CGFloat height = scheduleFormFrame.size.height;
    CGFloat y = scheduleFormFrame.origin.y;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateScheduleBoundaryViewUnderTimeDependentMode:(UIView*)aView
{
    CGFloat horizontalMargin = 10.0f;
    
    CGRect oringinalFrame = [self locateScheduleBoundaryView:nil];
    
    CGFloat x = horizontalMargin;
    CGFloat width = self.view.frame.size.width - 2 * horizontalMargin;
    
    CGFloat y = oringinalFrame.origin.y;
    CGFloat height = self.view.frame.size.height - y;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateSlider:(UIView*)aView
{
    CGRect scheduleFrame = [self locateScheduleForm:nil];
    
    CGFloat x = scheduleFrame.origin.x + scheduleFrame.size.width + 5.0f;
    CGFloat width = 23.0f;
    CGFloat y = scheduleFrame.origin.y;
    CGFloat height = scheduleFrame.size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)sliderLabelFrame
{
	return [self frameFromFrame:slider.frame x:0.0f y:-25.0f width:0.0f height:20.0f];
}

- (CGRect)locateWeekendSwitch:(UIView*)aView
{
    CGRect scheduleFrame = [self locateScheduleForm:nil];
    CGRect sliderFrame = [self locateSlider:nil];
    
    CGFloat distanceFromscheduleForm = 20.0f;
    
    CGFloat width = 94.0f;
    CGFloat height = 27.0f;
    CGFloat x = sliderFrame.origin.x + sliderFrame.size.width - width;
    CGFloat y = scheduleFrame.origin.y + scheduleFrame.size.height + distanceFromscheduleForm;
    
	CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateWeekendLabel:(UIView*)aView
{
    CGRect scheduleBoundaryViewFrame = [self locateScheduleBoundaryView:nil];
    CGRect switchFrame = [self locateWeekendSwitch:nil];

    CGFloat x = scheduleBoundaryViewFrame.origin.x;
    CGFloat width = 100.0f;
    CGFloat y = switchFrame.origin.y;
    CGFloat height = switchFrame.size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
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

- (CGRect)frameFromFrame:(CGRect)anOldFrame x:(float)aX y:(float)aY width:(float)aNewWidth height:(float)aNewHeight
{
	/*
	 Create new frame use the old frame's origin information."aX" & "aY" are relative to old origin. 
	 */
	float newX = anOldFrame.origin.x + aX;
	float newY = anOldFrame.origin.y + aY;
	float newWidth = 0.0f;
	float newHeight = 0.0f;
	if (aNewWidth == 0.0f) {
		newWidth = anOldFrame.size.width;
	}else {
		newWidth = aNewWidth;
	}
	if (aNewHeight == 0.0f) {
		newHeight = anOldFrame.size.height;
	}else {
		newHeight = aNewHeight;
	}
	
	return CGRectMake(newX, newY, newWidth, newHeight);
}

#pragma mark - Subviews
- (void)configureTopLabel
{
    UILabel* theTopLabel = topLabel;
    [self locateTopLabel];
    //[theTopLabel setBackgroundColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.3f]];
    [theTopLabel setBackgroundColor:[UIColor clearColor]];
    [theTopLabel setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f]];
    [theTopLabel setTextAlignment:UITextAlignmentCenter];
    [theTopLabel setAdjustsFontSizeToFitWidth:YES];
    [theTopLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:28.0f]];
    
    NSDate* now = [[NSDate alloc] init];
    NSString* dateString = [CSDataCenter getStringFromDate:now withFormat:@"MMM.d ccc"];
    [now release];
    [theTopLabel setText:dateString];
}

- (void)configureScheduleBoundaryView
{
    DFScrollScheduleBoundaryView* theView = scheduleBoundaryView;
    [theView setContentSize:[self locateScheduleBoundaryView:theView].size];
    [theView setDataSource:self];
    [theView setBeginTimeWithHour:0 minute:0 second:0];
    [theView setDuration:23 * 60 * 60 + 59 * 60];
    [theView setMinTimeScale:60];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scheduleBoundaryEnterTimeDependentMode:)];
    [theView addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)configureScheduleForm:(DFFormView*)aScheduleForm
{
    DFFormView* theScheduleForm = aScheduleForm;
    
    //[theScheduleForm setFrame:[self scheduleFormFrame]];
    [self locateScheduleForm:theScheduleForm];
	
	NSUInteger colCount = [dataCenter colCountOfScheduleForm];
	NSUInteger rowCount = [dataCenter rowCountOfScheduleForm];
    
    //[theScheduleForm setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    [theScheduleForm setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    
    [theScheduleForm setColCount:colCount];
    [theScheduleForm setRowCount:rowCount];
    [theScheduleForm setDelegate:self];
    [theScheduleForm setDataSource:self];
    [theScheduleForm setTouchingConditon:DFFormViewTouchingConditonColumn];
    //[theScheduleForm setShadowOffset:CGSizeMake(0.0f, 20.0f)];
    
    [theScheduleForm setIsTopBoundaryViewsHidden:NO];
}

- (void)configWeekendLabel:(UILabel*)aLabel
{
    [self locateWeekendLabel:aLabel];
	[aLabel setBackgroundColor:[UIColor clearColor]];
    [weekendLabel setTextColor:[UIColor whiteColor]];
	[aLabel setText:NSLocalizedString(@"WeekendSwitch",nil)];
	[aLabel setAdjustsFontSizeToFitWidth:YES];
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
}

- (void)configWeekendSwitch:(UISwitch*)aSwitch
{
    [self locateWeekendSwitch:aSwitch];
	[aSwitch addTarget:self action:@selector(weekendSwitchValueChange) forControlEvents:UIControlEventValueChanged];
	
	[aSwitch setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
	
	if (scheduleForm) {
		if (scheduleForm.colCount == 5) {
			[aSwitch setOn:NO];
		}else if (scheduleForm.colCount == 7) {
			[aSwitch setOn:YES];
		}
	}
}

- (void)configSlider:(UISlider*)aSlider
{
	CGAffineTransform rotation = CGAffineTransformMakeRotation(1.57079633);
	[aSlider setTransform:rotation];
	[aSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
	
	//[aSlider setFrame:[self sliderFrame]];
    [self locateSlider:aSlider];
	[aSlider setAutoresizingMask:
	 UIViewAutoresizingFlexibleLeftMargin | 
	 UIViewAutoresizingFlexibleWidth | 
	 UIViewAutoresizingFlexibleRightMargin | 
	 UIViewAutoresizingFlexibleTopMargin |
	 UIViewAutoresizingFlexibleHeight |
	 UIViewAutoresizingFlexibleBottomMargin];
	
	[aSlider setMinimumValue:3.0f];
	[aSlider setMaximumValue:10.0f];
	
	if (scheduleForm) {
		if (scheduleForm.rowCount) {
			[aSlider setValue:(float)scheduleForm.rowCount];
		}
	}
}

- (void)configSliderLabel:(UILabel*)aSliderLabel
{
    [aSliderLabel setFrame:[self sliderLabelFrame]];
    [aSliderLabel setTextColor:[UIColor whiteColor]];
    [aSliderLabel setBackgroundColor:[UIColor clearColor]];
	[aSliderLabel setTextAlignment:UITextAlignmentCenter];
	[aSliderLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin];
	
	if (slider) {
		NSNumber* number = [[NSNumber alloc] initWithUnsignedInteger:(NSUInteger)slider.value];
		[aSliderLabel setText:[number stringValue]];
		[number release];
	}
}

#pragma mark - Subviews Show Hide
- (void)createScheduleForm
{
    if (!scheduleForm) {
        scheduleForm = [[DFFormView alloc] init];
        [scheduleForm setAlpha:0.0f];
        [self.view addSubview:scheduleForm];
    }
    [self configureScheduleForm:scheduleForm];
    [scheduleForm createForm];
}

- (void)createConfigurationAccessory
{
    if (!slider) {
		slider = [[UISlider alloc] init];
        [slider setAlpha:0.0f];
        [self.view addSubview:slider];
    }
	[self configSlider:slider];
    
	if (!sliderLabel) {
		sliderLabel = [[UILabel alloc] init];
		[sliderLabel setAlpha:0.0f];        
        [self.view addSubview:sliderLabel];
	}
    [self configSliderLabel:sliderLabel];
    
	
	if (!weekendSwitch) {
		weekendSwitch = [[UISwitch alloc] init];
		[weekendSwitch setAlpha:0.0f];
		[self.view addSubview:weekendSwitch];
	}
    [self configWeekendSwitch:weekendSwitch];
    
	if (!weekendLabel) {
		weekendLabel = [[UILabel alloc] init];
		[weekendLabel setAlpha:0.0f];
		[self.view addSubview:weekendLabel];
	}
    [self configWeekendLabel:weekendLabel];
}

- (void)destroyConfigurationAccessory
{
    [self destroySubview:&slider];
    [self destroySubview:&sliderLabel];

    [self destroySubview:&weekendLabel];
    [self destroySubview:&weekendSwitch];
}

#pragma mark - Empty Tips
- (BOOL)isScheduleEmpty
{
    NSArray* wholeSchedule = [dataCenter requestForSchdule];
    return [wholeSchedule count] == 0;
}


- (void)loadEmptyTips
{
    DFBalloonView* tip = [[DFBalloonView alloc] init];
    [self.view addSubview:tip];
    [_emptyTip release];
    _emptyTip = tip;
    
    [self locateEmptyTip:tip];
    [tip setTailPosition:185.0f];
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
    [tipText setText:NSLocalizedString(@"EmptyScheduleTip", nil)];
    [tipText setTextColor:[UIColor whiteColor]];
    [tipText setAdjustsFontSizeToFitWidth:YES];
    [tipText setNumberOfLines:3];
    [tipText setBackgroundColor:[UIColor clearColor]];
    
    NSString* language = [CSDataCenter getLanguageCode];
    if ([language isEqualToString:@"en"]) {
        [tipText setFont:[UIFont fontWithName:[CSDataCenter fontChalk] size:10.0f]];
        
    }else if ([language isEqualToString:@"zh-Hans"]) {
        [tipText setFont:[UIFont fontWithName:[CSDataCenter fontChalk] size:14.0f]];
        
    }
}

- (void)checkEmptyTip
{
    if ([self isScheduleEmpty] && (editingMode == EditingModeOff)) {
        [self loadEmptyTips];
    }else{
        [self destroySubview:&_emptyTip];
    }
}

#pragma mark - DFScheduleBoundaryManagerDataSource & Events
- (NSUInteger)numberOfCellsManagedByManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager{
    return scheduleForm.rowCount;
}

- (NSDate*)scheduleBoundaryManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager startTimeForCellAtIndex:(NSUInteger)anIndex{
    RowsInfo* theRowInfo = [dataCenter rowInfoByRowIndex:anIndex + 1];
    return theRowInfo.startTime;
}

- (NSTimeInterval)scheduleBoundaryManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager durationForCellAtIndex:(NSUInteger)anIndex{
    RowsInfo* theRowInfo = [dataCenter rowInfoByRowIndex:anIndex + 1];
    NSTimeInterval theDuration = [theRowInfo.endTime timeIntervalSinceTime:theRowInfo.startTime];
    return theDuration;
}

- (void)scheduleBoundaryEnterTimeDependentMode:(UITapGestureRecognizer *)sender {     
    if (sender.state == UIGestureRecognizerStateEnded){         
        [self enterScheduleBoundaryMode];
    } 
}

#pragma mark - DFFormViewDelegate,DFFormViewDataSource & Events
- (DFFormViewCell*)allocCellForFormView:(DFFormView *)aFormView{
    ScheduleFormCell* cell = [[ScheduleFormCell alloc] init];
    return (DFFormViewCell*)cell;
}

- (void)fillFormWithContent:(DFFormView *)aForm{
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

- (void)topBoundaryView:(UIView *)aView onColumn:(NSUInteger)aColumnIndex{
    UILabel* label = nil;
    if ([aView.subviews count] > 0) {
        label = [aView.subviews objectAtIndex:0];
    }else{
        label = [[UILabel alloc] init];
        [aView addSubview:label];
        [label release];
    }
    
    NSInteger weekday = [dataCenter weekDayByFormColumnIndex:aColumnIndex];
    NSString* weekdayString = [dataCenter weekdayStringByWeekday:weekday];
    
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setTextColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.9f]];
	[label setAutoresizingMask:63];
    [label setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:12.0f]];
    
    [label setFrame:CGRectMake(0.0f, 0.0f, aView.bounds.size.width, aView.bounds.size.height)];
    [label setText:weekdayString];
}

- (void)touchedUpInsideCellsAtColumn:(NSUInteger)aColumnIndex{
    NSInteger weekDay = [dataCenter weekDayByFormColumnIndex:aColumnIndex];
    NSArray* schedules = [dataCenter schedulesAtWeekday:weekDay];
    if ([schedules count]) [self toPushDayControllerWithSeqInWeek:weekDay];
}

- (void)saveColAndRowCount
{
	if (!scheduleForm) return;
    [dataCenter setColsInfoWithColCount:scheduleForm.colCount];
    [dataCenter setRowsInfoWithRowCount:scheduleForm.rowCount];
}

#pragma mark - DFInstructorDelegate
- (void)instructorLoadingSubviews:(DFInstructor *)anInstructor{
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"WeekConInstructor" owner:self options:nil] objectAtIndex:0];
    [anInstructor addSubview:xibView];
}

#pragma mark - Tool Bar
- (void)done
{
    [self saveColAndRowCount];
    [scheduleForm reloadContent];
	[self switchOfEditingMode];
    
    //DLog(@"test %d",[[CSDataCenter sharedDataCenter] colCountOfScheduleForm]);
}

- (void)cancel
{
	NSUInteger colCount = 0;
	NSUInteger rowCount = 0;
	//[dataCenter requestIntoColCount:&colCount rowCount:&rowCount];
    
    colCount = [dataCenter colCountOfScheduleForm];
    rowCount = [dataCenter rowCountOfScheduleForm];
    
	//[scheduleForm recreateCellsWithColCount:colCount rowCount:rowCount];
    [scheduleForm setColCount:colCount rowCount:rowCount];
    
	[self switchOfEditingMode];
}

- (void)doneOfScheduleBoundary
{
    NSUInteger index = 0;
    NSUInteger rowCount = [dataCenter rowCountOfScheduleForm];
    RowsInfo* pRowInfo = nil;
    DFScheduleBoundaryManagerCell* pCell = nil;
    NSDate* pStartTime = nil;
    NSDate* pEndTime = nil;
    for (index = 0; index < rowCount; index++) {
        pCell = [scheduleBoundaryView cellAtIndex:index];
        pRowInfo = [dataCenter rowInfoByRowIndex:index + 1];
        pStartTime = [CSDataCenter getStandardDateFromDate:pCell.beginTime];
        [pRowInfo setStartTime:pStartTime];
        pEndTime = [CSDataCenter getStandardDateFromDate:[pCell.beginTime dateByAddingTimeInterval:pCell.duration]];
        [pRowInfo setEndTime:pEndTime];
    }
    
    [self cancelScheduleBoundaryMode];
}

- (void)cancelOfScheduleBoundary
{
    [scheduleBoundaryView reloadData];
    [self cancelScheduleBoundaryMode];
}

- (void)buttonCallInstructor:(UIBarButtonItem*)sender event:(UIEvent*)event{
    UITouch* touch = [event.allTouches anyObject];
    
    DFControllerManager* manager = [DFControllerManager sharedControllerManager];
    [manager.instructor setDelegate:self];
    [manager.instructor presentByUIBarButtonItem:sender touch:touch inView:manager.superWindow animated:YES];
}

#pragma mark - Set Tool Bar
- (void)setToolBarItems
{	
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem* edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
																		  target:self 
																		  action:@selector(switchOfEditingMode)];
	
	DFControllerManager* controllerManager = [DFControllerManager sharedControllerManager];
    UIBarButtonItem* classes = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemSubjects target:controllerManager action:@selector(resetCoursesNvConAsRootController)];
    
	
    UIBarButtonItem* instruction = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemInstructor target:self action:@selector(buttonCallInstructor:event:)];
    
	NSArray* toolBarItems = [[NSArray alloc] initWithObjects:edit,flexibleSpace,flexibleSpace,classes,flexibleSpace,instruction,nil];
	[flexibleSpace release];
	[edit release];
	[classes release];
	[instruction release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}

- (void)setToolBarItemsToEdit
{
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		  target:self 
																		  action:@selector(done)];
	
	UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																			target:self 
																			action:@selector(cancel)];
	
	
	NSArray* toolBarItems = [[NSArray alloc] initWithObjects:cancel,flexibleSpace,done,nil];
	[flexibleSpace release];
	[done release];
	[cancel release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}

- (void)setToolBarItemsUnderScheduleBoundary
{	
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																				   target:nil 
																				   action:nil];
	
	UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		  target:self 
																		  action:@selector(doneOfScheduleBoundary)];
	
	UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																			target:self 
																			action:@selector(cancelOfScheduleBoundary)];
	
	
	NSArray* toolBarItems = [[NSArray alloc] initWithObjects:cancel,flexibleSpace,done,nil];
	[flexibleSpace release];
	[done release];
	[cancel release];
    
    [self setToolbarItems:toolBarItems animated:YES];
    [toolBarItems release];
}

#pragma mark - Weekend Switch
- (void)weekendSwitchValueChange
{
	if (weekendSwitch.on) {
		[self reformScheuleFormWithColCount:7];
	}else {
		[self reformScheuleFormWithColCount:5];
	}
}

- (void)reformScheuleFormWithColCount:(NSInteger)aColCount
{
    [scheduleForm setColCount:aColCount];
}

#pragma mark - Slider
- (void)reformScheuleFormWithRowCount:(NSInteger)aRowCount
{
    [scheduleForm setRowCount:aRowCount];
}

- (void)sliderValueChange
{
	UISlider* localSlider = slider;
	if (!localSlider) {
		DLog(@"Slider doesnt exists");
		return;
	}
	
	float current = [self adhesionSlider:localSlider asParts:8 act:nil at:nil];
	[self reformScheuleFormWithRowCount:(NSUInteger)current];
	
	if (sliderLabel) {
		NSNumber* number = [[NSNumber alloc] initWithUnsignedInteger:(NSUInteger)slider.value];
		[sliderLabel setText:[number stringValue]];
		[number release];
	}
}

- (float)adhesionSlider:(UISlider*)aSlider asParts:(NSUInteger)aPartsCount act:(SEL)anAction at:(id)aTarget
{
	float value = aSlider.value;
	float part = (aSlider.maximumValue - aSlider.minimumValue)/(aPartsCount - 1);
	float adhesion = part/2;
	float current = aSlider.minimumValue;
	float currentMin = 0.0f;
	float currentMax = 0.0f;
	
	for (int i = 0; i < aPartsCount; i++) {
		currentMin = current - adhesion;
		currentMax = current + adhesion;
		if (currentMin < value && value <= currentMax) {
			[aSlider setValue:current];
			[aTarget performSelector:anAction];
			break;
		}
		current = current + part;
	}
	return current;
}

#pragma mark - Mode Convert
- (void)switchOfEditingMode
{
	if (editingMode == EditingModeOff) {
		editingMode = EditingModeOn;
		[self setToolBarItemsToEdit];
		[self enterEditingMode];
	}else if (editingMode == EditingModeOn) {
		editingMode = EditingModeOff;
		[self setToolBarItems];
		[self cancelEditingMode];
	}
    [self checkEmptyTip];
}

- (void)cancelEditingMode
{
	if (editingMode == EditingModeOn) return;
	
	[scheduleForm transformSelfIntoRect:[self locateScheduleForm:nil]];
    [scheduleForm setTouchingConditon:DFFormViewTouchingConditonColumn];
    [scheduleForm setIsContentHidden:NO];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"cancelEditingMode" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [scheduleBoundaryView setAlpha:0.0f];
	[slider setAlpha:0.0f];
	[sliderLabel setAlpha:0.0f];
	[weekendSwitch setAlpha:0.0f];
	[weekendLabel setAlpha:0.0f];
	
	[UIView commitAnimations];
    
    [scheduleForm setIsTopBoundaryViewsHidden:NO];
    
}

- (void)enterEditingMode
{
	if (editingMode == EditingModeOff) return;
	
    [scheduleForm setIsTopBoundaryViewsHidden:YES];
	[scheduleForm transformSelfIntoRect:[self locateScheduleForm:nil]];
    [scheduleForm setTouchingConditon:DFFormViewTouchingConditonNone];
    [scheduleForm setIsContentHidden:YES];
    
    if (!scheduleBoundaryView) {
        scheduleBoundaryView = [[DFScrollScheduleBoundaryView alloc] init];
        [scheduleBoundaryView setAlpha:0.0f];
        [self.view addSubview:scheduleBoundaryView];
    }
    [self configureScheduleBoundaryView];
    [scheduleBoundaryView loadSubviews];
    
	[self createConfigurationAccessory];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"enterEditingMode" context:context];
	[UIView setAnimationDuration:1.0f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [scheduleBoundaryView setAlpha:1.0f];
	[slider setAlpha:1.0f];
	[sliderLabel setAlpha:1.0f];
	[weekendSwitch setAlpha:1.0f];
	[weekendLabel setAlpha:1.0f];
	
	[UIView commitAnimations];
}

- (void)enterScheduleBoundaryMode
{
    [self setToolBarItemsUnderScheduleBoundary];
    
    [scheduleBoundaryView removeGestureRecognizer:(UIGestureRecognizer *)scheduleBoundaryView.gestureRecognizers.lastObject];
    
    [UIView beginAnimations:@"enterScheduleBoundaryMode" context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];

    [scheduleForm setAlpha:0.0f];
    [slider setAlpha:0.0f];
    [sliderLabel setAlpha:0.0f];
    [weekendSwitch setAlpha:0.0f];
    [weekendLabel setAlpha:0.0f];
    [self locateScheduleBoundaryViewUnderTimeDependentMode:scheduleBoundaryView];
    [scheduleBoundaryView setContentSize:CGSizeMake(scheduleBoundaryView.frame.size.width, 1000.0f)];
    
    [UIView commitAnimations];
    
    [scheduleBoundaryView setTimeDependenceMode:TimeDependenceModeDependent animated:YES];

}

- (void)cancelScheduleBoundaryMode
{
    [self setToolBarItemsToEdit];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scheduleBoundaryEnterTimeDependentMode:)];
    [scheduleBoundaryView addGestureRecognizer:recognizer];
    [recognizer release];
    
    [self createScheduleForm];
    [scheduleForm setIsTopBoundaryViewsHidden:YES];
    [scheduleForm setTouchingConditon:DFFormViewTouchingConditonNone];
    [scheduleForm setIsContentHidden:YES];
    
    [self createConfigurationAccessory];

    [UIView beginAnimations:@"cancelScheduleBoundaryMode" context:UIGraphicsGetCurrentContext()];
	//[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [scheduleForm setAlpha:1.0f];
    [slider setAlpha:1.0f];
    [sliderLabel setAlpha:1.0f];
    [weekendSwitch setAlpha:1.0f];
    [weekendLabel setAlpha:1.0f];
    [self locateScheduleBoundaryView:scheduleBoundaryView];
    [scheduleBoundaryView setContentSize:CGSizeMake(scheduleBoundaryView.frame.size.width, scheduleBoundaryView.frame.size.height)];
    
    [UIView commitAnimations];
    
    [scheduleBoundaryView setTimeDependenceMode:TimeDependenceModeIndependent animated:YES];
}

#pragma mark - Focus
- (NSInteger)defaultFocusedWeekday
{
    NSDate* rightNow = [[NSDate alloc] init];
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:rightNow];
    NSInteger weekday = comps.weekday;
    
    [calendar release];
    [rightNow release];
    
    return weekday;    
}

#pragma mark - SuperController
- (void)toPushDayControllerWithSeqInWeek:(NSUInteger)aWeekday
{
    NSInteger focusedWeekday = [self defaultFocusedWeekday];
    [(ScheduleNvCon*)self.navigationController pushDayControllerWithWeekday:aWeekday focused:(focusedWeekday == aWeekday) animated:YES];	
}

#pragma mark - UIView Animation Protocol
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if ([animationID isEqualToString:@"cancelEditingMode"]) {
		[self destroyConfigurationAccessory];
        [self destroySubview:&scheduleBoundaryView];
	}else if ([animationID isEqualToString:@"enterScheduleBoundaryMode"]) {
        [self destroyConfigurationAccessory];
        [self destroySubview:&scheduleForm];
    }
}

#pragma mark - Subviews Lifecycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.navigationController setToolbarHidden:NO];
    [self setToolBarItems];
    
    [self locateEmptyTip:_emptyTip];
}

- (void)viewDidAppear:(BOOL)animated{
    [self locateScheduleForm:scheduleForm];
    
    [scheduleForm reloadContent];
    
}

- (void)loadView
{
	[super loadView];
    
    if (!topLabel) {
        topLabel = [[UILabel alloc] init];
        [self.view addSubview:topLabel];
    }
    [self configureTopLabel];
    
    if (scheduleForm) {
        [scheduleForm removeFromSuperview];
        [scheduleForm release];
    }
    scheduleForm = [[DFFormView alloc] init];
    [self.view addSubview:scheduleForm];
    [self configureScheduleForm:scheduleForm];
    [scheduleForm createForm];
    
    [self checkEmptyTip];
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [super viewDidUnload];
	[self saveColAndRowCount];
	[self cancelEditingMode];
    
    [self destroySubview:&topLabel];
    [self destroySubview:&scheduleForm];
    [self destroySubview:&scheduleBoundaryView];
    [self destroySubview:&sliderLabel];
    [self destroySubview:&slider];
    [self destroySubview:&weekendLabel];
    [self destroySubview:&weekendSwitch];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations.
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

#pragma mark - Lifecycle
- (id)init{
    if (self = [super init]) {
        editingMode = EditingModeOff;
        dataCenter = [CSDataCenter sharedDataCenter];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)dealloc {
    dataCenter = nil;
    
    /*Views*/
    [self destroySubview:&topLabel];
    [self destroySubview:&scheduleForm];
    [self destroySubview:&scheduleBoundaryView];
    [self destroySubview:&sliderLabel];
    [self destroySubview:&slider];
    [self destroySubview:&weekendLabel];
    [self destroySubview:&weekendSwitch];

    [self destroyMember:&_ImageB0];
    [self destroyMember:&_ImageB1];
    [self destroyMember:&_LabelB0];
    [self destroyMember:&_LabelB1];

    [super dealloc];
}

@end
