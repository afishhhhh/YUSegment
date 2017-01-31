//
//  YUSegment.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegment.h"
#import "YUSegment+Internal.h"
#import "YUSegmentLine.h"
#import "YUSegmentBox.h"

@interface YUSegment ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation YUSegment

#pragma mark - Initialization

//- (void)dealloc {
//    NSLog(@"dealloc");
//}

+ (instancetype)yu_segmentWithTitles:(NSArray <NSString *> *)titles style:(YUSegmentStyle)style {
    switch (style) {
        case YUSegmentStyleLine:
            return [[YUSegmentLine alloc] initWithTitles:titles];
            break;
        case YUSegmentStyleBox:
            return [[YUSegmentBox alloc] initWithTitles:titles];
            break;
    }
}

+ (instancetype)yu_segmentWithImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    return [[self class] yu_segmentWithImages:images unselectedImages:nil style:style];
#pragma clang diagnostic pop
}

+ (instancetype)yu_segmentWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages style:(YUSegmentStyle)style {
    switch (style) {
        case YUSegmentStyleLine:
            return [[YUSegmentLine alloc] initWithImages:images unselectedImages:unselectedImages];
            break;
        case YUSegmentStyleBox:
            return [[YUSegmentBox alloc] initWithImages:images unselectedImages:unselectedImages];
            break;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    NSAssert(titles, @"Titles must not be nil.");
    self = [super init];
    if (self) {
        _internalTitles = [titles mutableCopy];
        _numberOfSegments = [titles count];
        _labelsNormal = [NSMutableArray array];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(NSArray <UIImage *> *)unselectedImages {
    NSAssert(images, @"Images must not be nil.");
    self = [super init];
    if (self) {
        _internalImages = [images mutableCopy];
        if (unselectedImages) {
            _unselectImages = [unselectedImages mutableCopy];
        }
        _numberOfSegments = [images count];
        _imageViewsNormal = [NSMutableArray array];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // Set default values.
    _scrollEnabled = NO;
    _selectedIndex = 0;
    _contentOffset = kEachSegmentDefaultMargin;
    
    // Setup views.
    self.backgroundColor = [UIColor whiteColor];
    _containerNormal = [self setupContainer];
    _indicator = ({
        YUIndicatorView *indicator = [[YUIndicatorView alloc] init];
        [self addSubview:indicator];
        
        indicator;
    });
}

#pragma mark - Managing Segment Content

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    NSAssert(title, @"Title cannot be nil.");
    NSAssert(index < _numberOfSegments, @"Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
    _internalTitles[index] = [title copy];
    // Subclasses override this.
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    NSAssert(image, @"Image cannot be nil.");
    NSAssert(index < _numberOfSegments, @"Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
    _internalImages[index] = image;
    // Subclasses override this.
}

- (void)setImage:(UIImage *)image unselectedImage:(UIImage *)unselectedImage forSegmentAtIndex:(NSUInteger)index {
    // Subclasses implement this.
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _numberOfSegments, @"Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
    return _internalTitles ? _internalTitles[index] : nil;
    // Subclasses override this.
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _numberOfSegments, @"Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
    return _internalImages ? _internalImages[index] : nil;
    // Subclasses override this.
}

//- (void)addSegmentWithTitle:(NSString *)title {
//    [self insertSegmentWithTitle:title atIndex:_numberOfSegments];
//}
//
//- (void)addSegmentWithImage:(UIImage *)image {
//    [self insertSegmentWithImage:image atIndex:_numberOfSegments];
//}
//
//- (void)addSegmentWithTitle:(NSString *)title forImage:(UIImage *)image {
//    [self insertSegmentWithTitle:title forImage:image atIndex:_numberOfSegments];
//}
//
//- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
//    NSAssert(_internalTitles, @"You should use this method when the content of segment is `NSString` objcet.");
//    if (index > _numberOfSegments) {
//        index = _numberOfSegments;
//    }
//    [self.internalTitles insertObject:title atIndex:index];
//    _numberOfSegments++;
//    [self insertViewWithTitle:title atIndex:index];
//}
//
//- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)index {
//    NSAssert(_internalImages, @"You should use this method when the content of segment is `UIImage` objcet.");
//    if (index > _numberOfSegments) {
//        index = _numberOfSegments;
//    }
//    [self.internalImages insertObject:image atIndex:index];
//    _numberOfSegments++;
//    [self insertViewWithImage:image atIndex:index];
//}
//
//- (void)insertSegmentWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index {
//    NSAssert(_internalTitles && _internalImages, @"You should use this method when the content of the segment including `NSString` object and `UIImage` object.");
//    if (index > _numberOfSegments) {
//        index = _numberOfSegments;
//    }
//    [self.internalTitles insertObject:title atIndex:index];
//    [self.internalImages insertObject:image atIndex:index];
//    _numberOfSegments++;
//    [self insertViewWithTitle:title forImage:image atIndex:index];
//}
//
//- (void)insertViewWithTitle:(NSString *)title atIndex:(NSUInteger)index {
//    
//}
//
//- (void)insertViewWithImage:(UIImage *)image atIndex:(NSUInteger)index {
//    
//}
//
//- (void)insertViewWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index {
//    
//}
//
//- (void)removeAllItems {
//    
//}
//
//- (void)removeLastItem {
//    [self removeItemAtIndex:_numberOfSegments - 1];
//}
//
//- (void)removeItemAtIndex:(NSUInteger)index {
//    
//}

#pragma mark - Views Setup

- (void)makeContainerUsable {
    _containerSelected = [self setupContainer];
    _containerSelected.layer.mask = _indicator.maskView.layer;
}

- (UIView *)setupContainer {
    UIView *containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:containerView];
    [self setupConstraintsWithItem:containerView toItem:self];
    
    return containerView;
}

- (UILabel *)setupNormalLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:_textAttributesNormal];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)setupSelectedLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:title attributes:_textAttributesSelected];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)addLabels {
    UILabel *label;
    for (int i = 0; i < _numberOfSegments; i++) {
        label = [self setupNormalLabelWithTitle:_internalTitles[i]];
        [_labelsNormal addObject:label];
        [_containerNormal addSubview:label];
    }
    [self layoutSubviewsInContainer:_containerNormal];
    
    if (_containerSelected) {
        self.labelsSelected = [NSMutableArray array];
        for (int i = 0; i < _numberOfSegments; i++) {
            label = [self setupSelectedLabelWithTitle:_internalTitles[i]];
            [_labelsSelected addObject:label];
            [_containerSelected addSubview:label];
        }
        [self layoutSubviewsInContainer:_containerSelected];
    }
}

- (UIImageView *)setupImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (void)addImageViews {
    UIImageView *imageView;
    NSArray *images = _unselectImages ?: _internalImages;
    for (int i = 0; i < _numberOfSegments; i++) {
        imageView = [self setupImageViewWithImage:images[i]];
        [_imageViewsNormal addObject:imageView];
        [_containerNormal addSubview:imageView];
    }
    [self layoutSubviewsInContainer:_containerNormal];
    
    if (_containerSelected) {
        self.imageViewsSelected = [NSMutableArray array];
        for (int i = 0; i < _numberOfSegments; i++) {
            imageView = [self setupImageViewWithImage:_internalImages[i]];
            [_imageViewsSelected addObject:imageView];
            [_containerSelected addSubview:imageView];
        }
        [self layoutSubviewsInContainer:_containerSelected];
    }
}

#pragma mark - Views Update

- (void)updateViewHierarchy {
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:scrollView];
        [self setupConstraintsWithItem:scrollView toItem:self];
        
        scrollView;
    });
    
    [_containerNormal removeFromSuperview];
    [_scrollView addSubview:_containerNormal];
    [self setupConstraintsToScrollViewWithItem:_containerNormal];
    [self resetWidthConstraintsForSubviewsInContainer:_containerNormal];
    [_indicator removeFromSuperview];
    [_scrollView addSubview:_indicator];
    
    if (_containerSelected) {
        [_scrollView addSubview:_containerSelected];
        [self setupConstraintsToScrollViewWithItem:_containerSelected];
        [self resetWidthConstraintsForSubviewsInContainer:_containerSelected];
    }
}

- (void)setFont:(UIFont *)font forState:(YUSegmentedControlState)state {
    NSParameterAssert(font);
    if (state == YUSegmentedControlStateNormal) {
        _textAttributesNormal[NSFontAttributeName] = font;
        for (int i = 0; i < _numberOfSegments; i++) {
            _labelsNormal[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i] attributes:_textAttributesNormal];
        }
    } else {
        _textAttributesSelected[NSFontAttributeName] = font;
    }
    // Subclasses override this.
}

- (void)setTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    NSParameterAssert(textColor);
    if (state == YUSegmentedControlStateNormal) {
        _textAttributesNormal[NSForegroundColorAttributeName] = textColor;
        for (int i = 0; i < _numberOfSegments; i++) {
            _labelsNormal[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i] attributes:_textAttributesNormal];
        }
    } else {
        _textAttributesSelected[NSForegroundColorAttributeName] = textColor;
    }
    // Subclasses override this.
}

- (void)setTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state {
    NSParameterAssert(attributes);
    if (state == YUSegmentedControlStateNormal) {
        self.textAttributesNormal = [attributes mutableCopy];
        for (int i = 0; i < _numberOfSegments; i++) {
            _labelsNormal[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i] attributes:_textAttributesNormal];
        }
    } else {
        self.textAttributesSelected = [attributes mutableCopy];
    }
    // Subclasses override this.
}

- (NSDictionary *)textAttributesForState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            return [_textAttributesNormal copy];
            break;
        case YUSegmentedControlStateSelected:
            return [_textAttributesSelected copy];
            break;
    }
    // Subclass override this.
}

- (YUSegment * _Nonnull (^)(CGFloat))borderWidth {
    return ^ id (CGFloat borderWidth) {
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

- (YUSegment * _Nonnull (^)(UIColor * _Nonnull))borderColor {
    return ^ id (UIColor *borderColor) {
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

#pragma mark -

- (void)makeSegmentCenterIfNeeded {
//    CGFloat finalOffset = self.segmentWidth * (_selectedIndex + 0.5) - CGRectGetWidth(self.frame) / 2;
//    CGFloat maxOffset = _scrollView.contentSize.width - CGRectGetWidth(self.frame);
//    CGPoint contentOffset = _scrollView.contentOffset;
//    if (finalOffset <= 0) {
//        contentOffset.x = 0;
//    }
//    else if (finalOffset >= maxOffset) {
//        contentOffset.x = maxOffset;
//    }
//    else {
//        contentOffset.x = finalOffset;
//    }
//    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
//        _scrollView.contentOffset = contentOffset;
//    }];
}

#pragma mark - Setters

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    if (scrollEnabled) {
        [self updateViewHierarchy];
    }
}

- (void)setContentOffset:(CGFloat)contentOffset {
    if (_contentOffset == contentOffset) {
        return;
    }
    _contentOffset = contentOffset;
    [self updateOffsetForEachSegment];
}

#pragma mark - Getters

- (NSArray <NSString *> *)titles {
    return [_internalTitles copy];
}

- (NSArray <UIImage *> *)images {
    return [_internalImages copy];
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)layoutSubviewsInContainer:(UIView *)container {
    id lastView;
    NSArray *subviews = container.subviews;
    for (int i = 0; i < _numberOfSegments; i++) {
        [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
        
        if (lastView) {
            NSLayoutConstraint *offset = [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
            offset.active = YES;
            offset.identifier = @"o";
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
            width.active = YES;
            width.identifier = @"w";
        }
        else {
            NSLayoutConstraint *edge = [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
            edge.active = YES;
            edge.identifier = @"e";
        }
        lastView = subviews[i];
    }
    NSLayoutConstraint *edge = [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
    edge.active = YES;
    edge.identifier = @"e";
}

- (void)setupConstraintsWithItem:(id)item1 toItem:(id)item2 {
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0].active = YES;
}

- (void)setupConstraintsToScrollViewWithItem:(id)item {
    [self setupConstraintsWithItem:_scrollView toItem:item];
    [NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:item attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0].active = YES;
}

- (void)resetWidthConstraintsForSubviewsInContainer:(UIView *)container {
    for (NSLayoutConstraint *constraint in container.constraints) {
        if ([constraint.identifier isEqualToString:@"w"]) {
            constraint.active = NO;
        }
        if ([constraint.identifier isEqualToString:@"o"]) {
            constraint.constant = _contentOffset * 2.0;
        }
        if ([constraint.identifier isEqualToString:@"e"]) {
            constraint.constant = _contentOffset;
        }
    }
}

- (void)updateOffsetForEachSegment {

}

@end


@implementation YUIndicatorView

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.maskView) {
        self.maskView.frame = self.frame;
    }
}

#pragma mark -

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
    self.maskView.frame = self.frame;
}

- (YUIndicatorView * _Nonnull (^)(CGFloat))borderWidth {
    return ^ id (CGFloat borderWidth) {
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

- (YUIndicatorView * _Nonnull (^)(UIColor * _Nonnull))borderColor {
    return ^ id (UIColor *borderColor) {
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

#pragma mark - Getters

- (CGSize)size {
    return _size;
}

@end
