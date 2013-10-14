//
//  RefreshView.h
//  TestRefreshView
//
//  Created by Jason Liu on 12-1-10.
//  Copyright 2012年 Yulong. All rights reserved.
//

// Refresh view controller show label 
#define REFRESH_LOADING_STATUS @"加载中..."
#define REFRESH_PULL_DOWN_STATUS NSLocalizedString(@"EnterAssist_Pull", nil)
#define REFRESH_RELEASED_STATUS NSLocalizedString(@"EnterAssist_Free", nil)
#define REFRESH_UPDATE_TIME_PREFIX @"最后更新: "
//#define REFRESH_HEADER_HEIGHT 60
#define REFRESH_TRIGGER_HEIGHT 80

#import <UIKit/UIKit.h>
@protocol RefreshViewDelegate;
@interface RefreshView : UIView {
    // UI
    UIImageView *_refreshArrowImageView;
    UIActivityIndicatorView *_refreshIndicator;
    UILabel *_refreshStatusLabel;
    UILabel *_refreshLastUpdatedTimeLabel;
    
    // 安装到哪个UIScrollView中
    UIScrollView *_owner;

    // control
    BOOL _isLoading;
    BOOL _isDragging;
    
    // 触发有效事件后的_delegate
    __unsafe_unretained id<RefreshViewDelegate>  _delegate;
}

@property (nonatomic,assign,readonly) BOOL isLoading;
@property (nonatomic,strong,readonly) UIScrollView *owner;
@property (nonatomic,assign,readwrite)  id<RefreshViewDelegate> delegate;

// 初始化并安装refreshView
- (id)initWithOwner:(UIScrollView *)owner delegate:(id<RefreshViewDelegate>)delegate;

// 开始加载和结束加载动画
- (void)startLoading;
- (void)stopLoading;

// 拖动过程中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
@end
@protocol RefreshViewDelegate <NSObject>
// 只有向下拉时，有效的触发事件对外才是真正有用的
- (void)refreshViewDidCallBack;
@end
