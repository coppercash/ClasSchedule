//
//  EnterHelperCell.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnterHelper.h"

@interface EnterHelperTableCell : UITableViewCell{
    EnterHelper* enterHelper;
}

@property(nonatomic,assign)EnterHelper* enterHelper;

@end
