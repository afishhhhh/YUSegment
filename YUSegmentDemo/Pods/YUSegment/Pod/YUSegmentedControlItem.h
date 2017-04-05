//
//  YUSegment
//  Created by afishhhhh on 2017/3/25.
//  Copyright © 2017年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YUSegmentedControlItem : UIView

@property (nonatomic, weak) UIView *view;

- (instancetype)initWithView:(UIView *)view;
- (void)showVerticalDivider;
- (void)hideVerticalDivider;
- (void)showBadge;
- (void)hideBadge;

@end

NS_ASSUME_NONNULL_END
