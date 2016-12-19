//
//  YUIndicatorView.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUIndicatorViewStyle) {
    YUIndicatorViewStyleLine,
    YUIndicatorViewStyleBox,
};

NS_ASSUME_NONNULL_BEGIN

@interface YUIndicatorView : UIView

@property (nonatomic, strong, readonly) UIView  *maskView;
@property (nonatomic, assign)           CGFloat cornerRadius;
@property (nonatomic, strong)           UIColor *indicatorColor;

- (instancetype)initWithStyle:(YUIndicatorViewStyle)style;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)getCenterX;

@end

NS_ASSUME_NONNULL_END
