//
//  UUIndicatorView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UUIndicatorViewStyle) {
    UUIndicatorViewStyleRounded,
    UUIndicatorViewStyleSlider,
};

@interface UUIndicatorView : UIView

@property (nonatomic, strong) UIView *maskView;

- (instancetype)initWithStyle:(UUIndicatorViewStyle)type;
- (void)setIndicatorWithCornerRadius:(CGFloat)cornerRadius;
- (void)setIndicatorWithColor:(UIColor *)color;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)getCenterX;

@end
