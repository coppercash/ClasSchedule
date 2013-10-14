#import "CourseCon.h"

#import "Header.h"

@implementation CourseCon
@synthesize course;
#pragma mark - Frames
CGFloat iconLeftMargin = 30.0f;
CGFloat textFieldRightMargin = 30.0f;

- (CGRect)locateIconView:(UIView*)aView
{
    CGFloat width = 60.0f;
    CGFloat height = width;
    CGFloat x = iconLeftMargin;
    CGFloat y = 20.0f;

    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateTeacherIcon:(UIView*)aView
{
    CGFloat distanceFromIconView = 10.0f;
    CGFloat width = 40.0f;
    CGFloat height = width;
    
    CGRect iconViewFrame = [self locateIconView:nil];
    CGFloat x = iconViewFrame.origin.x;
    CGFloat y = iconViewFrame.origin.y + iconViewFrame.size.height + distanceFromIconView;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateRoomIcon:(UIView*)aView
{
    CGFloat distanceFromTeacherIcon = 10.0f;
    CGFloat width = 40.0f;
    CGFloat height = width;
    
    CGRect iconViewFrame = [self locateIconView:nil];
    CGRect teacherIconFrame = [self locateTeacherIcon:nil];
    CGFloat x = iconViewFrame.origin.x;
    CGFloat y = teacherIconFrame.origin.y + teacherIconFrame.size.height + distanceFromTeacherIcon;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateNotesPad
{
    UIScrollView* theNotesPad = notesPad;
    
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = 200.0f;
    CGFloat x = 0.0f;
    CGFloat y = 170.0f;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [theNotesPad setFrame:frame];
    
    return frame;
}

- (CGRect)notePaperExpandedFrame
{
    //CGFloat width = self.view.bounds.size.width;
    //CGFloat height = 150.0f;
    //CGFloat x = 0.0f;
    //CGFloat y = 200.0f;
    
    CGRect frame = CGRectInset(self.view.frame, 0.0f, 0.0f);
    return frame;
}

#pragma mark - Subviews
- (void)configureIconView
{
    DFCourseIconView* theIconView = iconView;
    
    //[self locateIconView:theIconView];
    
    CourseExtension* courseExtension = course.courseExtension;
    CGFloat red = [courseExtension.red floatValue];
    CGFloat green = [courseExtension.green floatValue];
    CGFloat blue = [courseExtension.blue floatValue];
    UIColor* theColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    
    //UIColor* theColor = [CSDataCenter getColorFromCourseExtensionInfo:course.courseExtension];
    [theIconView setTintColor:theColor];
    [theColor release];
    
    [theIconView.layer setShadowPath:[UIBezierPath bezierPathWithRect:theIconView.bounds].CGPath];
    [theIconView.layer setShadowOffset:CGSizeMake(0.0f, 10.0f)];
    [theIconView.layer setShadowRadius:10.0f];
    [theIconView.layer setShadowOpacity:1.0f];
    [theIconView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callCourseIconController)];
    [gesture setNumberOfTapsRequired:1];
    [gesture setNumberOfTouchesRequired:1];
    [theIconView addGestureRecognizer:gesture];
    [gesture release];
}

- (void)configureCourseName
{
    UITextField* theCourseName = courseName;
    
    [theCourseName setText:course.name];
    [theCourseName setPlaceholder:NSLocalizedString(@"CourseName", @"Course Name")];
    [theCourseName setBorderStyle:UITextBorderStyleNone];
    
    [theCourseName setHeight:iconView.bounds.size.height];
}

- (void)configureTeacherName
{
    UITextField* theTeacherName = teacherName;
    
    [theTeacherName setText:course.teacher];
    [theTeacherName setPlaceholder:NSLocalizedString(@"TeacherName", @"Your Teacher")];
    [theTeacherName setBorderStyle:UITextBorderStyleNone];
}

- (void)configureRoomLabel
{
    UITextField* theRoomLabel = roomLabel;
    
    [theRoomLabel setText:course.room];
    [theRoomLabel setPlaceholder:NSLocalizedString(@"RoomName", @"Place to Take Lesson")];
    [theRoomLabel setBorderStyle:UITextBorderStyleNone];
}

- (void)configureNotesPad
{
    NotesPad* theNotesPad = notesPad;
    
    [self locateNotesPad];
    
    [theNotesPad setCourse:course];
    [theNotesPad setSecondDirectionCellCount:2];
    [theNotesPad setFirstDirectionCellLength:90.0f];
    [theNotesPad setFirstDirectionMargin:10.0f];
    [theNotesPad setSecondDirectionMargin:10.0f];
    [theNotesPad setContentSize:CGSizeMake(0.0f, 200.0f)];
    [theNotesPad loadSubviews];
    [theNotesPad setEnteringPaperStageView:self.view];
    [theNotesPad setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [theNotesPad setDelegate:self];
}

- (void)loadSubviews
{
    UIView* theView = self.view;
    
    [self configureIconView];
    
    [self configureCourseName];
    
    [self configureTeacherName];
    
    [self configureRoomLabel];
    
    /*Notes Pad*/
    if (course) {
        if (!notesPad) {
            notesPad = [[NotesPad alloc] initWithCourse:course];
            [theView addSubview:notesPad];
        }
        [self configureNotesPad];
    
    }else{
        [self enterAddingMode];
    }
}

- (void)unLoadSubviews
{
    [iconView removeFromSuperview];
    [iconView release];
    iconView = nil;
    
    [courseName removeFromSuperview];
    [courseName release];
    courseName = nil;
    
    [teacherIcon removeFromSuperview];
    [teacherIcon release];
    teacherIcon = nil;
    
    [teacherName removeFromSuperview];
    [teacherName release];
    teacherName = nil;
    
    [roomIcon removeFromSuperview];
    [roomIcon release];
    roomIcon = nil;
    
    [roomLabel removeFromSuperview];
    [roomLabel release];
    roomLabel = nil;
    
    [notesPad removeFromSuperview];
    [notesPad release];
    notesPad = nil;
}

#pragma mark - DFInstructor Delegate
- (void)instructorLoadingSubviews:(DFInstructor *)anInstructor{
    NSArray* xibViews = nil;
    switch (editingMode) {
        case EditingModeOff:
            xibViews = [[NSBundle mainBundle] loadNibNamed:@"CourseConInsNormal" owner:self options:nil];
            break;
        case EditingModeOn:
            xibViews = [[NSBundle mainBundle] loadNibNamed:@"CourseConInsEditing" owner:self options:nil];
            break;
        default:
            break;
    }
    UIView* xibView = [xibViews objectAtIndex:0];
    [anInstructor addSubview:xibView];
    
    if (!_enterHelperOn) {
        [_imageView1 setAlpha:0.0f];
        [_imageView2 setAlpha:0.0f];
        [_label1 setAlpha:0.0f];
        [_label2 setAlpha:0.0f];
    }
    
}

#pragma mark - Push Pop Controller;
- (void)callCourseIconController
{
    if (editingMode == EditingModeOn){
        DLog(@"callCourseIconController");
        CoursesNvCon* theSuperController = (CoursesNvCon*)self.navigationController;
        [theSuperController pushCourseIconConWithCourse:course animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    BOOL should = (editingMode == EditingModeOn);
    return should;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    /*
    if (!course) {
        [self showAddNewCourseButton:NO animated:YES];
    }*/
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == courseName) {
        [self checkAddSubjectButtonByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    /*
    BOOL subjectExists = ( courseName.text && [courseName.text length] );
    if (!course && subjectExists) {
        [self showAddNewCourseButton:YES animated:YES];
    }*/
    return YES;
}

#pragma mark - EnterHelperDelegate & Event
- (void)enterHelperWillBeDismissed{
    [self tranformSubviewsForEnterHelperDismissing];
}

- (void)enterHelperDidBeDismissed{
    UINavigationController* navCon = self.navigationController;
    [navCon setNavigationBarHidden:NO animated:YES];

    [self setToolBarItemsEnterEditingMode];
    
    _enterHelperOn = NO;
}

- (CGRect)stageFrame
{
    return CGRectZero;
}

- (void)presentEnterHelper
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //[self setToolBarItemsUnderEnterHelperMode];
    
    [self tranformSubviewsForEnterHelper];
    
    if (_enterHelper) {
        [_enterHelper release];
    }
    _enterHelper = [[EnterHelper alloc] initWithManagedObjectContext:dataCenter.managedObjectContext];
    [_enterHelper setDelegate:self];
    NSArray* array = [[NSArray alloc] initWithObjects:courseName,teacherName,roomLabel,nil];
    [_enterHelper setAccessedTextFields:array];
    [array release];
    [_enterHelper showInView:self.view];
    
    _enterHelperOn = YES;
}

- (void)tranformSubviewsForEnterHelper
{
    CGFloat rightMargin = 150.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"tranformSubviewsForEnterHelper" context:context];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGFloat width = 0.0f;
    
    width = self.view.bounds.size.width - courseName.frame.origin.x - rightMargin;
    [courseName setFrame:CGRectMake(courseName.frame.origin.x, courseName.frame.origin.y, width, courseName.frame.size.height)];
    
    width = self.view.bounds.size.width - teacherName.frame.origin.x - rightMargin;
    [teacherName setFrame:CGRectMake(teacherName.frame.origin.x, teacherName.frame.origin.y, width, teacherName.frame.size.height)];
    
    width = self.view.bounds.size.width - roomLabel.frame.origin.x - rightMargin;
    [roomLabel setFrame:CGRectMake(roomLabel.frame.origin.x, roomLabel.frame.origin.y, width, roomLabel.frame.size.height)];
    
	[UIView commitAnimations];
}

- (void)tranformSubviewsForEnterHelperDismissing
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"tranformSubviewsForEnterHelper" context:context];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGFloat rightMargin = 20.0f;
    CGFloat width = 0.0f;
    
    width = self.view.bounds.size.width - courseName.frame.origin.x - rightMargin;
    [courseName setFrame:CGRectMake(courseName.frame.origin.x, courseName.frame.origin.y, width, courseName.frame.size.height)];
    
    width = self.view.bounds.size.width - teacherName.frame.origin.x - rightMargin;
    [teacherName setFrame:CGRectMake(teacherName.frame.origin.x, teacherName.frame.origin.y, width, teacherName.frame.size.height)];
    
    width = self.view.bounds.size.width - roomLabel.frame.origin.x - rightMargin;
    [roomLabel setFrame:CGRectMake(roomLabel.frame.origin.x, roomLabel.frame.origin.y, width, roomLabel.frame.size.height)];
    
	[UIView commitAnimations];
}
#pragma mark - NotePaper Event
- (void)enteringNotePaperWillExpand:(NotePaper *)aNotePaper{
    [self setToolBarForNotePaper];
}

- (void)enteringNotePaperDidShrink:(NotePaper *)aNotePaper{
    [self setToolBarItemsNormalMode];
}

- (CGRect)enteringNotePaperExpandedFrame{
    return [self notePaperExpandedFrame];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    //UIBarButtonItem* keyboardResignButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(contentViewResignFirstResponder)];
    
    UIBarButtonItem* keyboardResignButton = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemEnterDismissKeyboard target:self action:@selector(contentViewResignFirstResponder)];
    
    [self.navigationItem setRightBarButtonItem:keyboardResignButton animated:YES];
    [keyboardResignButton release];
}

- (void)contentViewResignFirstResponder
{
    [notesPad.enteringNotePaper.contentView resignFirstResponder];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up:(BOOL)up {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    UITextView* textView = notesPad.enteringNotePaper.contentView;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = textView.frame;
    //CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    CGRect keyboardFrame = keyboardEndFrame;
    keyboardFrame.size.height -= self.navigationController.toolbar.frame.size.height;
    keyboardFrame.size.height -= self.navigationController.navigationBar.frame.size.height;

    newFrame.size.height -= keyboardFrame.size.height * (up ?  1 : -1);
    textView.frame = newFrame;
    
    [UIView commitAnimations];   
}

- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:YES]; 
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self moveTextViewForKeyboard:aNotification up:NO]; 
}

#pragma mark - Bar Functions
- (void)toolBarEnterHelperSwitch
{
    if (_enterHelperOn) {
        [_enterHelper dismissFromSuperview];
    }else{
        [self presentEnterHelper];
    }
}

- (void)toolBarSaveNotePaper
{
    [notesPad shrinkEnteringNotePaperAndSave:YES];
}

- (void)toolBarCancelNotePaper
{
    [notesPad shrinkEnteringNotePaperAndSave:NO];
}

- (void)toolBarDeleteNotePaper
{
    [notesPad removeAlertingNotePaper];
    [notesPad shrinkEnteringNotePaperAndSave:NO];
}

- (void)toolBarCallInstructor:(UIBarButtonItem*)sender event:(UIEvent*)event
{
    UITouch* touch = [event.allTouches anyObject];
    
    DFControllerManager* manager = [DFControllerManager sharedControllerManager];
    [manager.instructor setDelegate:self];
    [manager.instructor presentByUIBarButtonItem:sender touch:touch inView:manager.superWindow animated:YES];
}

- (void)toolBarEnterEditingMode
{
    [self enterEditingMode];
}

- (void)navigatinBarCancelEditingModeWithSaving
{
    [course setName:courseName.text];
    [course setTeacher:teacherName.text];
    [course setRoom:roomLabel.text];
    
    [self cancelEditingMode];
}

- (void)navigatinBarCancelEditongModeWithoutSaving
{
    [courseName setText:course.name];
    [teacherName setText:course.teacher];
    [roomLabel setText:course.room];
    
    [self cancelEditingMode];
}

- (void)navigationBarAddNewCourse
{
    NSString* subjectString = courseName.text;
    NSString* instructorString = teacherName.text;
    NSString* locationString = roomLabel.text;
    Course* newCourse = [dataCenter insertCourseWithName:subjectString teacher:instructorString room:locationString];
    
    [self setCourse:newCourse];
    
    [self cancelAddingMode];
}

#pragma mark - Tool Bar
- (void)setToolBarItemsNormalMode
{
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem* edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(toolBarEnterEditingMode)];
	
    UIBarButtonItem* instruction = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemInstructor target:self action:@selector(toolBarCallInstructor:event:)];
    
	NSArray* items = [[NSArray alloc] initWithObjects:edit,flexibleSpace,instruction,nil];
	[flexibleSpace release];
	[edit release];
    //[delete release];
	[instruction release];
    
    [self setToolbarItems:items animated:YES];
    [items release];
}

- (void)setToolBarItemsEnterEditingMode
{
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
    UIBarButtonItem* enterAssist = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemEnterAssist target:self action:@selector(toolBarEnterHelperSwitch)];

    UIBarButtonItem* instruction = [[UIBarButtonItem alloc] initWithBarButtonCustomItem:DFBarButtonCustomItemInstructor target:self action:@selector(toolBarCallInstructor:event:)];
	
	NSArray* items = [[NSArray alloc] initWithObjects:enterAssist,flexibleSpace,instruction,nil];    
	[flexibleSpace release];
    [enterAssist release];
    [instruction release];
    
    [self setToolbarItems:items animated:YES];
    [items release];
}

- (void)setToolBarForNotePaper
{
	UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(toolBarSaveNotePaper)];
	
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(toolBarCancelNotePaper)];
    
    NSArray* items = nil;
    if (![notesPad isAddingNotePaper]) {
        UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(toolBarDeleteNotePaper)];
        items = [[NSArray alloc] initWithObjects:cancel,flexibleSpace,delete,flexibleSpace,save,nil];
        [delete release];
    }else{
        items = [[NSArray alloc] initWithObjects:cancel,flexibleSpace,save,nil];
    }
	[flexibleSpace release];
    [cancel release];
	[save release];
    
    [self setToolbarItems:items animated:YES];
    [items release];
}
#pragma mark - Navigation Bar
- (void)setNavigationBarAddMode
{
    
}

- (void)setNavigationBarEnterEditingMode
{
    [self.navigationItem setHidesBackButton:YES animated:YES];

    UIBarButtonItem* navSaveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(navigatinBarCancelEditingModeWithSaving)];
    [self.navigationItem setRightBarButtonItem:navSaveButton animated:YES];
    [navSaveButton release];
    
    UIBarButtonItem* navCancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(navigatinBarCancelEditongModeWithoutSaving)];
    [self.navigationItem setLeftBarButtonItem:navCancelButton animated:YES];
    [navCancelButton release];
}

- (void)setNavigationBarNormalMode
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    [self.navigationItem setRightBarButtonItem:nil animated:YES];

    [self.navigationItem setHidesBackButton:NO animated:YES];
}

- (void)checkAddSubjectButtonByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement
{
    NSString* newString = [courseName.text stringByReplacingCharactersInRange:range withString:replacement];
    //BOOL canSubjectBeCreated = !course && ([newString length] != 0);
    BOOL isNameLegal = ([newString length] != 0);
    BOOL doesAddButtonExist = self.navigationItem.rightBarButtonItem != nil;
    //UIBarButtonItem* button = self.navigationItem.rightBarButtonItem;
    //UIBarButtonSystemItem sy = self.navigationItem.rightBarButtonItem.style;
    
    if (isNameLegal) {
        if (!doesAddButtonExist) {
            if (course) {
                //Normal Mode
                UIBarButtonItem* navSaveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(navigatinBarCancelEditingModeWithSaving)];
                [self.navigationItem setRightBarButtonItem:navSaveButton animated:YES];
                [navSaveButton release];
            }else{
                //Add Mode
                UIBarButtonItem* navAddButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigationBarAddNewCourse)];
                [self.navigationItem setRightBarButtonItem:navAddButton animated:YES];
                [navAddButton release];
            }
        }
    }else{
        if (doesAddButtonExist) {
            [self.navigationItem setRightBarButtonItem:nil animated:YES];
        }
    }
}

#pragma mark - Mode Transform
- (void)setTextFieldsEditing:(BOOL)editing
{
    if (editing) {
        [courseName setBorderStyle:UITextBorderStyleRoundedRect];
        [courseName setTextColor:[UIColor blackColor]];
        
        [teacherName setBorderStyle:UITextBorderStyleRoundedRect];
        [teacherName setTextColor:[UIColor blackColor]];
        
        [roomLabel setBorderStyle:UITextBorderStyleRoundedRect];
        [roomLabel setTextColor:[UIColor blackColor]];
    }else{
        [courseName setBorderStyle:UITextBorderStyleNone];
        [courseName setTextColor:[UIColor whiteColor]];
        
        [teacherName setBorderStyle:UITextBorderStyleNone];
        [teacherName setTextColor:[UIColor whiteColor]];
        
        [roomLabel setBorderStyle:UITextBorderStyleNone];
        [roomLabel setTextColor:[UIColor whiteColor]];
    }
}

- (void)textFieldsResignFirstResponder
{
    if (courseName.editing) [courseName resignFirstResponder];
    if (teacherName.editing) [teacherName resignFirstResponder];
    if (roomLabel.editing) [roomLabel resignFirstResponder];
}

- (void)enterEditingMode
{
    editingMode = EditingModeOn;

    [self setTextFieldsEditing:YES];
    
    [self setNavigationBarEnterEditingMode];
    [self setToolBarItemsEnterEditingMode];
    
    [UIView animateWithDuration:0.2 animations:^{[notesPad setAlpha:0.2];}];
    [notesPad setUserInteractionEnabled:NO];
}

- (void)cancelEditingMode
{
    editingMode = EditingModeOff;
    
    [self textFieldsResignFirstResponder];
    
    [self setTextFieldsEditing:NO];
    
    [self setNavigationBarNormalMode];
    [self setToolBarItemsNormalMode];
    
    [UIView animateWithDuration:0.3 animations:^{[notesPad setAlpha:1.0];}];
    [notesPad setUserInteractionEnabled:YES];
}

- (void)enterAddingMode
{
    editingMode = EditingModeOn;

    [self setTextFieldsEditing:YES];
    
    [self setToolBarItemsEnterEditingMode];

    [courseName becomeFirstResponder];
}

- (void)cancelAddingMode
{
    editingMode = EditingModeOff;
    
    [self textFieldsResignFirstResponder];
    
    [self setTextFieldsEditing:NO];
    
    [self setNavigationBarNormalMode];
    [self setToolBarItemsNormalMode];
    
    if (!notesPad) {
        notesPad = [[NotesPad alloc] initWithCourse:course];
        [notesPad setAlpha:0.0];
        [self.view addSubview:notesPad];
    }
    [self configureNotesPad];
    [UIView animateWithDuration:0.5 animations:^{[notesPad setAlpha:1.0];}];
}

#pragma mark - Memory Management
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO];
	
    if (course && editingMode == EditingModeOff) {
        [self setToolBarItemsNormalMode];
    }

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self configureIconView];
}

- (void)loadView{
	[super loadView];
    
    [self loadSubviews];
    [self registerForKeyboardNotifications];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self unLoadSubviews];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCourse:(Course*)aCourse
{
    if (self = [super initWithNibName:@"CourseCon" bundle:nil]) {
		course = [aCourse retain];
        dataCenter = [CSDataCenter sharedDataCenter];
        editingMode = EditingModeOff;
	}
	return self;
}

- (void)dealloc {
    
    [self unLoadSubviews];
    
    [self destroyMember:&course];
    
    [_enterHelper release];
    _enterHelper = nil;
    
    [self destroyMember:&_imageView0];
    [self destroyMember:&_label0];
    [self destroyMember:&_imageView1];
    [self destroyMember:&_label1];
    [self destroyMember:&_imageView2];
    [self destroyMember:&_label2];
    
    [super dealloc];
}

@end
