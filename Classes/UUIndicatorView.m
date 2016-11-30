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
        switch (type) {
            case UUIndicatorViewTypeUnderline:
                _underlineView = [UIView new];
                [self addSubview:_underlineView];
                _underlineView.backgroundColor = [UIColor redColor];
                self.backgroundColor = [UIColor clearColor];
                break;
            case UUIndicatorViewTypeRectangle:
                
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
