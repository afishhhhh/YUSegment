//
//  YUIndicatorView.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUIndicatorView.h"

@interface YUIndicatorView ()

@property (nonatomic, assign) YUIndicatorViewStyle style;
@property (nonatomic, strong) UIView               *line;

@end

@implementation YUIndicatorView

#pragma mark - Initialization

- (instancetype)initWithStyle:(YUIndicatorViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        _indicatorColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor whiteColor];
        if (style == YUIndicatorViewStyleLine) {
            [self addSubview:self.line];
        }
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    if (_line) {
        _line.frame = (CGRect){0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4};
        if (_cornerRadius) {
            _line.layer.cornerRadius = 2.0;
        }
    }
    if (_cornerRadius) {
        CGFloat maxRadius = CGRectGetHeight(self.frame) / 2.0;
        self.layer.cornerRadius = _cornerRadius <= maxRadius ? _cornerRadius : maxRadius;
    }
    _maskView.frame = self.frame;
}

#pragma mark -

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    _maskView.frame = self.frame;
}

#pragma mark - Setters

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    if ([indicatorColor isEqual:[UIColor clearColor]]) {
        indicatorColor = [UIColor whiteColor];
    }
    switch (_style) {
        case YUIndicatorViewStyleLine:
            self.line.backgroundColor = indicatorColor;
            break;
        case YUIndicatorViewStyleBox: {
            self.backgroundColor = indicatorColor;
            break;
        }
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (cornerRadius == _cornerRadius) {
        return;
    }
    _cornerRadius = cornerRadius;
}

#pragma mark - Getters

- (UIView *)line {
    if (_line) {
        return _line;
    }
    _line = [UIView new];
    _line.backgroundColor = _indicatorColor;
    return _line;
}

- (CGFloat)getCenterX {
    return self.center.x;
}

@end
