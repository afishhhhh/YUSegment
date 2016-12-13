//
//  UUIndicatorView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUIndicatorView.h"

@interface YUIndicatorView ()

@property (nonatomic, assign) YUIndicatorViewStyle style;
@property (nonatomic, strong) UIView               *line;

@end

@implementation YUIndicatorView

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _style = YUIndicatorViewStyleSlider;
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.line];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    _line.frame = (CGRect){0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4};
    _maskView.frame = self.frame;
}

#pragma mark -

- (void)updateIndicatorStyle:(YUIndicatorViewStyle)style {
    if (_style == style) {
        return;
    }
    _style = style;
    if (style == YUIndicatorViewStyleSlider) {
        [self addSubview:self.line];
    } else {
        [_line removeFromSuperview];
        self.line = nil;
    }
    [self setNeedsLayout];
}

- (void)updateIndicatorWithColor:(UIColor *)color {
    switch (_style) {
        case YUIndicatorViewStyleSlider:
            self.line.backgroundColor = color;
            break;
        case YUIndicatorViewStyleRounded: {
            if ([color isEqual:[UIColor clearColor]]) {
                self.backgroundColor = [UIColor whiteColor];
            } else {
                self.backgroundColor = color;
            }
            break;
        }
    }
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    _maskView.frame = self.frame;
}

#pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius == _cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
    if (_style == YUIndicatorViewStyleSlider) {
        self.line.layer.cornerRadius = 2.0;
    } else {
        self.layer.cornerRadius = cornerRadius;
    }
}

#pragma mark - Getters

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [UIView new];
    _line.backgroundColor = [UIColor colorWithRed:238.0 / 255 green:143.0 / 255 blue:102.0 / 255 alpha:1.0];
    return _line;
}

- (CGFloat)getCenterX {
    return self.center.x;
}

@end
