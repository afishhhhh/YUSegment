//
//  YUSegmentBox.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentBox.h"
#import "YUSegment+Internal.h"

@interface YUSegmentBox ()

@property (nonatomic, strong) UIView *containerSelected;

@property (nonatomic, strong) NSMutableArray <UILabel *>        *labelsSelected;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageViewsSelected;

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
        _labelsSelected = [NSMutableArray array];
        [self setupLabelsWithTitles:titles];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    self = [super initWithImages:images unselectedImages:unselectedImages];
    if (self) {
        [self box_commonInit];
        _imageViewsSelected = [NSMutableArray array];
        [self setupImageViewsWithImages:images unselectedImages:unselectedImages];
    }
    return self;
}

- (void)box_commonInit {
    // Setup views
    YUIndicatorView *indicator = self.indicator;
    indicator.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    indicator.maskView = [UIView new];
    indicator.maskView.backgroundColor = [UIColor whiteColor];
    indicator.layer.masksToBounds = YES;
    _containerSelected = ({
        UIView *container = [UIView new];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:container];
        [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
        [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
        container.layer.mask = indicator.maskView.layer;
        container;
    });
    // Setup gestures
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"YUSegmentLine layoutSubviews.");
    CGFloat segmentWidth = self.segmentWidth;
    YUIndicatorView *indicator = self.indicator;
    CGFloat indicatorWidth = indicator.width ?: segmentWidth;
    CGFloat indicatorHeight = indicator.height ?: CGRectGetHeight(self.frame);
    if (indicator.fitWidth) {
        indicatorWidth = [self calculateIndicatorWidthAtSegmentIndex:self.selectedIndex];
        CGFloat x = segmentWidth * self.selectedIndex + (segmentWidth - indicatorWidth) / 2.0;
        CGFloat y = (CGRectGetHeight(self.frame) - indicatorHeight) / 2.0;
        indicator.frame = (CGRect){x, y, indicatorWidth, indicatorHeight};
    } else {
        CGFloat x = segmentWidth * self.selectedIndex + (segmentWidth - indicatorWidth) / 2.0;
        CGFloat y = (CGRectGetHeight(self.frame) - indicatorHeight) / 2.0;
        indicator.frame = (CGRect){x, y, indicatorWidth, indicatorHeight};
    }
    self.layer.cornerRadius = CGRectGetHeight(self.frame) / 2.0;
    indicator.layer.cornerRadius = indicatorHeight / 2.0;
}

- (UILabel *)configureNormalLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.textAttributesNormal];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)configureSelectedLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.textAttributesSelected];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)setupLabelsWithTitles:(NSArray *)titles {
    UILabel *label;
    NSUInteger count = [titles count];
    NSMutableArray *labelsNormal = self.labelsNormal;
    UIView *containerNormal = self.containerNormal;
    for (int i = 0; i < count; i++) {
        label = [self configureNormalLabelWithTitle:titles[i]];
        [labelsNormal addObject:label];
        [containerNormal addSubview:label];
        
        label = [self configureSelectedLabelWithTitle:titles[i]];
        [_labelsSelected addObject:label];
        [_containerSelected addSubview:label];
    }
    [self layoutSubviewsInContainer:containerNormal];
    [self layoutSubviewsInContainer:_containerSelected];
}

- (UIImageView *)configureImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (void)setupImageViewsWithImages:(NSArray *)images unselectedImages:(NSArray *)unselectedImages {
    UIImageView *imageView;
    NSUInteger count = [images count];
    NSMutableArray *imageViewsNormal = self.imageViewsNormal;
    UIView *containerNormal = self.containerNormal;
    NSArray *u_images = unselectedImages ?: images;
    for (int i = 0; i < count; i++) {
        imageView = [self configureImageViewWithImage:u_images[i]];
        [imageViewsNormal addObject:imageView];
        [containerNormal addSubview:imageView];
        
        imageView = [self configureImageViewWithImage:images[i]];
        [_imageViewsSelected addObject:imageView];
        [_containerSelected addSubview:imageView];
    }
    [self layoutSubviewsInContainer:containerNormal];
    [self layoutSubviewsInContainer:_containerSelected];
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
        _labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:titles[i] attributes:self.textAttributesSelected];
    }
}

- (void)setTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    [super setTextColor:textColor forState:state];
    NSUInteger numberOfSegments = self.numberOfSegments;
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        _labelsSelected[i].attributedText = [[NSAttributedString alloc]initWithString:titles[i] attributes:self.textAttributesSelected];
    }
}

- (void)setTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state {
    [super setTextAttributes:attributes forState:state];
    NSUInteger numberOfSegments = self.numberOfSegments;
    NSArray *titles = self.internalTitles;
    for (int i = 0; i < numberOfSegments; i++) {
        _labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:titles[i] attributes:attributes];
    }
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
            CGFloat indicatorCenterX = self.indicator.center.x;
            NSUInteger fromIndex = self.selectedIndex;
            self.selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:indicatorCenterX];
            [self moveIndicatorFromIndex:fromIndex toIndex:self.selectedIndex];
        }
        default:
            break;
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
