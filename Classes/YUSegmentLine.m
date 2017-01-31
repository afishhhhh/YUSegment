//
//  YUSegmentLine.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentLine.h"
#import "YUSegment+Internal.h"

static const CGFloat kIndicatorDefaultHeight = 2.0;

@interface YUSegmentLine ()

@end

@implementation YUSegmentLine

#pragma mark - Initialization

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    self = [super initWithTitles:titles];
    if (self) {
        self.textAttributesNormal = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
        self.textAttributesSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [self addLabels];
        [self line_commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    self = [super initWithImages:images unselectedImages:unselectedImages];
    if (self) {
        [self addImageViews];
        [self line_commonInit];
    }
    return self;
}

- (void)line_commonInit {
    // Setup indicator
    // ...
    // Setup gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger index = self.selectedIndex;
    NSArray *titles = self.internalTitles;
    NSArray *images = self.internalImages;
    if (titles) {
        self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:titles[index] attributes:self.textAttributesSelected];
    }
    if (images) {
        self.imageViewsNormal[index].image = images[index];
    }
    
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorHeight = indicator.size.height ?: kIndicatorDefaultHeight;
    CGFloat indicatorWidth = indicator.size.width ?: [self calculateIndicatorWidthAtSegmentIndex:index];
    CGRect frame;
    if (self.scrollEnabled) {
        CGFloat x;
        for (int i = 0; i < index; i++) {
            x += [self calculateIndicatorWidthAtSegmentIndex:i];
        }
        x += (index + 0.5) * (2 * kEachSegmentDefaultMargin);
        frame = (CGRect){x, CGRectGetHeight(self.frame) - indicatorHeight, indicatorWidth, indicatorHeight};
    }
    else {
        frame = (CGRect){(index + 0.5) * CGRectGetWidth(self.frame) / self.numberOfSegments - indicatorWidth / 2.0, CGRectGetHeight(self.frame) - indicatorHeight, indicatorWidth, indicatorHeight};
    }
    indicator.frame = frame;
}

#pragma mark - Managing Segment Content

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    [super setTitle:title forSegmentAtIndex:index];
    if (index == self.selectedIndex) {
        self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.textAttributesSelected];
    } else {
        self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.textAttributesNormal];
    }
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    [super setImage:image forSegmentAtIndex:index];
    self.imageViewsNormal[index].image = image;
}

- (void)setImage:(UIImage *)image unselectedImage:(UIImage *)unselectedImage forSegmentAtIndex:(NSUInteger)index {
    [self setImage:image forSegmentAtIndex:index];
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
    NSUInteger index = self.selectedIndex;
    self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[index]
                                                                              attributes:self.textAttributesSelected];
}

- (void)setTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    [super setTextColor:textColor forState:state];
    NSUInteger index = self.selectedIndex;
    self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[index]
                                                                              attributes:self.textAttributesSelected];
}

- (void)setTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state {
    [super setTextAttributes:attributes forState:state];
    NSUInteger index = self.selectedIndex;
    self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[index]
                                                                              attributes:self.textAttributesSelected];
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

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    [self updateStateNewIndex:toIndex oldIndex:fromIndex];
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        if (!self.indicator.size.width) {
            CGFloat x;
            for (int i = 0; i < toIndex; i++) {
                x += [self calculateIndicatorWidthAtSegmentIndex:i];
            }
            x += (toIndex + 0.5) * (2 * kEachSegmentDefaultMargin);
            CGFloat width = [self calculateIndicatorWidthAtSegmentIndex:toIndex];
            CGRect frame = self.indicator.frame;
            frame.origin.x = x;
            frame.size.width = width;
            self.indicator.frame = frame;
        }
//        [self.indicator setCenterX:view.center.x];
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

- (void)updateStateNewIndex:(NSUInteger)newIndex oldIndex:(NSUInteger)oldIndex {
    if (self.labelsNormal) {
        self.labelsNormal[newIndex].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[newIndex] attributes:self.textAttributesSelected];
        self.labelsNormal[oldIndex].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[oldIndex] attributes:self.textAttributesNormal];
    }
    if (self.unselectImages) {
        self.imageViewsNormal[newIndex].image = self.internalImages[newIndex];
        self.imageViewsNormal[oldIndex].image = self.unselectImages[oldIndex];
    }
}

- (CGFloat)calculateIndicatorWidthAtSegmentIndex:(NSUInteger)index {
    CGFloat finalWidth = 0.0;
    if (self.internalTitles) {
        finalWidth = self.labelsNormal[index].intrinsicContentSize.width;
    } else {
        finalWidth = self.imageViewsNormal[index].intrinsicContentSize.width;
    }
    return finalWidth;
}

#pragma mark - Setters



@end
