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

/// @name Views


@property (nonatomic, strong) UIScrollView  *scrollView;


/// @name Constraints

//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsNormal;
//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsSelected;

/// @name Appearance

@end

@implementation YUSegment {
    CGFloat _segmentWidth;
}

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
    
    // Setup views.
    self.backgroundColor = [UIColor whiteColor];
    _containerNormal = ({
        UIView *containerView = [UIView new];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:containerView];
        [self setupConstraintsWithItem:containerView toItem:self];
        
        containerView;
    });
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

#pragma mark - Views Update

- (void)updateViewHierarchy {
    [_containerNormal removeFromSuperview];
    [self.scrollView addSubview:_containerNormal];
    [self setupConstraintsToScrollViewWithItem:_containerNormal];
    [_indicator removeFromSuperview];
    [_scrollView addSubview:_indicator];
    [self updateWidthConstraintsForSegments];
    // Subclasses override this.
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
    CGFloat finalOffset = self.segmentWidth * (_selectedIndex + 0.5) - CGRectGetWidth(self.frame) / 2;
    CGFloat maxOffset = _scrollView.contentSize.width - CGRectGetWidth(self.frame);
    CGPoint contentOffset = _scrollView.contentOffset;
    if (finalOffset <= 0) {
        contentOffset.x = 0;
    }
    else if (finalOffset >= maxOffset) {
        contentOffset.x = maxOffset;
    }
    else {
        contentOffset.x = finalOffset;
    }
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        _scrollView.contentOffset = contentOffset;
    }];
}

#pragma mark - Setters

- (void)setSegmentWidth:(CGFloat)segmentWidth {
    _segmentWidth = segmentWidth;
    // Subclasses implement this.
}

#pragma mark - Getters

- (NSArray <NSString *> *)titles {
    return [_internalTitles copy];
}

- (NSArray <UIImage *> *)images {
    return [_internalImages copy];
}

- (CGFloat)segmentWidth {
    if (!_segmentWidth) {
        return CGRectGetWidth(self.bounds) / _numberOfSegments;
    }
    return _segmentWidth;
}

- (UIScrollView *)scrollView {
    if (_scrollView) {
        return _scrollView;
    }
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:scrollView];
        _scrollEnabled = YES;
        
        scrollView;
    });
    [self setupConstraintsWithItem:_scrollView toItem:self];
    
    return _scrollView;
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)layoutSubviewsInContainer:(UIView *)container {
    id lastView;
    NSArray *subviews = container.subviews;
    for (int i = 0; i < _numberOfSegments; i++) {
        [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0].active = YES;
        
        if (lastView) {
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
            leading.active = YES;
            leading.identifier = [NSString stringWithFormat:@"%d", i];
            
            [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
        }
        else {
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:subviews[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
            leading.active = YES;
            leading.identifier = [NSString stringWithFormat:@"%d", i];
        }
        lastView = subviews[i];
    }
    [NSLayoutConstraint constraintWithItem:container attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
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

- (void)updateWidthConstraintsForSegments {
    id item = _containerNormal.subviews[0];
    [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_segmentWidth].active = YES;
//    item = _containerSelected.subviews[0];
//    [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_segmentWidth].active = YES;
}

- (void)updateConstraintsWithItem:(id)item1 toItem:(id)item2 atIndex:(NSUInteger)index {
    NSString *identifier = [NSString stringWithFormat:@"%lu", (unsigned long)index];
    __block NSLayoutConstraint *oldLeading;
    [((UIView *)item2).constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.identifier && [obj.identifier isEqualToString:identifier]) {
            oldLeading = obj;
            *stop = YES;
        }
    }];
    id item = oldLeading.firstItem;
    id toItem = oldLeading.secondItem;
    oldLeading.active = NO;
    
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0].active = YES;
    
    [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:item2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0].active = YES;
    
    NSLayoutConstraint *newLeading = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];
    newLeading.active = YES;
//    [self.leadingConstraints insertObject:newLeading atIndex:index];
    
    oldLeading = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:item1 attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];
    oldLeading.active = YES;
//    self.leadingConstraints[index + 1] = oldLeading;
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:item1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    widthConstraint.active = YES;
    
//    [UIView animateWithDuration:3 animations:^{
//        [self layoutIfNeeded];
//    }];
}

- (void)updateConstraintsWithDeleteSegmentViewAtIndex:(NSUInteger)index {
    
}

@end


@implementation YUIndicatorView

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _fitWidth = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    if (self.maskView) {
        self.maskView.frame = self.frame;
    }
}

#pragma mark -

- (void)adjustsContentToFitWidth {
    _fitWidth = YES;
}

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

@end
