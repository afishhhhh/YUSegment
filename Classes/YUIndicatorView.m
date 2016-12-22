//
//  YUIndicatorView.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUIndicatorView.h"

@interface YUIndicatorView ()

@property (nonatomic, assign) YUIndicatorViewStyle style;

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
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    _maskView.frame = self.frame;
}

- (void)drawRect:(CGRect)rect {
    if (_style == YUIndicatorViewStyleLine) {
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = self.indicatorColor.CGColor;
        lineLayer.frame = (CGRect){0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4};
        if (_cornerRadius) {
            lineLayer.cornerRadius = 2.0;
        }
        [self.layer addSublayer:lineLayer];
    } else {
        CGFloat maxRadius = CGRectGetHeight(self.frame) / 2.0;
        self.layer.cornerRadius = _cornerRadius <= maxRadius ? _cornerRadius : maxRadius;
    }
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
    switch (_style) {
        case YUIndicatorViewStyleLine:
            [self setNeedsDisplay];
            break;
        case YUIndicatorViewStyleBox:
            self.backgroundColor = indicatorColor;
            break;
    }
}

#pragma mark - Getters

- (CGFloat)getCenterX {
    return self.center.x;
}

@end
