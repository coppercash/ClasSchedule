#import <Foundation/Foundation.h>

typedef enum{
    ButtonsMaskMoveButtons,
    ButtonsMaskAlterButtons,
    ButtonsMaskNone
}ButtonsMask;

@class DFScheduleBoundaryManagerCell,DFScheduleBoundaryManager;
@interface DFButtonsManager : NSObject{
    DFScheduleBoundaryManager* superManager;
    DFScheduleBoundaryManagerCell* linkingCell;
    ButtonsMask buttonsMask;
    
    UIButton* upButton;
    UIButton* downButton;
    UIButton* prolongButton;
    UIButton* curtailButton;
}
@property(nonatomic,assign)DFScheduleBoundaryManager* superManager;
@property(nonatomic,assign)DFScheduleBoundaryManagerCell* linkingCell;
@property(nonatomic,assign)ButtonsMask buttonsMask;
- (void)showMoveButton;
- (void)showAlterButton;
- (void)followLinkingCells;
- (void)hideMoveButton;
- (void)hideAlterButton;
- (void)recreateButtons;
- (void)relinkToCell:(DFScheduleBoundaryManagerCell*)aCell;
- (void)releaseMoveButton;
- (void)releaseAlterButton;
@end
