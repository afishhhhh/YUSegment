//
//  YUSegment.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegment.h"
#import "YULabel.h"
#import "YUImageView.h"
#import "YUImageTextView.h"
#import "YUIndicatorView.h"

@interface YUSegment ()

/// @name Views

@property (nonatomic, strong) UIView                                 *containerView;
@property (nonatomic, strong) UIView                                 *selectedContainerView;
@property (nonatomic, strong) UIScrollView                           *scrollView;
@property (nonatomic, strong) YUIndicatorView                        *indicatorView;
@property (nonatomic, assign) BOOL                                   needsUpdateViewHierarchy;

/// @name Constraints

//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsNormal;
//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsSelected;

/// @name Contents

@property (nonatomic, strong) NSMutableArray <NSString *>    *internalTitles;
@property (nonatomic, strong) NSMutableArray <UIImage *>     *internalImages;
@property (nonatomic, strong) NSMutableArray <YULabel *>     *labels;
@property (nonatomic, strong) NSMutableArray <YUImageView *> *imageViews;
@property (nonatomic, strong) NSMutableArray <YULabel *>     *selectedLabels;
@property (nonatomic, strong) NSMutableArray <YUImageView *> *selectedImageViews;

/// @name Appearance

@property (nonatomic, copy)   NSDictionary *textAttributesNormal;
@property (nonatomic, copy)   NSDictionary *textAttributesSelected;

/// @name Gesture

@property (nonatomic, assign) CGFloat panCorrection;

@end

@implementation YUSegment {
    CGFloat _segmentWidth;
    UIColor *_textColor;
    UIColor *_selectedTextColor;
    UIFont  *_font;
    UIFont  *_selectedFont;
}

@dynamic segmentWidth;
@dynamic textColor;
@dynamic selectedTextColor;
@dynamic font;
@dynamic selectedFont;

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultValueForProperties];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    return [self initWithTitles:titles style:YUSegmentStyleLine];
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images {
    return [self initWithImages:images style:YUSegmentStyleLine];
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images {
    NSAssert([titles count] == [images count], @"The count of titles should be equal to the count of images.");
    return [self initWithTitles:titles forImages:images style:YUSegmentStyleLine];
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles style:(YUSegmentStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _internalTitles = [titles mutableCopy];
        _numberOfSegments = [titles count];
        _style = style;
        [self setDefaultValueForProperties];
        [self commonInit];
        [self configureLabels];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _internalImages = [images mutableCopy];
        _numberOfSegments = [images count];
        _style = style;
        [self setDefaultValueForProperties];
        [self commonInit];
        [self configureImages];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _internalTitles = [titles mutableCopy];
        _internalImages = [images mutableCopy];
        _numberOfSegments = [titles count];
        _style = style;
        [self setDefaultValueForProperties];
        [self commonInit];
        [self configureMixtureViews];
    }
    return self;
}

- (void)setDefaultValueForProperties {
    _needsUpdateViewHierarchy = NO;
    _selectedIndex = 0;
//    self.backgroundColor = [UIColor whiteColor];
}

- (void)commonInit {
    // Build UI
    [self setupContainerView];
    [self setupSelectedContainerView];
    [self setupIndicatorView];
    [self buildUI];
    // Add gestures
    if (_style == YUSegmentStyleBox) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"Segment layoutSubviews");
    
    CGFloat segmentWidth = self.segmentWidth;
    switch (_style) {
        case YUSegmentStyleLine: {
            CGFloat indicatorWidth = [self calculateIndicatorWidthPlusConstant];
            CGFloat x = segmentWidth * _selectedIndex + (segmentWidth - indicatorWidth) / 2.0;
            CGRect indicatorFrame = (CGRect){x, 0, indicatorWidth, CGRectGetHeight(self.frame)};
            _indicatorView.frame = indicatorFrame;
            break;
        }
        case YUSegmentStyleBox: {
            CGRect indicatorFrame = (CGRect){segmentWidth * _selectedIndex, 0, segmentWidth, CGRectGetHeight(self.frame)};
            _indicatorView.frame = CGRectInset(indicatorFrame, _indicatorMargin, _indicatorMargin);
            break;
        }
    }
}

#pragma mark - Content

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index {
    NSParameterAssert(title);
    [self setTitle:title forImage:nil forSegmentAtIndex:index];
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    NSParameterAssert(image);
    [self setTitle:nil forImage:image forSegmentAtIndex:index];
}

- (void)setTitle:(NSString *)title forImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    if (index > _numberOfSegments - 1) {
        index = _numberOfSegments - 1;
    }
    [self setSegmentWithTitle:title image:image atIndex:index];
}

- (void)setSegmentWithTitle:(NSString *)title image:(UIImage *)image atIndex:(NSUInteger)index {
    if (title) {
        self.internalTitles[index] = [title copy];
        if (_textAttributesNormal) {
            _labels[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                            attributes:_textAttributesNormal];
        } else {
            _labels[index].text = title;
        }
        if (_textAttributesSelected) {
            _selectedLabels[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                    attributes:_textAttributesSelected];
        } else {
            _selectedLabels[index].text = title;
        }
    }
    if (image) {
        self.internalImages[index] = image;
        _selectedImageViews[index].image = image;
        _imageViews[index].image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index {
    if (index > _numberOfSegments - 1) {
        index = _numberOfSegments - 1;
    }
    return _internalTitles ? _internalTitles[index] : nil;
}

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index {
    if (index > _numberOfSegments - 1) {
        index = _numberOfSegments - 1;
    }
    return _internalImages ? _internalImages[index] : nil;
}

- (void)addSegmentWithTitle:(NSString *)title {
    [self insertSegmentWithTitle:title atIndex:_numberOfSegments];
}

- (void)addSegmentWithImage:(UIImage *)image {
    [self insertSegmentWithImage:image atIndex:_numberOfSegments];
}

- (void)addSegmentWithTitle:(NSString *)title forImage:(UIImage *)image {
    [self insertSegmentWithTitle:title forImage:image atIndex:_numberOfSegments];
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    NSAssert(_internalTitles, @"You should use this method when the content of segment is `NSString` objcet.");
    if (index > _numberOfSegments) {
        index = _numberOfSegments;
    }
    [self.internalTitles insertObject:title atIndex:index];
    _numberOfSegments++;
    [self insertViewWithTitle:title atIndex:index];
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)index {
    NSAssert(_internalImages, @"You should use this method when the content of segment is `UIImage` objcet.");
    if (index > _numberOfSegments) {
        index = _numberOfSegments;
    }
    [self.internalImages insertObject:image atIndex:index];
    _numberOfSegments++;
    [self insertViewWithImage:image atIndex:index];
}

- (void)insertSegmentWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index {
    NSAssert(_internalTitles && _internalImages, @"You should use this method when the content of the segment including `NSString` object and `UIImage` object.");
    if (index > _numberOfSegments) {
        index = _numberOfSegments;
    }
    [self.internalTitles insertObject:title atIndex:index];
    [self.internalImages insertObject:image atIndex:index];
    _numberOfSegments++;
    [self insertViewWithTitle:title forImage:image atIndex:index];
}

- (void)insertViewWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    YULabel *label1 = [self configureBasicLabelWithTitle:title];
    [self.labels insertObject:label1 atIndex:index];
    [_containerView insertSubview:label1 atIndex:index];
    YULabel *label2 = [self configureSelectedLabelWithTitle:title];
    [self.selectedLabels insertObject:label2 atIndex:index];
    [_selectedContainerView insertSubview:label2 atIndex:index];
    
    [self updateConstraintsWithItem:label1 toItem:_containerView atIndex:index];
    [self updateConstraintsWithItem:label2 toItem:_selectedContainerView atIndex:index];
}

- (void)insertViewWithImage:(UIImage *)image atIndex:(NSUInteger)index {
    YUImageView *imageView1 = [[YUImageView alloc] initWithImage:image];
    [self.imageViews insertObject:imageView1 atIndex:index];
    [_containerView insertSubview:imageView1 atIndex:index];
    YUImageView *imageView2 = [[YUImageView alloc] initWithImage:image];
    [self.selectedImageViews insertObject:imageView2 atIndex:index];
    [_selectedContainerView insertSubview:imageView2 atIndex:index];
    
    [self updateConstraintsWithItem:imageView1 toItem:_containerView atIndex:index];
    [self updateConstraintsWithItem:imageView2 toItem:_selectedContainerView atIndex:index];
}

- (void)insertViewWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index {
    YULabel *label = [self configureBasicLabelWithTitle:title];
    [self.labels insertObject:label atIndex:index];
    YUImageView *imageView = [[YUImageView alloc] initWithImage:image];
    [self.imageViews insertObject:imageView atIndex:index];
    YUImageTextView *mixtureView1 = [[YUImageTextView alloc] initWithLabel:label imageView:imageView];
    [_containerView insertSubview:mixtureView1 atIndex:index];
    
    label = [self configureSelectedLabelWithTitle:title];
    [self.selectedLabels insertObject:label atIndex:index];
    imageView = [[YUImageView alloc] initWithImage:image];
    [self.selectedImageViews insertObject:imageView atIndex:index];
    YUImageTextView *mixtureView2 = [[YUImageTextView alloc] initWithLabel:label imageView:imageView];
    [_selectedContainerView insertSubview:mixtureView2 atIndex:index];
    
    [self updateConstraintsWithItem:mixtureView1 toItem:_containerView atIndex:index];
    [self updateConstraintsWithItem:mixtureView2 toItem:_selectedContainerView atIndex:index];
}

- (void)removeAllItems {
    
}

- (void)removeLastItem {
    [self removeItemAtIndex:_numberOfSegments - 1];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    
}

#pragma mark - Views Setup

- (YULabel *)configureBasicLabelWithTitle:(NSString *)title {
    YULabel *label = [[YULabel alloc] init];
    label.text = title;
    label.font = self.font;
    label.textColor = self.textColor;
    return label;
}

- (YULabel *)configureSelectedLabelWithTitle:(NSString *)title {
    YULabel *label = [[YULabel alloc] init];
    label.text = title;
    label.font = self.selectedFont;
    label.textColor = self.selectedTextColor;
    return label;
}

- (void)configureLabels {
    YULabel *label;
    NSString *title;
    for (int i = 0; i < _numberOfSegments; i++) {
        title = _internalTitles[i];
        // Configure basic label
        label = [self configureBasicLabelWithTitle:title];
        [self.labels addObject:label];
        [_containerView addSubview:label];
        // Configure selected label
        label = [self configureSelectedLabelWithTitle:title];
        [self.selectedLabels addObject:label];
        [_selectedContainerView addSubview:label];
    }
    [self setupConstraintsWithSegments:_labels selected:NO];
    [self setupConstraintsWithSegments:_selectedLabels selected:YES];
}

- (void)configureImages {
    YUImageView *imageView;
    UIImage *image;
    for (int i = 0; i < _numberOfSegments; i++) {
        image = _internalImages[i];
        // Configure basic image view
        imageView = [[YUImageView alloc] initWithImage:image];
        [self.imageViews addObject:imageView];
        [_containerView addSubview:imageView];
        // Configure selected image view
        imageView = [[YUImageView alloc] initWithImage:image];
        [self.selectedImageViews addObject:imageView];
        [_selectedContainerView addSubview:imageView];
    }
    [self setupConstraintsWithSegments:_imageViews selected:NO];
    [self setupConstraintsWithSegments:_selectedImageViews selected:YES];
}

- (void)configureMixtureViews {
    NSString *title;
    UIImage *image;
    YULabel *label;
    YUImageView *imageView;
    YUImageTextView *mixtrueView;
    NSMutableArray *array1 = [NSMutableArray array];
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < _numberOfSegments; i++) {
        title = _internalTitles[i];
        image = _internalImages[i];
        // Configure basic mixture view
        label = [self configureBasicLabelWithTitle:title];
        [self.labels addObject:label];
        imageView = [[YUImageView alloc] initWithImage:image];
        [self.imageViews addObject:imageView];
        mixtrueView = [[YUImageTextView alloc] initWithLabel:label imageView:imageView];
        [array1 addObject:mixtrueView];
        [_containerView addSubview:mixtrueView];
        // Configure selected mixture view
        label = [self configureSelectedLabelWithTitle:title];
        [self.selectedLabels addObject:label];
        imageView = [[YUImageView alloc] initWithImage:image];
        [self.selectedImageViews addObject:imageView];
        mixtrueView = [[YUImageTextView alloc] initWithLabel:label imageView:imageView];
        [array2 addObject:mixtrueView];
        [_selectedContainerView addSubview:mixtrueView];
    }
    [self setupConstraintsWithSegments:array1 selected:NO];
    [self setupConstraintsWithSegments:array2 selected:YES];
}

- (void)setupContainerView {
    _containerView = ({
        UIView *containerView = [UIView new];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:containerView];
        
        containerView;
    });
    [self setupConstraintsWithItem:_containerView toItem:self];
}

- (void)setupSelectedContainerView {
    _selectedContainerView = ({
        UIView *containerView = [UIView new];
        containerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:containerView];
        
        containerView;
    });
    [self setupConstraintsWithItem:_selectedContainerView toItem:self];
}

- (void)setupIndicatorView {
    _indicatorView = [[YUIndicatorView alloc] initWithStyle:(YUIndicatorViewStyle)_style];
    [self insertSubview:_indicatorView atIndex:1];
    _selectedContainerView.layer.mask = _indicatorView.maskView.layer;
}

- (void)buildUI {
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    switch (_style) {
        case YUSegmentStyleLine: {
            _indicatorView.backgroundColor = self.backgroundColor;
            break;
        }
        case YUSegmentStyleBox: {
            self.layer.cornerRadius = 5.0;
            _indicatorView.indicatorColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            _indicatorMargin = 3.0;
            _indicatorView.cornerRadius = 5.0;
            break;
        }
    }
}

- (void)configureIndicatorWithBackgroundColor:(UIColor *)color {
    if (![color isEqual:[UIColor clearColor]]) {
        _indicatorView.backgroundColor = color;
    } else {
        _indicatorView.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Views Update

- (void)setTitleTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            for (int i = 0; i < _numberOfSegments; i++) {
                _labels[i].textColor = textColor;
            }
            break;
        case YUSegmentedControlStateSelected:
            for (int i = 0; i < _numberOfSegments; i++) {
                _selectedLabels[i].textColor = textColor;
            }
            break;
    }
}

- (void)setTitleTextFont:(UIFont *)font forState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            for (int i = 0; i < _numberOfSegments; i++) {
                _labels[i].font = font;
            }
            break;
        case YUSegmentedControlStateSelected:
            for (int i = 0; i < _numberOfSegments ; i++) {
                _selectedLabels[i].font = font;
            }
            break;
    }
}

- (void)updateViewHierarchy {
    // Add container to scroll view
    [_containerView removeFromSuperview];
    [self.scrollView addSubview:_containerView];
    [self setupConstraintsToScrollViewWithItem:_containerView];
    
    // Add indicator to scroll view
    [_indicatorView removeFromSuperview];
    [_scrollView addSubview:_indicatorView];
    
    // Add selected container to scroll view
    [_selectedContainerView removeFromSuperview];
    [_scrollView addSubview:_selectedContainerView];
    [self setupConstraintsToScrollViewWithItem:_selectedContainerView];
    
    [self updateWidthConstraintsForSegments];
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state {
    if (!_internalTitles) {
        return;
    }
    NSParameterAssert(attributes);
    switch (state) {
        case YUSegmentedControlStateNormal:
            self.textAttributesNormal = attributes;
            for (int i = 0; i < _numberOfSegments; i++) {
                _labels[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i]
                                                                            attributes:attributes];
            }
            break;
        case YUSegmentedControlStateSelected:
            self.textAttributesSelected = attributes;
            for (int i = 0; i < _numberOfSegments; i++) {
                _selectedLabels[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i]
                                                                                    attributes:attributes];
            }
            break;
    }
}

- (NSDictionary *)titleTextAttributesForState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            return self.textAttributesNormal;
        case YUSegmentedControlStateSelected:
            return self.textAttributesSelected;
    }
}

- (void)makeCurrentSegmentCenterInSelf {
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
    _scrollView.contentOffset = contentOffset;
}

#pragma mark - Event Response

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:_containerView];
    NSUInteger fromIndex = self.selectedIndex;
    _selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:location.x];
    if (fromIndex != _selectedIndex) {
        switch (_style) {
            case YUSegmentStyleLine:
            case YUSegmentStyleBox:
                [self moveIndicatorFromIndex:fromIndex toIndex:_selectedIndex animated:YES];
                break;
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _panCorrection = [gestureRecognizer locationInView:_indicatorView].x - CGRectGetWidth(_indicatorView.frame) / 2;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint panLocation = [gestureRecognizer locationInView:_containerView];
            [self.indicatorView setCenterX:(panLocation.x - _panCorrection)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            CGFloat indicatorCenterX = [_indicatorView getCenterX];
            NSUInteger fromIndex = _selectedIndex;
            _selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:indicatorCenterX];
            [self moveIndicatorFromIndex:fromIndex toIndex:_selectedIndex animated:YES];
        }
        default:
            break;
    }
}

- (NSUInteger)nearestIndexOfSegmentAtXCoordinate:(CGFloat)x {
    NSUInteger index = x / self.segmentWidth;
    return index < _numberOfSegments ? index : _numberOfSegments - 1;
}

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [_indicatorView setCenterX:self.segmentWidth * (0.5 + toIndex)];
        } completion:^(BOOL finished) {
            if (finished) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
                [self makeCurrentSegmentCenterInSelf];
            }
        }];
    }
    else {
        [_indicatorView setCenterX:self.segmentWidth * (0.5 + toIndex)];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        [self makeCurrentSegmentCenterInSelf];
    }
}

#pragma mark -

- (CGFloat)calculateIndicatorWidthPlusConstant {
    CGFloat maxWidth = 0.0;
    CGFloat width;
    if (_internalTitles && _internalImages) {
        maxWidth = _selectedImageViews[0].intrinsicContentSize.width;
        for (YULabel *label in _selectedLabels) {
            width = label.intrinsicContentSize.width;
            if (width > maxWidth) {
                maxWidth = width;
            }
        }
    }
    else if (_internalImages) {
        maxWidth = _selectedImageViews[0].intrinsicContentSize.width;
    }
    else {
        for (YULabel *label in _selectedLabels) {
            width = label.intrinsicContentSize.width;
            if (width > maxWidth) {
                maxWidth = width;
            }
        }
    }
    maxWidth += 32.0;
    CGFloat segmentWidth = self.segmentWidth;
    if (maxWidth > segmentWidth) {
        maxWidth = segmentWidth;
    }
    return maxWidth;
}

#pragma mark - Setters

- (void)setBoxStyle:(BOOL)boxStyle {
    if (boxStyle) {
        [_indicatorView removeFromSuperview];
        [self setupIndicatorView];
    }
}

- (void)setSegmentTitles:(NSString *)titles {
    _internalTitles = [[titles componentsSeparatedByString:@"\n"] mutableCopy];
    _numberOfSegments = [_internalTitles count];
    [self configureLabels];
}

- (void)setSegmentImages:(NSString *)images {
    NSArray *internalImages = [images componentsSeparatedByString:@"\n"];
    _internalImages = [NSMutableArray array];
    for (NSString *name in internalImages) {
        [_internalImages addObject:[UIImage imageNamed:name]];
    }
    _numberOfSegments = [internalImages count];
    if (_internalTitles) {
        for (UIView *view in _containerView.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in _selectedContainerView.subviews) {
            [view removeFromSuperview];
        }
        [self.labels removeAllObjects];
        [self.selectedLabels removeAllObjects];
        [self configureMixtureViews];
    } else {
        [self configureImages];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    _selectedIndex = selectedIndex;
    [_indicatorView setCenterX:self.segmentWidth * (0.5 + selectedIndex)];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    _indicatorView.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setSegmentWidth:(CGFloat)segmentWidth {
    if (segmentWidth < 1.0 || _segmentWidth == segmentWidth) {
        return;
    }
    _segmentWidth = segmentWidth;
    if (_numberOfSegments) {
        [self updateViewHierarchy];
    } else {
        _needsUpdateViewHierarchy = YES;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSAssert(backgroundColor, @"The color should not be nil.");
    [super setBackgroundColor:backgroundColor];
    if (_indicatorView) {
        if (_style == YUSegmentStyleLine) {
            _indicatorView.backgroundColor = backgroundColor;
        }
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    if (!_indicatorView) return;
    NSAssert(indicatorColor, @"The color should not be nil.");
    if (indicatorColor != _indicatorColor && ![indicatorColor isEqual:_indicatorColor]) {
        _indicatorColor = indicatorColor;
        if (_style == YUSegmentStyleBox && [indicatorColor isEqual:[UIColor clearColor]]) {
            indicatorColor = self.backgroundColor;
        }
        _indicatorView.indicatorColor = indicatorColor;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (!_labels) return;
    NSAssert(textColor, @"The color should not be nil.");
    if (textColor != _textColor && ![textColor isEqual:_textColor]) {
        _textColor = textColor;
        [self setTitleTextColor:textColor forState:YUSegmentedControlStateNormal];
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    if (!_selectedLabels) return;
    NSAssert(selectedTextColor, @"The color should not be nil.");
    if (selectedTextColor != _selectedTextColor && ![selectedTextColor isEqual:_selectedTextColor]) {
        _selectedTextColor = selectedTextColor;
        [self setTitleTextColor:selectedTextColor forState:YUSegmentedControlStateSelected];
    }
}

- (void)setFont:(UIFont *)font {
    if (!_labels) return;
    NSAssert(font, @"The font should not be nil.");
    _font = font;
    [self setTitleTextFont:font forState:YUSegmentedControlStateNormal];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    if (!_selectedLabels) return;
    NSAssert(selectedFont, @"The font should not be nil.");
    _selectedFont = selectedFont;
    [self setTitleTextFont:selectedFont forState:YUSegmentedControlStateSelected];
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

- (UIFont *)font {
    if (_font) {
        return _font;
    }
    _font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    return _font;
}

- (UIColor *)textColor {
    if (_textColor) {
        return _textColor;
    }
    if (_style == YUSegmentStyleBox) {
        _textColor = [UIColor blackColor];
    } else {
        _textColor = [UIColor lightGrayColor];
    }
    return _textColor;
}

- (UIFont *)selectedFont {
    if (_selectedFont) {
        return _selectedFont;
    }
    _selectedFont = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    return _selectedFont;
}

- (UIColor *)selectedTextColor {
    if (_selectedTextColor) {
        return _selectedTextColor;
    }
    if (_style == YUSegmentStyleBox) {
        _selectedTextColor = [UIColor whiteColor];
    } else {
        _selectedTextColor = [UIColor blackColor];
    }
    return _selectedTextColor;
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
        
        scrollView;
    });
    [self setupConstraintsWithItem:_scrollView toItem:self];
    
    return _scrollView;
}

- (NSMutableArray <YULabel *> *)labels {
    if (_labels) {
        return _labels;
    }
    _labels = [NSMutableArray array];
    return _labels;
}

- (NSMutableArray <YUImageView *> *)imageViews {
    if (_imageViews) {
        return _imageViews;
    }
    _imageViews = [NSMutableArray array];
    return _imageViews;
}

- (NSMutableArray <YULabel *> *)selectedLabels {
    if (_selectedLabels) {
        return _selectedLabels;
    }
    _selectedLabels = [NSMutableArray array];
    return _selectedLabels;
}

- (NSMutableArray <YUImageView *> *)selectedImageViews {
    if (_selectedImageViews) {
        return _selectedImageViews;
    }
    _selectedImageViews = [NSMutableArray array];
    return _selectedImageViews;
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setupConstraintsWithSegments:(NSArray *)segments selected:(BOOL)selected {
    id lastView;
    id container;
    container = selected ? _selectedContainerView : _containerView;
    for (int i = 0; i < _numberOfSegments; i++) {
        [NSLayoutConstraint constraintWithItem:segments[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeTop multiplier:1.0 constant:8.0].active = YES;
        
        [NSLayoutConstraint constraintWithItem:segments[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8.0].active = YES;
        
        if (lastView) {
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:segments[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
            leading.active = YES;
            leading.identifier = [NSString stringWithFormat:@"%d", i];
            
            [NSLayoutConstraint constraintWithItem:segments[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
        }
        else {
            NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:segments[i] attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:container attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
            leading.active = YES;
            leading.identifier = [NSString stringWithFormat:@"%d", i];
        }
        lastView = segments[i];
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
    id item = _containerView.subviews[0];
    [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_segmentWidth].active = YES;
    item = _selectedContainerView.subviews[0];
    [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:_segmentWidth].active = YES;
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
