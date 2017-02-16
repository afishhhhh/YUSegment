//
//  YUSegmentBox.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentBox.h"
#import "YUSegment+Internal.h"

@implementation YUSegmentBox {
    CGFloat _panCorrection;
}

#pragma mark - Initialization

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    self = [super initWithTitles:titles];
    if (self) {
        self.textAttributesNormal = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        self.textAttributesSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
        [self box_commonInit];
        [self addLabels];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    self = [super initWithImages:images unselectedImages:unselectedImages];
    if (self) {
        [self box_commonInit];
        [self addImageViews];
    }
    return self;
}

- (void)box_commonInit {
    // Setup views
    YUIndicatorView *indicator = self.indicator;
    indicator.maskView = [UIView new];
    indicator.maskView.backgroundColor = [UIColor whiteColor];
    indicator.layer.masksToBounds = YES;
    [self makeContainerUsable];
    
    // Setup gestures
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger index = self.selectedIndex;
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorHeight;
    CGFloat indicatorWidth;
    CGRect bounds;
    CGPoint center;
    if (self.scrollEnabled) {
        indicatorWidth = [self cacheAt:index].width - kContentOffsetDefaultValue + 16.0;
        indicatorHeight = CGRectGetHeight(self.frame) - 16.0;
        center = (CGPoint){[self cacheAt:index].x + [self cacheAt:index].width / 2.0, CGRectGetHeight(self.frame) / 2.0};
        indicator.layer.cornerRadius = 3.0;
    }
    else {
        indicatorWidth = CGRectGetWidth(self.frame) / self.numberOfSegments;
        indicatorHeight = CGRectGetHeight(self.frame);
        center = (CGPoint){(index + 0.5) * CGRectGetWidth(self.frame) / self.numberOfSegments, CGRectGetHeight(self.frame) / 2.0};
        self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
        indicator.layer.cornerRadius = indicatorHeight / 2.0;
    }
    bounds = (CGRect){0, 0, indicatorWidth, indicatorHeight};
    indicator.bounds = bounds;
    indicator.center = center;

}

#pragma mark - Managing Segment Content

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    [super setTitle:title forSegmentAtIndex:index];
    
    CGFloat constant = self.labelsNormal[index].intrinsicContentSize.width;
    if (self.scrollEnabled) {
        constant += kContentOffsetDefaultValue;
        self.widthConstraints[index].constant = constant;
        self.widthConstraints[index + self.numberOfSegments].constant = constant;
        [self layoutIfNeeded];
        for (int i = index + 1; i < self.numberOfSegments; i++) {
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
    [self setWidth:constant forCacheAt:index];
    
    self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                              attributes:self.textAttributesNormal];
    self.labelsSelected[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                attributes:self.textAttributesSelected];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    [super setImage:image forSegmentAtIndex:index];
    self.imageViewsNormal[index].image = image;
    self.imageViewsSelected[index].image = image;
}

- (void)setImage:(UIImage *)image unselectedImage:(UIImage *)unselectedImage forSegmentAtIndex:(NSUInteger)index {
    [super setImage:image forSegmentAtIndex:index];
    self.imageViewsNormal[index].image = image;
    self.imageViewsSelected[index].image = unselectedImage;
    self.unselectImages[index] = unselectedImage;
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    return [super titleForSegmentAtIndex:index];
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index {
    return [super imageForSegmentAtIndex:index];
}

#pragma mark - Views Update

- (void)setFont:(UIFont *)font forState:(YUSegmentedControlState)state {
    [super setFont:font forState:state];
    NSUInteger numberOfSegments = self.numberOfSegments;
    
    if (state == YUSegmentedControlStateNormal && self.scrollEnabled) {
        for (int i = 0; i < numberOfSegments; i++) {
            CGFloat constant = self.labelsNormal[i].intrinsicContentSize.width + kContentOffsetDefaultValue;
            self.widthConstraints[i].constant = constant;
            self.widthConstraints[i + numberOfSegments].constant = constant;
            [self setWidth:constant forCacheAt:i];
            [self layoutIfNeeded];
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
    
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        self.labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:titles[i] attributes:self.textAttributesSelected];
    }
}

- (void)setTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    [super setTextColor:textColor forState:state];
    NSUInteger numberOfSegments = self.numberOfSegments;
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        self.labelsSelected[i].attributedText = [[NSAttributedString alloc]initWithString:titles[i] attributes:self.textAttributesSelected];
    }
}

- (void)setTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state {
    [super setTextAttributes:attributes forState:state];
    NSUInteger numberOfSegments = self.numberOfSegments;
    
    if (state == YUSegmentedControlStateNormal && self.scrollEnabled) {
        for (int i = 0; i < numberOfSegments; i++) {
            CGFloat constant = self.labelsNormal[i].intrinsicContentSize.width + kContentOffsetDefaultValue;
            self.widthConstraints[i].constant = constant;
            self.widthConstraints[i + numberOfSegments].constant = constant;
            [self setWidth:constant forCacheAt:i];
            [self layoutIfNeeded];
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
    
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        self.labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:titles[i] attributes:attributes];
    }
}

- (NSDictionary *)textAttributesForState:(YUSegmentedControlState)state {
    return [super textAttributesForState:state];
}

#pragma mark - Event Response

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _panCorrection = [gestureRecognizer locationInView:self.indicator].x - CGRectGetWidth(self.indicator.frame) / 2;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint panLocation = [gestureRecognizer locationInView:self.containerNormal];
            [self.indicator setCenterX:(panLocation.x - _panCorrection)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            NSUInteger fromIndex = self.selectedIndex;
            UIView *hitView = [self.containerNormal hitTest:self.indicator.center withEvent:nil];
            NSUInteger toIndex = [self.containerNormal.subviews indexOfObject:hitView];
            if (toIndex != NSNotFound) {
                [self moveIndicatorFromIndex:fromIndex toIndex:toIndex];
            }
        }
        default:
            break;
    }
}

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    YUIndicatorView *indicator = self.indicator;
    CGRect frame = indicator.frame;
    if (self.scrollEnabled) {
        frame.size.width = [self cacheAt:toIndex].width - kContentOffsetDefaultValue + 16.0;
        frame.origin.x = [self cacheAt:toIndex].x + [self cacheAt:toIndex].width / 2.0 - CGRectGetWidth(frame) / 2.0;
    }
    else {
        frame.origin.x = (toIndex + 0.5) * CGRectGetWidth(self.frame) / self.numberOfSegments - CGRectGetWidth(frame) / 2.0;
    }
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        indicator.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.selectedIndex = toIndex;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            if (self.scrollEnabled) {
                [self makeSegmentCenterIfNeeded];
            }
        }
    }];
}

@end
