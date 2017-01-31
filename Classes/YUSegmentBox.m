//
//  YUSegmentBox.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentBox.h"
#import "YUSegment+Internal.h"

@interface YUSegmentBox ()

@end

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger index = self.selectedIndex;
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorWidth = indicator.size.width ?: CGRectGetWidth(self.frame) / self.numberOfSegments;
    CGFloat indicatorHeight = indicator.size.height ?: CGRectGetHeight(self.frame);
    CGRect frame;
    if (self.scrollEnabled) {
        CGFloat x;
        for (int i = 0; i < index; i++) {
            x += [self calculateIndicatorWidthAtSegmentIndex:i];
        }
        x += index * 2 * kEachSegmentDefaultMargin;
        frame = (CGRect){x, 0, 64.0 + [self calculateIndicatorWidthAtSegmentIndex:index], indicatorHeight};
    }
    else {
        frame = (CGRect){index * CGRectGetWidth(self.frame) / self.numberOfSegments, 0, indicatorWidth, indicatorHeight};
    }
    indicator.frame = frame;

    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
    indicator.layer.cornerRadius = indicatorHeight / 2.0;
}

#pragma mark - Managing Segment Content

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    [super setTitle:title forSegmentAtIndex:index];
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
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        self.labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:titles[i] attributes:attributes];
    }
}

- (NSDictionary *)textAttributesForState:(YUSegmentedControlState)state {
    return [super textAttributesForState:state];
}

#pragma mark - Event Response

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:self.containerNormal];
    NSUInteger fromIndex = self.selectedIndex;
    UIView *hitView = [self.containerNormal hitTest:location withEvent:nil];
    NSUInteger toIndex = [self.containerNormal.subviews indexOfObject:hitView];
    if (toIndex != NSNotFound) {
        self.selectedIndex = toIndex;
        if (fromIndex != toIndex) {
            [self moveIndicatorFromIndex:fromIndex toIndex:toIndex];
        }
    }
}

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
                self.selectedIndex = toIndex;
                [self moveIndicatorFromIndex:fromIndex toIndex:toIndex];
            }
        }
        default:
            break;
    }
}

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    UIView *view = self.containerNormal.subviews[toIndex];
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        [self.indicator setCenterX:view.center.x];
    } completion:^(BOOL finished) {
        if (finished) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            if (self.scrollEnabled) {
                [self makeSegmentCenterIfNeeded];
            }
        }
    }];
}

#pragma mark - 

- (CGFloat)calculateIndicatorWidthAtSegmentIndex:(NSUInteger)index {
    CGFloat finalWidth = 0.0;
    if (self.internalTitles) {
        finalWidth = self.labelsSelected[index].intrinsicContentSize.width;
    } else {
        finalWidth = self.imageViewsSelected[index].intrinsicContentSize.width;
    }
    return finalWidth;
}

#pragma mark - Setters



@end
