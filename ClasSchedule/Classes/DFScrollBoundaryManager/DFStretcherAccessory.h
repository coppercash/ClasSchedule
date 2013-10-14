//
//  DFStrecherAccessory.h
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFScheduleBoundaryManagerCell;
@interface DFStretcherAccessory : UIControl{
    DFScheduleBoundaryManagerCell* superCellView;
    CGFloat touchYInCellWhenPreviousTouch;
}
@property(nonatomic,assign)DFScheduleBoundaryManagerCell* superCellView;
@property(nonatomic,assign)CGFloat touchYInCellWhenPreviousTouch;
@end
