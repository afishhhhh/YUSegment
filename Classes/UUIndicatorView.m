//
//  UUIndicatorView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUIndicatorView.h"

@interface UUIndicatorView ()

@property (nonatomic, strong) UIView *underlineView;

@end

@implementation UUIndicatorView

#pragma mark - Initialization

- (instancetype)initWithType:(UUIndicatorViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _maskView = [UIView new];
        _maskView.backgroundColor = [UIColor blackColor];
        switch (type) {
            case UUIndicatorViewTypeUnderline:
                _underlineView = [UIView new];
                [self addSubview:_underlineView];
                _underlineView.backgroundColor = [UIColor  colorWithRed:238.0 / 255 green:143.0 / 255 blue:102.0 / 255 alpha:1.0];
                self.backgroundColor = [UIColor clearColor];
                break;
            case UUIndicatorViewTypeRectangle:
                self.backgroundColor = [UIColor whiteColor];
                break;
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    if (_underlineView) {
        _underlineView.frame = (CGRect){0, CGRectGetHeight(self.frame) - 4, CGRectGetWidth(self.frame), 4};
    }
    _maskView.frame = self.frame;
}

#pragma mark -

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

#pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_underlineView) {
        _underlineView.layer.cornerRadius = 2;
    }
}

@end
