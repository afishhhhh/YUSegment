//
//  YUSegment
//  Created by afishhhhh on 2017/3/25.
//  Copyright © 2017年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentedControlItem.h"

@interface YUSegmentedControlItem ()

@property (nonatomic, weak) CALayer *divider;
@property (nonatomic, weak) CALayer *badge;

@end

@implementation YUSegmentedControlItem

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled = YES;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        _view = view;
        
        // layout
        NSDictionary *views = @{@"view": view};
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CALayer *divider = self.divider;
    if (divider) {
        divider.frame = (CGRect){0, 0, 1.0, CGRectGetHeight(self.bounds)};
    }
    CALayer *badge = self.badge;
    if (badge) {
        CGFloat x = (CGRectGetWidth(self.bounds) + _view.intrinsicContentSize.width) / 2;
        badge.frame = (CGRect){x, -4.0, 8.0, 8.0};
    }
}

- (void)showVerticalDivider {
    CALayer *divider = ({
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorWithRed:231.0 / 255 green:231.0 / 255 blue:231.0 / 255 alpha:1.0].CGColor;
        [self.layer addSublayer:layer];
        
        layer;
    });
    self.divider = divider;
}

- (void)hideVerticalDivider {
    [_divider removeFromSuperlayer];
}

- (void)showBadge {
    if (_badge) {
        return;
    }
    CALayer *badge = ({
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.cornerRadius = 4.0;
        layer.shadowColor = [UIColor redColor].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = (CGSize){1.0, 1.0};
        [self.layer addSublayer:layer];
        
        layer;
    });
    self.badge = badge;
    [self setNeedsLayout];
}

- (void)hideBadge {
    if (!_badge) {
        return;
    }
    [_badge removeFromSuperlayer];
}

@end
