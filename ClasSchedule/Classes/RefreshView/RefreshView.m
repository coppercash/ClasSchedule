//
//  RefreshView.m
//  Testself
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

#import "RefreshView.h"

@implementation RefreshView
@synthesize isLoading = _isLoading;
@synthesize owner = _owner;
@synthesize delegate = _delegate;
- (id)initWithOwner:(UIScrollView *)owner delegate:(id<RefreshViewDelegate>)delegate
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        
        self.frame = CGRectMake(0, - owner.frame.size.height, owner.bounds.size.width, owner.frame.size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshStatusLabel.frame = CGRectMake(0.0f, owner.frame.size.height - 48.0f, self.frame.size.width, 20.0f);
		_refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		_refreshStatusLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		_refreshStatusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshStatusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshStatusLabel.backgroundColor = [UIColor clearColor];
		_refreshStatusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_refreshStatusLabel];

        _refreshLastUpdatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _refreshLastUpdatedTimeLabel.frame = CGRectMake(0.0f, owner.frame.size.height - 30.0f, self.frame.size.width, 20.0f);
		_refreshLastUpdatedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		_refreshLastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0f];
		_refreshLastUpdatedTimeLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
		_refreshLastUpdatedTimeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		_refreshLastUpdatedTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		_refreshLastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
		_refreshLastUpdatedTimeLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:_refreshLastUpdatedTimeLabel];
        
		_refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _refreshIndicator.frame = CGRectMake(25.0f, owner.frame.size.height - 45.0f, 20.0f, 20.0f);
		[self addSubview:_refreshIndicator];
        
        _refreshArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _refreshArrowImageView.frame = CGRectMake(25.0f, owner.frame.size.height - 55.0f, 17.0, 42.0);
        _refreshArrowImageView.image = [UIImage imageNamed:@"blueArrow.png"];
		[self addSubview:_refreshArrowImageView];

        
        [owner insertSubview:self atIndex:0];

        _owner = owner;
        _delegate = delegate;
        [_refreshIndicator stopAnimating];
        
    
    }
    return self;
}

- (void)dealloc{
    [_refreshArrowImageView removeFromSuperview];
    [_refreshArrowImageView release];
    _refreshArrowImageView = nil;
    
    [_refreshIndicator removeFromSuperview];
    [_refreshIndicator release];
    _refreshIndicator = nil;
    
    [_refreshStatusLabel removeFromSuperview];
    [_refreshStatusLabel release];
    _refreshStatusLabel = nil;

    [_refreshLastUpdatedTimeLabel removeFromSuperview];
    [_refreshLastUpdatedTimeLabel release];
    _refreshLastUpdatedTimeLabel = nil;
    
    _owner = nil;
    
    _delegate = nil;
    
    [super dealloc];
}

// refreshView 结束加载动画
- (void)stopLoading {
    // control
    _isLoading = NO;
    
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
//    _owner.contentInset = UIEdgeInsetsZero;
    _owner.contentOffset = CGPointZero;
    _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
    // UI 更新日期计算
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
    [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
    NSString *timeStr = [outFormat stringFromDate:nowDate];
    // UI 赋值
    _refreshLastUpdatedTimeLabel.text = [NSString stringWithFormat:@"%@%@", REFRESH_UPDATE_TIME_PREFIX, timeStr];
    _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
    _refreshArrowImageView.hidden = NO;
    [_refreshIndicator stopAnimating];
}

// refreshView 开始加载动画
- (void)startLoading {
    // control
    _isLoading = YES;
    // Animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _owner.contentOffset = CGPointMake(0, -REFRESH_TRIGGER_HEIGHT);
    _owner.contentInset = UIEdgeInsetsMake(REFRESH_TRIGGER_HEIGHT, 0, 0, 0);
    _refreshStatusLabel.text = REFRESH_LOADING_STATUS;
    _refreshArrowImageView.hidden = YES;
    [_refreshIndicator startAnimating];
    [UIView commitAnimations];
}
// refreshView 刚开始拖动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isLoading) return;
    _isDragging = YES;
}
// refreshView 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            scrollView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_TRIGGER_HEIGHT)
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (_isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < - REFRESH_TRIGGER_HEIGHT) {
            // User is scrolling above the header
            _refreshStatusLabel.text = REFRESH_RELEASED_STATUS;
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);
        } else { // User is scrolling somewhere within the header
            _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
        [UIView commitAnimations];
    }
    else if(!_isDragging && !_isLoading){ 
            scrollView.contentInset = UIEdgeInsetsZero;
    }
}
// refreshView 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isLoading) return;
    _isDragging = NO;
    if (scrollView.contentOffset.y <= - REFRESH_TRIGGER_HEIGHT) {
        if ([_delegate respondsToSelector:@selector(refreshViewDidCallBack)]) {
            [_delegate refreshViewDidCallBack];
        }
    }
}
@end
