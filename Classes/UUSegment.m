//
//  RDYSegmentedControl.m
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUSegment.h"
#import "UULabel.h"
#import "UUIndicatorView.h"

@interface UUSegment ()

///-----------------
/// @name Appearence
///-----------------



///------------
/// @name Views
///------------

@property (nonatomic, strong) UIView                                *containerView;
@property (nonatomic, strong) UIScrollView                          *scrollView;
@property (nonatomic, strong) UUIndicatorView                       *indicatorView;
@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraints;

///-----------------------
/// @name Segment Elements
///-----------------------

@property (nonatomic, strong) NSMutableArray <NSString *>       *titles;
@property (nonatomic, strong) NSMutableArray <UIImage *>        *images;
@property (nonatomic, assign) NSUInteger                        segments;
@property (nonatomic, strong) NSMutableArray <UIView *>         *segmentViews;

///--------------------
/// @name Mapping Table
///--------------------

@property (nonatomic, strong) NSMutableArray <UULabel *>                            *labelTable;
@property (nonatomic, strong) NSMutableArray <UIImageView *>                        *imageTable;

//@property (nonatomic, assign, getter = isDataSourceNil) BOOL dataSourceNil;

@end

@implementation UUSegment

@dynamic font;

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitles:nil];
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles {
    NSAssert((titles && [titles count]), @"Titles can not be empty.");
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titles = [titles mutableCopy];
        _segments = [titles count];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images {
    NSAssert((images && [images count]), @"Images can not be empty.");
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _images = [images mutableCopy];
        _segments = [images count];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles forImages:(NSArray<UIImage *> *)images {
    NSAssert((titles && [titles count] && images && [images count]), @"Titles and images can not be empty.");
    NSAssert(([titles count] == [images count]), @"The count of titles should be equal to the count of images.");
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titles = [titles mutableCopy];
        _images = [images mutableCopy];
        _segments = [titles count];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _currentIndex = 0;
    // Setup UI
//    [self setupScrollView];
    [self setupContainerView];
    [self setupSegmentViews];
    [self setupConstraintsWithSegmentViewsToContainerView];
    [self setupIndicatorView];
    // Add gesture
    [self addGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicatorView.frame = (CGRect){[self segmentWidth] * _currentIndex, CGRectGetHeight(self.frame) - 4, [self segmentWidth], 4};
}

#pragma mark - Items Setting

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    [self update:title forTitlesAtIndex:index];
    [self updateTitle:title forSegmentViewAtIndex:index];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    [self update:image forImagesAtIndex:index];
    [self updateImage:image forSegmentViewAtIndex:index];
}

- (void)setTitle:(NSString *)title forImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    [self update:title forImage:image forTitlesAndImagesAtIndex:index];
    [self updateTitle:title forImage:image forSegmentViewAtIndex:index];
}

- (void)update:(NSString *)title forTitlesAtIndex:(NSUInteger)index {
    self.titles[index] = title;
}

- (void)update:(UIImage *)image forImagesAtIndex:(NSUInteger)index {
    self.images[index] = image;
}

- (void)update:(NSString *)title forImage:(UIImage *)image forTitlesAndImagesAtIndex:(NSUInteger)index {
    self.titles[index] = title;
    self.images[index] = image;
}

- (void)updateTitle:(NSString *)title forSegmentViewAtIndex:(NSUInteger)index {
    UIView *oldSegmentView = _segmentViews[index];
    UULabel *label = _labelTable[index];
    label.text = title;
}

- (void)updateImage:(UIImage *)image forSegmentViewAtIndex:(NSUInteger)index {
    UIView *oldSegmentView = _segmentViews[index];
    UIImageView *imageView = _imageTable[index];
    imageView.image = image;
}

- (void)updateTitle:(NSString *)title forImage:(UIImage *)image forSegmentViewAtIndex:(NSUInteger)index {
    UIView *oldSegmentView = _segmentViews[index];
    UULabel *label = _labelTable[index];
    label.text = title;
    UIImageView *imageView = _imageTable[index];
    imageView.image = image;
}

- (void)updateTextForFont:(UIFont *)font {
    for (UULabel *label in _labelTable) {
        label.font = font;
    }
}

- (void)updateTextForColor:(UIColor *)color {
    for (UULabel *label in _labelTable) {
        label.textColor = color;
    }
}

#pragma mark - Items Getting

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    return _titles[index];
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    return _images[index];
}

- (NSDictionary *)titleAndImageForSegmentAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Index should in the range of 0...%lu", _segments - 1);
    NSDictionary *dic = @{@"title" : _titles[index], @"image" : _images[index]};
    return dic;
}

#pragma mark - Items Insert

- (void)addSegmentWithTitle:(NSString *)title {
    [self insertSegmentWithTitle:title atIndex:_segments];
}

- (void)addSegmentWithImage:(UIImage *)image {
    [self insertSegmentWithImage:image atIndex:_segments];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    NSAssert1(index <= _segments, @"Index should in the range of 0...%lu", _segments);
    
    [self.titles insertObject:title atIndex:index];
    self.segments++;
    
    UIView *segmentView = [self setupSegmentViewWithTitle:title];
    [self insertSegment:segmentView atIndex:index];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)index {
    NSAssert1(index <= _segments, @"Index should in the range of 0...%lu", _segments);
    
    [self.images insertObject:image atIndex:index];
    self.segments++;
    
    UIView *segmentView = [self setupSegmentViewWithImage:image];
    [self insertSegment:segmentView atIndex:index];
}

- (void)insertSegment:(UIView *)segmentView atIndex:(NSUInteger)index {
    [self.segmentViews insertObject:segmentView atIndex:index];
    [self updateConstraintsWithInsertSegmentView:segmentView atIndex:index];
}

#pragma mark - Items Delete

- (void)removeAllItems {
    
}

- (void)removeLastItem {
    [self removeItemAtIndex:_segments - 1];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    NSAssert1(index < _segments, @"Parameter index should in the range of 0...%lu", _segments - 1);
}

#pragma mark - Views Setup

- (void)setupSegmentViews {
    _segmentViews = [NSMutableArray array];
    UIView *segmentView;
    if (_titles && _images) {
        // Segment view with title and image
        for (int i = 0; i < _segments; i++) {
            segmentView = [self setupSegmentViewWithTitle:_titles[i] forImage:_images[i]];
            [_segmentViews addObject:segmentView];
        }
    }
    else if (_titles) {
        // Segment view with title
        for (NSString *title in _titles) {
            segmentView = [self setupSegmentViewWithTitle:title];
            [_segmentViews addObject:segmentView];
        }
    }
    else {
        // Segment view with image
        for (UIImage *image in _images) {
            segmentView = [self setupSegmentViewWithImage:image];
            [_segmentViews addObject:segmentView];
        }
    }
}

- (UIView *)setupSegmentViewWithTitle:(NSString *)title {
    UIView *segmentView = [UIView new];
    UULabel *label = [[UULabel alloc] initWithText:title];
    [segmentView addSubview:label];
    segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupConstraintsForInnerView:label inSegmentView:segmentView];
    [_containerView addSubview:segmentView];
    
    segmentView.backgroundColor = [UIColor yellowColor];
    
    return segmentView;
}

- (UIView *)setupSegmentViewWithImage:(UIImage *)image {
    UIView *segmentView = [UIView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [segmentView addSubview:imageView];
    segmentView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setupConstraintsForInnerView:imageView inSegmentView:segmentView];
    [_containerView addSubview:segmentView];
    
    segmentView.backgroundColor = [UIColor yellowColor];
    
    return segmentView;
}

- (UIView *)setupSegmentViewWithTitle:(NSString *)title forImage:(UIImage *)image {
    UIView *segmentView = [UIView new];
    return segmentView;
}

- (void)setupScrollView {
    _scrollView = ({
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = NO;
        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:scrollView];
        
        scrollView;
    });
    [self setupConstraintsToSelfWithView:_scrollView];
}

- (void)setupContainerView {
    _containerView = ({
        UIView *containerView = [UIView new];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:containerView];
        
        containerView;
    });
    [self setupConstraintsToSelfWithView:_containerView];
}

- (void)setupIndicatorView {
    _indicatorView = [UUIndicatorView new];
    [_containerView addSubview:_indicatorView];
}

#pragma mark - Views Update

- (void)updateViewForColor:(UIColor *)color {
    self.containerView.backgroundColor = color;
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setupConstraintsForInnerView:(UIView *)innerView inSegmentView:(UIView *)view {
    [NSLayoutConstraint constraintWithItem:innerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:innerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:innerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:innerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

- (void)setupConstraintsWithSegmentViewsToContainerView {
    
    UIView *lastView;
    
    for (int i = 0; i < _segments; i++) {
        UIView *view = _segmentViews[i];
        // view's top equal to containerView
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0
         ].active = YES;
        
        // view's bottom equal to containerView
        [NSLayoutConstraint constraintWithItem:view
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0.0
         ].active = YES;
        
        if (lastView) {
            // view's left equal to lastView offset 8
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lastView
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                          constant:0.0];
            leading.active = YES;
            [self.leadingConstraints addObject:leading];
            
            
            // view's width equal to lastView
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lastView
                                         attribute:NSLayoutAttributeWidth
                                        multiplier:1.0
                                          constant:0.0
             ].active = YES;
        }
        else {
            // the first view's left equal to containerView offset 16
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:_containerView
                                         attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                          constant:0.0];
            leading.active = YES;
            [self.leadingConstraints addObject:leading];
        }
        
        lastView = view;
    }
    // the last view's right equal to containerView offset 16
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:lastView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

- (void)setupConstraintsToSelfWithView:(UIView *)view  {
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

- (void)setupConstraintsWithContainerViewToScrollView {
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_scrollView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_containerView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

- (void)updateConstraintsWithInsertSegmentView:(UIView *)segmentView atIndex:(NSUInteger)index {
    if (_leadingConstraints) {
        NSLayoutConstraint *oldLeading = _leadingConstraints[index];
        id item = oldLeading.firstItem;
        id toItem = oldLeading.secondItem;
        oldLeading.active = NO;
        
        NSLayoutConstraint *newLeading = [NSLayoutConstraint constraintWithItem:segmentView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:toItem
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:8.0];
        newLeading.active = YES;
        [self.leadingConstraints insertObject:newLeading atIndex:index];
        
        oldLeading = [NSLayoutConstraint constraintWithItem:item
                                                  attribute:NSLayoutAttributeLeading
                                                  relatedBy:NSLayoutRelationEqual
                                                     toItem:segmentView
                                                  attribute:NSLayoutAttributeTrailing
                                                 multiplier:1.0
                                                   constant:8.0];
        oldLeading.active = YES;
        self.leadingConstraints[index + 1] = oldLeading;
        
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:segmentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
        widthConstraint.active = YES;
        
        [self layoutIfNeeded];
        
        [NSLayoutConstraint constraintWithItem:segmentView
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                      constant:0.0
         ].active = YES;
        
        [NSLayoutConstraint constraintWithItem:segmentView
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_containerView
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                      constant:0.0
         ].active = YES;
        
        widthConstraint.active = NO;
        widthConstraint = [NSLayoutConstraint constraintWithItem:segmentView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:toItem
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:1.0
                                      constant:0.0
         ];
        widthConstraint.active = YES;
        
        [UIView animateWithDuration:3 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (void)updateConstraintsWithDeleteSegmentViewAtIndex:(NSUInteger)index {
    
}


#pragma mark - Event Response

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tapGesture {
    CGPoint location = [tapGesture locationInView:self];
    NSUInteger oldIndex = self.currentIndex;
    self.currentIndex = [self nearestIndexOfSegmentAtPoint:location];
    if (oldIndex != self.currentIndex) {
        [self moveIndicatorViewToIndex:self.currentIndex animated:YES];
    }
}

- (NSUInteger)nearestIndexOfSegmentAtPoint:(CGPoint)point {
    NSUInteger index = point.x / [self segmentWidth];
    return index;
}

- (void)moveIndicatorViewToIndex:(NSUInteger)index animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self.indicatorView setX:[self segmentWidth] * index];
        } completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
        }];
    }
    else {
        [self.indicatorView setX:[self segmentWidth] * index];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark -

- (CGFloat)segmentWidth {
    return CGRectGetWidth(self.bounds) / _segments;
}

#pragma mark - Setters

- (void)setScrollOn:(BOOL)scrollOn {
    _scrollOn = scrollOn;
    _scrollView.scrollEnabled = scrollOn;
}

- (void)setTextColor:(UIColor *)textColor {
    NSAssert(textColor, @"The color should not be nil.");
    if (textColor != _textColor && ![textColor isEqual:_textColor]) {
        _textColor = textColor;
        [self updateTextForColor:textColor];
    }
}

- (void)setFont:(UUFont)font {
    CGFloat fontSize = font.size;
    CGFloat fontWeight;
    
    switch (font.weight) {
        case UUFontWeightThin:
            fontWeight = UIFontWeightThin;
            break;
        case UUFontWeightMedium:
            fontWeight = UIFontWeightMedium;
            break;
        case UUFontWeightBold:
            fontWeight = UIFontWeightBold;
            break;
    }
    [self updateTextForFont:[UIFont systemFontOfSize:fontSize weight:fontWeight]];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSAssert(backgroundColor, @"The color should not be nil.");
    if (backgroundColor != _backgroundColor && ![backgroundColor isEqual:_backgroundColor]) {
        _backgroundColor = backgroundColor;
        [self updateViewForColor:backgroundColor];
    }
}

#pragma mark - Getters

- (NSMutableArray <NSLayoutConstraint *> *)leadingConstraints {
    if (_leadingConstraints) {
        return _leadingConstraints;
    }
    _leadingConstraints = [NSMutableArray array];
    return _leadingConstraints;
}

- (NSMutableArray <UULabel *> *)labelTable {
    if (_labelTable) {
        return _labelTable;
    }
    _labelTable = [NSMutableArray array];
    return _labelTable;
}

- (NSMutableArray <UIImageView *> *)imageTable {
    if (_imageTable) {
        return _imageTable;
    }
    _imageTable = [NSMutableArray array];
    return _imageTable;
}

@end
