//
//  UUIndicatorView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUIndicatorViewStyle) {
    YUIndicatorViewStyleSlider,
    YUIndicatorViewStyleRounded,
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
