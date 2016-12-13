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

@interface YUIndicatorView : UIView

@property (nonatomic, strong, readonly) UIView *maskView;
@property (nonatomic, assign)           CGFloat cornerRadius;

- (void)updateIndicatorStyle:(YUIndicatorViewStyle)style;
- (void)updateIndicatorWithColor:(UIColor *)color;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)getCenterX;

@end
