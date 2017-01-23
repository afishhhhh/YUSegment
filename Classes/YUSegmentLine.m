//
//  YUSegmentLine.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentLine.h"
#import "YUSegment+Internal.h"

@interface YUSegmentLine ()

@end

@implementation YUSegmentLine

#pragma mark - Initialization

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    self = [super initWithTitles:titles];
    if (self) {
        self.textAttributesNormal = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
        self.textAttributesSelected = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName, nil];
        [self setupLabelsWithTitles:titles];
        [self line_commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    self = [super initWithImages:images unselectedImages:unselectedImages];
    if (self) {
        [self setupImageViewsWithImages:images unselectedImages:unselectedImages];
        [self line_commonInit];
    }
    return self;
}

- (void)line_commonInit {
    // Setup indicator
    self.indicator.backgroundColor = [UIColor orangeColor];
    // Setup gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"YUSegmentLine layoutSubviews.");
    NSUInteger index = self.selectedIndex;
    CGFloat segmentWidth = self.segmentWidth;
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorWidth = indicator.width ?: segmentWidth;
    CGFloat indicatorHeight = indicator.height ?: 2.0;
    if (indicator.fitWidth) {
        indicatorWidth = [self calculateIndicatorWidthAtSegmentIndex:index];
        CGFloat x = segmentWidth * index + (segmentWidth - indicatorWidth) / 2.0;
        indicator.frame = (CGRect){x, CGRectGetHeight(self.frame) - indicatorHeight, indicatorWidth, indicatorHeight};
    } else {
        CGFloat x = segmentWidth * index + (segmentWidth - indicatorWidth) / 2.0;
        indicator.frame = (CGRect){x, CGRectGetHeight(self.frame) - indicatorHeight, indicatorWidth, indicatorHeight};
    }
    
    NSArray *titles = self.internalTitles;
    NSArray *images = self.internalImages;
    if (titles) {
        self.labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:titles[index] attributes:self.textAttributesSelected];
    }
    if (images) {
        self.imageViewsNormal[index].image = images[index];
    }
}

#pragma mark - Views Setup

- (UILabel *)configureNormalLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.textAttributesNormal];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)setupLabelsWithTitles:(NSArray *)titles {
    UILabel *label;
    NSUInteger count = [titles count];
    NSMutableArray *labels = self.labelsNormal;
    UIView *container = self.containerNormal;
    for (int i = 0; i < count; i++) {
        label = [self configureNormalLabelWithTitle:titles[i]];
        [labels addObject:label];
        [container addSubview:label];
    }
    [self layoutSubviewsInContainer:container];
}

- (UIImageView *)configureImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (void)setupImageViewsWithImages:(NSArray *)images unselectedImages:(NSArray *)unselectedImages {
    UIImageView *imageView;
    NSArray *l_images;
    if (unselectedImages) {
        l_images = unselectedImages;
    } else {
        l_images = images;
    }
    NSUInteger count = [l_images count];
    NSMutableArray *imageViews = self.imageViewsNormal;
    UIView *container = self.containerNormal;
    for (int i = 0; i < count; i++) {
        imageView = [self configureImageViewWithImage:l_images[i]];
        [imageViews addObject:imageView];
        [container addSubview:imageView];
    }
    [self layoutSubviewsInContainer:container];
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
    self.selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:location.x];
    if (fromIndex != self.selectedIndex) {
        [self moveIndicatorFromIndex:fromIndex toIndex:self.selectedIndex];
    }
}

- (NSUInteger)nearestIndexOfSegmentAtXCoordinate:(CGFloat)x {
    NSUInteger index = x / self.segmentWidth;
    NSUInteger numberOfSegments = self.numberOfSegments;
    return index < numberOfSegments ? index : numberOfSegments - 1;
}

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        [self.indicator setCenterX:self.segmentWidth * (0.5 + toIndex)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self updateStateNewIndex:toIndex oldIndex:fromIndex];
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

- (void)setSegmentWidth:(CGFloat)segmentWidth {
    if (segmentWidth == self.segmentWidth) {
        return;
    }
    [super setSegmentWidth:segmentWidth];
    [super updateViewHierarchy];
}

@end
