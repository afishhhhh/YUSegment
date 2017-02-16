//
//  YUSegmentLine.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentLine.h"
#import "YUSegment+Internal.h"

static const CGFloat kIndicatorDefaultHeight = 2.0;

@implementation YUSegmentLine

#pragma mark - Initialization

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    self = [super initWithTitles:titles];
    if (self) {
        self.textAttributesNormal = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
        self.textAttributesSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [self addLabels];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    self = [super initWithImages:images unselectedImages:unselectedImages];
    if (self) {
        [self addImageViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger index = self.selectedIndex;
    if (self.isTitleAsContent) {
        self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[index] attributes:self.textAttributesSelected];
    } else {
        self.imageViewsNormal[index].image = self.internalImages[index];
    }
    
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorWidth;
    CGRect bounds;
    CGPoint center;
    if (self.scrollEnabled) {
        indicatorWidth = [self cacheAt:index].width - kContentOffsetDefaultValue;
        center = (CGPoint){[self cacheAt:index].x + [self cacheAt:index].width / 2.0, CGRectGetHeight(self.frame) - kIndicatorDefaultHeight / 2.0};
    }
    else {
        indicatorWidth = CGRectGetWidth(self.frame) / self.numberOfSegments;
        center = (CGPoint){(index + 0.5) * CGRectGetWidth(self.frame) / self.numberOfSegments, CGRectGetHeight(self.frame) - kIndicatorDefaultHeight / 2.0};
    }
    bounds = (CGRect){0, 0, indicatorWidth, kIndicatorDefaultHeight};
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
        [self layoutIfNeeded];
        for (int i = index + 1; i < self.numberOfSegments; i++) {
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
    [self setWidth:constant forCacheAt:index];
    
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
    if (state == YUSegmentedControlStateNormal && self.scrollEnabled) {
        for (int i = 0; i < self.numberOfSegments; i++) {
            CGFloat constant = self.labelsNormal[i].intrinsicContentSize.width + kContentOffsetDefaultValue;
            self.widthConstraints[i].constant = constant;
            [self setWidth:constant forCacheAt:i];
            [self layoutIfNeeded];
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
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
    if (state == YUSegmentedControlStateNormal && self.scrollEnabled) {
        for (int i = 0; i < self.numberOfSegments; i++) {
            CGFloat constant = self.labelsNormal[i].intrinsicContentSize.width + kContentOffsetDefaultValue;
            self.widthConstraints[i].constant = constant;
            [self setWidth:constant forCacheAt:i];
            [self layoutIfNeeded];
            [self setX:self.labelsNormal[i].frame.origin.x forCacheAt:i];
        }
    }
    NSUInteger index = self.selectedIndex;
    self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:self.internalTitles[index]
                                                                              attributes:self.textAttributesSelected];
}

- (NSDictionary *)textAttributesForState:(YUSegmentedControlState)state {
    return [super textAttributesForState:state];
}

#pragma mark - 

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    YUIndicatorView *indicator = self.indicator;
    CGRect frame = indicator.frame;
    if (self.scrollEnabled) {
        frame.size.width = [self cacheAt:toIndex].width - kContentOffsetDefaultValue;
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

#pragma mark - Setters

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    NSUInteger old = self.selectedIndex;
    [super setSelectedIndex:selectedIndex];
    
    if (self.isTitleAsContent) {
        NSArray <UILabel *> *labels = self.labelsNormal;
        NSArray *titles = self.internalTitles;
        labels[selectedIndex].attributedText = [[NSAttributedString alloc] initWithString:titles[selectedIndex] attributes:self.textAttributesSelected];
        labels[old].attributedText = [[NSAttributedString alloc] initWithString:titles[old] attributes:self.textAttributesNormal];
    }
    else if (self.unselectImages) {
        self.imageViewsNormal[selectedIndex].image = self.internalImages[selectedIndex];
        self.imageViewsNormal[old].image = self.unselectImages[old];
    }
}

@end
