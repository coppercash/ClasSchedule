//
//  EnterHelperCell.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EnterHelperTableCell.h"

#import "AppDelegate.h"
#import "CSDataCenter.h"

@implementation EnterHelperTableCell
@synthesize enterHelper;

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (enterHelper.state) {
        case EnterHelperShowing:{
            UITouch* touch = [touches anyObject];
            if (touch.tapCount == 2) {
                [enterHelper touchBegan:touch];
                [(UITableView*)self.superview setScrollEnabled:NO];
            
            }else if (touch.tapCount == 1) {
                [super touchesBegan:touches withEvent:event];
            }
            break;
        }
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (enterHelper.state) {
        case EnterHelperFloating:{
            [enterHelper touchMoved:[touches anyObject]];
            break;
        }
        default:
            [super touchesMoved:touches withEvent:event];
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (enterHelper.state) {
        case EnterHelperFloating:{
            [enterHelper touchEnded:[touches anyObject]];
            [(UITableView*)self.superview setScrollEnabled:YES];
            break;
        }
        default:
            [super touchesEnded:touches withEvent:event];
            break;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (enterHelper.state) {
        case EnterHelperFloating:{
            [enterHelper touchCancelled:[touches anyObject]];
            [(UITableView*)self.superview setScrollEnabled:YES];
            break;
        }
        default:
            [super touchesCancelled:touches withEvent:event];
            break;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
