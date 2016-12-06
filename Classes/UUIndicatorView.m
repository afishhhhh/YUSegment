//
//  UUIndicatorView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUIndicatorView.h"

@interface UUIndicatorView ()

@property (nonatomic, assign) UUIndicatorViewStyle style;
@property (nonatomic, strong) UIColor              *color;
@property (nonatomic, strong) UIView               *line;

@end

@implementation UUIndicatorView

#pragma mark - Initialization

- (instancetype)initWithStyle:(UUIndicatorViewStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _style = style;
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    if (_style == UUIndicatorViewStyleSlider) {
        self.line.frame = (CGRect){0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4};
    }
    _maskView.frame = self.frame;
}

#pragma mark -

- (void)setIndicatorWithCornerRadius:(CGFloat)cornerRadius {
    if (_style == UUIndicatorViewStyleSlider) {
        self.line.layer.cornerRadius = 2.0;
    } else {
        self.layer.cornerRadius = cornerRadius;
    }
}

- (void)setIndicatorWithColor:(UIColor *)color {
    switch (_style) {
        case UUIndicatorViewStyleSlider:
            self.line.backgroundColor = color;
            break;
        case UUIndicatorViewStyleRounded: {
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

#pragma mark - Getters

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [UIView new];
    [self addSubview:_line];
    _line.backgroundColor = [UIColor colorWithRed:238.0 / 255 green:143.0 / 255 blue:102.0 / 255 alpha:1.0];
    return _line;
}

- (CGFloat)getCenterX {
    return self.center.x;
}

@end
