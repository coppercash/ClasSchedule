//
//  EnterHelperII.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-2-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshView.h"
#import "DFFloatingView.h"

@protocol EnterHelperDelegate <NSObject>
@optional
- (CGRect)stageFrame;
- (void)enterHelperWillBeDismissed;
- (void)enterHelperDidBeDismissed;
- (void)initCoreData:(NSManagedObjectContext**)managedObjectContext and:(NSManagedObjectModel**)managedObjectModel;
@end

typedef enum {
    EnterHelperWillShow,
    EnterHelperShowing,
    EnterHelperReading,
    EnterHelperFloating
}EnterHelperState;

#define GARBAGE_BIN_SIZE 50.0f
#define GARBAGE_VERTICAL_LOCATION 350.0f

@class RefreshView,EnterHelperTableCell,EHFloatingView;
@interface EnterHelper:UIView <UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,RefreshViewDelegate,DFFloatingViewDelegate> 
{
    EnterHelperState state;
	
    id<EnterHelperDelegate> delegate;
    
    RefreshView* refreshView;
    UITableView* stringsTableView;
    UIImageView* garbageBin;
    
    EHFloatingView* floatingView;
    NSArray* accessedTextField;
    
    UIControl* dismissingView;
    
    NSArray* fileList;
    NSMutableArray* stringsList;
    //NSArray* cellsList;
    
    /*Core Data*/
    NSFetchedResultsController* fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
    //NSManagedObjectModel *managedObjectModel;
}
@property(nonatomic)EnterHelperState state;
@property(nonatomic,assign)id<EnterHelperDelegate> delegate;
@property(nonatomic,copy)NSArray* accessedTextFields;

@property(nonatomic,retain)UITableView* stringsTableView;
@property(nonatomic,retain)RefreshView* refreshView;
@property(nonatomic,retain)UIImageView* garbageBin;
@property(nonatomic,retain)EHFloatingView* floatingView;

@property(nonatomic,retain)UIControl* dismissingView;;
@property(nonatomic,retain)NSArray* fileList;
@property(nonatomic,retain)NSMutableArray* stringsList;
//@property(nonatomic,retain)NSArray* cellsList;

@property(nonatomic,retain)NSFetchedResultsController* fetchedResultsController;
@property(nonatomic,assign)NSManagedObjectContext *managedObjectContext;

- (void)configureCell:(UITableViewCell*)aCell atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Frame
- (CGRect)frameOfWillShow;
- (CGRect)frameOfShowing;
- (CGRect)frameOfReading;
- (CGRect)selfFrame;
- (CGRect)stringsTableFrame;
#pragma mark - Float View Touches Track
- (void)touchBegan:(UITouch*)aTouch;
- (void)touchEnded:(UITouch*)aTouch;
- (void)touchMoved:(UITouch*)aTouch;
- (void)touchCancelled:(UITouch*)aTouch;
#pragma mark - Core Data & File
- (void)cleanCoreData;
- (void)fillCoreDataWithStringsList:(NSMutableArray*)aMutableArray;
- (void)loadFileListInDocuments;
- (BOOL)isSupportedFileType:(NSString*)aFilePath;
#pragma mark - Presenting & Dismissing
- (void)showInView:(UIView*)aView;
- (void)dismissFromSuperview;
- (void)enterReadingMode;
- (void)cancelReadingMode;
- (void)loadFileListInDocuments;
- (void)enterFloatingState;
- (void)cancelFloatingState;
#pragma mark - Load Subviews
- (void)loadSubviews;
- (void)configureFloatingView:(EHFloatingView*)aFloatingView;
- (void)configureStringTableView:(UITableView*)aStringTableView;
- (void)configureDismissingView:(UIControl*)aDismissingView;
- (void)configureGarbageBin:(UIImageView*)aGarbageBin;
#pragma mark - Animation Management
- (void)animationOfTransform:(CGRect)aNewFrame named:(NSString*)anAnimationName;
#pragma mark - Memory Managment
- (id)initWithManagedObjectContext:(NSManagedObjectContext*)anManagedObjectContext;
@end
