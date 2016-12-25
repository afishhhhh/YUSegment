//
//  YUSegment.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegment.h"
#import "YUMixtureView.h"

static const NSTimeInterval kMovingAnimationDuration = 0.3;
static const CGFloat        kIndicatorWidthOffset    = 20.0;

@interface YUSegment ()

/// @name Views

@property (nonatomic, strong) UIView        *containerNormal;
@property (nonatomic, strong) UIView        *containerSelected;
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, assign) BOOL          needsUpdateViewHierarchy;
@property (nonatomic, assign) BOOL          scrollEnabled;

/// @name Constraints

//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsNormal;
//@property (nonatomic, strong) NSMutableArray <NSLayoutConstraint *> *leadingConstraintsSelected;

/// @name Contents

@property (nonatomic, strong) NSMutableArray <NSString *>       *internalTitles;
@property (nonatomic, strong) NSMutableArray <UIImage *>        *internalImages;
@property (nonatomic, strong) NSMutableArray <UILabel *>        *labelsNormal;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageViewsNormal;
@property (nonatomic, strong) NSMutableArray <UILabel *>        *labelsSelected;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageViewsSelected;

/// @name Appearance

@property (nonatomic, copy)   NSDictionary *textAttributesNormal;
@property (nonatomic, copy)   NSDictionary *textAttributesSelected;

@end


@interface YUIndicatorView ()

@property (nonatomic, assign) YUIndicatorViewStyle style;
@property (nonatomic, strong) CALayer              *lineLayer;

- (void)setCenterX:(CGFloat)centerX;
- (void)setWidth:(CGFloat)width;

- (instancetype)initWithStyle:(YUIndicatorViewStyle)style;
- (void)private_setBackgroundColor:(UIColor *)backgroundColor;

@end


@implementation YUSegment {
    CGFloat _segmentWidth;
    UIColor *_textColor;
    UIColor *_selectedTextColor;
    UIFont  *_font;
    UIFont  *_selectedFont;
    CGFloat _panCorrection;
}

@dynamic segmentWidth;
@dynamic textColor;
@dynamic selectedTextColor;
@dynamic font;
@dynamic selectedFont;

#pragma mark - Initialization

//- (void)dealloc {
//    NSLog(@"dealloc");
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
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
        [self commonInit];
        [self configureMixtureViews];
    }
    return self;
}

- (void)commonInit {
    // Set default values.
    _needsUpdateViewHierarchy = NO;
    _scrollEnabled = NO;
    _selectedIndex = 0;
    
    // Setup UI.
    _containerNormal = [self setupContainerView];
    _containerSelected = [self setupContainerView];
    [self setupIndicatorView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
    // Setup box-style UI.
    if (_style == YUSegmentStyleBox) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    [self buildUI];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"Segment layoutSubviews");
    CGFloat segmentWidth = self.segmentWidth;
    switch (_style) {
        case YUSegmentStyleLine: {
            CGFloat indicatorWidth = [self calculateIndicatorWidthAtSegmentIndex:_selectedIndex];
            CGFloat x = segmentWidth * _selectedIndex + (segmentWidth - indicatorWidth) / 2.0;
            _indicator.frame = (CGRect){x, 0, indicatorWidth, CGRectGetHeight(self.frame)};
            break;
        }
        case YUSegmentStyleBox: {
            CGFloat height = CGRectGetHeight(self.frame);
            _indicator.frame = (CGRect){segmentWidth * _selectedIndex, 0, segmentWidth, height};
            self.layer.cornerRadius = height / 2.0;
            _indicator.layer.cornerRadius = height / 2.0;
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
            _labelsNormal[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                            attributes:_textAttributesNormal];
        } else {
            _labelsNormal[index].text = title;
        }
        if (_textAttributesSelected) {
            _labelsSelected[index].attributedText = [[NSAttributedString alloc] initWithString:title
                                                                                    attributes:_textAttributesSelected];
        } else {
            _labelsSelected[index].text = title;
        }
    }
    if (image) {
        self.internalImages[index] = image;
        _imageViewsSelected[index].image = image;
        _imageViewsNormal[index].image = image;
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
    
}

- (void)insertViewWithImage:(UIImage *)image atIndex:(NSUInteger)index {
    
}

- (void)insertViewWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index {
    
}

- (void)removeAllItems {
    
}

- (void)removeLastItem {
    [self removeItemAtIndex:_numberOfSegments - 1];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    
}

#pragma mark - Views Setup

- (UILabel *)configureNormalLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = self.font;
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)configureSelectedLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = self.selectedFont;
    label.textColor = self.selectedTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)configureLabels {
    UILabel *label;
    NSString *title;
    for (int i = 0; i < _numberOfSegments; i++) {
        title = _internalTitles[i];
        
        // Configure normal label
        label = [self configureNormalLabelWithTitle:title];
        [self.labelsNormal addObject:label];
        [_containerNormal addSubview:label];
        
        // Configure selected label
        label = [self configureSelectedLabelWithTitle:title];
        [self.labelsSelected addObject:label];
        [_containerSelected addSubview:label];
    }
    [self setupConstraintsWithSubviewsInContainer:_containerNormal];
    [self setupConstraintsWithSubviewsInContainer:_containerSelected];
}

- (UIImageView *)configureImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    return imageView;
}

- (void)configureImages {
    UIImageView *imageView;
    UIImage *image;
    for (int i = 0; i < _numberOfSegments; i++) {
        image = _internalImages[i];
        
        // Configure normal image view
        imageView = [self configureImageViewWithImage:image];
        [self.imageViewsNormal addObject:imageView];
        [_containerNormal addSubview:imageView];
        
        // Configure selected image view
        imageView = [self configureImageViewWithImage:image];
        [self.imageViewsSelected addObject:imageView];
        [_containerSelected addSubview:imageView];
    }
    [self setupConstraintsWithSubviewsInContainer:_containerNormal];
    [self setupConstraintsWithSubviewsInContainer:_containerSelected];
}

- (void)configureMixtureViews {
    NSString *title;
    UIImage *image;
    UILabel *label;
    UIImageView *imageView;
    YUMixtureView *mixtrueView;
    for (int i = 0; i < _numberOfSegments; i++) {
        title = _internalTitles[i];
        image = _internalImages[i];
        
        // Configure normal mixture view
        label = [self configureNormalLabelWithTitle:title];
        [self.labelsNormal addObject:label];
        imageView = [self configureImageViewWithImage:image];
        [self.imageViewsNormal addObject:imageView];
        mixtrueView = [[YUMixtureView alloc] initWithLabel:label imageView:imageView];
//        [self.mixtureViewsNormal addObject:mixtrueView];
        [_containerNormal addSubview:mixtrueView];
        
        // Configure selected mixture view
        label = [self configureSelectedLabelWithTitle:title];
        [self.labelsSelected addObject:label];
        imageView = [self configureImageViewWithImage:image];
        [self.imageViewsSelected addObject:imageView];
        mixtrueView = [[YUMixtureView alloc] initWithLabel:label imageView:imageView];
//        [self.mixtureViewsSelected addObject:mixtrueView];
        [_containerSelected addSubview:mixtrueView];
    }
    [self setupConstraintsWithSubviewsInContainer:_containerNormal];
    [self setupConstraintsWithSubviewsInContainer:_containerSelected];
}

- (UIView *)setupContainerView {
    UIView *containerView = [UIView new];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:containerView];
    [self setupConstraintsWithItem:containerView toItem:self];
    
    return containerView;
}

- (void)setupIndicatorView {
    _indicator = [[YUIndicatorView alloc] initWithStyle:(YUIndicatorViewStyle)_style];
    [self insertSubview:_indicator atIndex:1];
    _containerSelected.layer.mask = _indicator.maskView.layer;
}

- (void)buildUI {
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        [_indicator private_setBackgroundColor:self.backgroundColor];
    }
    
    switch (_style) {
        case YUSegmentStyleLine: {
            _indicator.backgroundColor = [UIColor orangeColor];
            break;
        }
        case YUSegmentStyleBox: {
            _indicator.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
            break;
        }
    }
}

#pragma mark - Views Update

- (void)setTitleTextColor:(UIColor *)textColor forState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            for (int i = 0; i < _numberOfSegments; i++) {
                _labelsNormal[i].textColor = textColor;
            }
            break;
        case YUSegmentedControlStateSelected:
            for (int i = 0; i < _numberOfSegments; i++) {
                _labelsSelected[i].textColor = textColor;
            }
            break;
    }
}

- (void)setTitleTextFont:(UIFont *)font forState:(YUSegmentedControlState)state {
    switch (state) {
        case YUSegmentedControlStateNormal:
            for (int i = 0; i < _numberOfSegments; i++) {
                _labelsNormal[i].font = font;
            }
            break;
        case YUSegmentedControlStateSelected:
            for (int i = 0; i < _numberOfSegments ; i++) {
                _labelsSelected[i].font = font;
            }
            break;
    }
}

- (void)updateViewHierarchy {
    // Add container to scroll view
    [_containerNormal removeFromSuperview];
    [self.scrollView addSubview:_containerNormal];
    [self setupConstraintsToScrollViewWithItem:_containerNormal];
    
    // Add indicator to scroll view
    [_indicator removeFromSuperview];
    [_scrollView addSubview:_indicator];
    
    // Add selected container to scroll view
    [_containerSelected removeFromSuperview];
    [_scrollView addSubview:_containerSelected];
    [self setupConstraintsToScrollViewWithItem:_containerSelected];
    
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
                _labelsNormal[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i]
                                                                            attributes:attributes];
            }
            break;
        case YUSegmentedControlStateSelected:
            self.textAttributesSelected = attributes;
            for (int i = 0; i < _numberOfSegments; i++) {
                _labelsSelected[i].attributedText = [[NSAttributedString alloc] initWithString:_internalTitles[i]
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

- (void)replaceDeselectedImagesWithImages:(NSArray <UIImage *> *)images {
    NSParameterAssert(images);
    for (int i = 0; i < _numberOfSegments; i++) {
        _imageViewsNormal[i].image = images[i];
    }
}

- (void)replaceDeselectedImageWithImage:(UIImage *)image atIndex:(NSUInteger)index {
    NSParameterAssert(image);
    if (index > _numberOfSegments - 1) {
        index = _numberOfSegments - 1;
    }
    _imageViewsNormal[index].image = image;
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

- (void)makeCurrentSegmentCenterInContainer {
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

#pragma mark - Event Response

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:_containerNormal];
    NSUInteger fromIndex = _selectedIndex;
    _selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:location.x];
    if (fromIndex != _selectedIndex) {
        BOOL change;
        _style == YUSegmentStyleLine ? (change = YES) : (change = NO);
        [self moveIndicatorFromIndex:fromIndex toIndex:_selectedIndex widthShouldChange:change];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _panCorrection = [gestureRecognizer locationInView:_indicator].x - CGRectGetWidth(_indicator.frame) / 2;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint panLocation = [gestureRecognizer locationInView:_containerNormal];
            [self.indicator setCenterX:(panLocation.x - _panCorrection)];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled: {
            CGFloat indicatorCenterX = _indicator.center.x;
            NSUInteger fromIndex = _selectedIndex;
            _selectedIndex = [self nearestIndexOfSegmentAtXCoordinate:indicatorCenterX];
            [self moveIndicatorFromIndex:fromIndex toIndex:_selectedIndex widthShouldChange:NO];
        }
        default:
            break;
    }
}

- (NSUInteger)nearestIndexOfSegmentAtXCoordinate:(CGFloat)x {
    NSUInteger index = x / self.segmentWidth;
    return index < _numberOfSegments ? index : _numberOfSegments - 1;
}

- (void)moveIndicatorFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex widthShouldChange:(BOOL)change {
    CGFloat indicatorWidth;
    if (change) {
        indicatorWidth = [self calculateIndicatorWidthAtSegmentIndex:toIndex];
    }
    [UIView animateWithDuration:kMovingAnimationDuration animations:^{
        if (change) {
            [_indicator setWidth:indicatorWidth];
        }
        [_indicator setCenterX:self.segmentWidth * (0.5 + toIndex)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            if (_scrollEnabled) {
                [self makeCurrentSegmentCenterInContainer];
            }
        }
    }];
}

#pragma mark -

- (CGFloat)calculateIndicatorWidthAtSegmentIndex:(NSUInteger)index {
    CGFloat finalWidth = 0.0;
    CGFloat width;
    if (_internalTitles) {
        finalWidth = _labelsSelected[index].intrinsicContentSize.width;
        if (_internalImages) {
            width = _imageViewsSelected[index].intrinsicContentSize.width;
            if (width > finalWidth) {
                finalWidth = width;
            }
        }
    } else {
        finalWidth = _imageViewsSelected[index].intrinsicContentSize.width;
    }
    finalWidth += kIndicatorWidthOffset;
    CGFloat segmentWidth = self.segmentWidth;
    if (finalWidth > segmentWidth) {
        finalWidth = segmentWidth;
    }
    
    return finalWidth;
}

#pragma mark - Setters

- (void)setBoxStyle:(BOOL)boxStyle {
    if (boxStyle) {
        [_indicator removeFromSuperview];
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
        for (UIView *view in _containerNormal.subviews) {
            [view removeFromSuperview];
        }
        for (UIView *view in _containerSelected.subviews) {
            [view removeFromSuperview];
        }
        [self.labelsNormal removeAllObjects];
        [self.labelsSelected removeAllObjects];
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
    [_indicator setCenterX:self.segmentWidth * (0.5 + selectedIndex)];
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
    if (_indicator) {
        if (_style == YUSegmentStyleLine) {
            [_indicator private_setBackgroundColor:backgroundColor];
        }
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (!_labelsNormal) return;
    NSAssert(textColor, @"The color should not be nil.");
    if (textColor != _textColor && ![textColor isEqual:_textColor]) {
        _textColor = textColor;
        [self setTitleTextColor:textColor forState:YUSegmentedControlStateNormal];
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
    if (!_labelsSelected) return;
    NSAssert(selectedTextColor, @"The color should not be nil.");
    if (selectedTextColor != _selectedTextColor && ![selectedTextColor isEqual:_selectedTextColor]) {
        _selectedTextColor = selectedTextColor;
        [self setTitleTextColor:selectedTextColor forState:YUSegmentedControlStateSelected];
    }
}

- (void)setFont:(UIFont *)font {
    if (!_labelsNormal) return;
    NSAssert(font, @"The font should not be nil.");
    _font = font;
    [self setTitleTextFont:font forState:YUSegmentedControlStateNormal];
}

- (void)setSelectedFont:(UIFont *)selectedFont {
    if (!_labelsSelected) return;
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
        _scrollEnabled = YES;
        
        scrollView;
    });
    [self setupConstraintsWithItem:_scrollView toItem:self];
    
    return _scrollView;
}

- (NSMutableArray <UILabel *> *)labelsNormal {
    if (_labelsNormal) {
        return _labelsNormal;
    }
    _labelsNormal = [NSMutableArray array];
    return _labelsNormal;
}

- (NSMutableArray <UIImageView *> *)imageViewsNormal {
    if (_imageViewsNormal) {
        return _imageViewsNormal;
    }
    _imageViewsNormal = [NSMutableArray array];
    return _imageViewsNormal;
}

- (NSMutableArray <UILabel *> *)labelsSelected {
    if (_labelsSelected) {
        return _labelsSelected;
    }
    _labelsSelected = [NSMutableArray array];
    return _labelsSelected;
}

- (NSMutableArray <UIImageView *> *)imageViewsSelected {
    if (_imageViewsSelected) {
        return _imageViewsSelected;
    }
    _imageViewsSelected = [NSMutableArray array];
    return _imageViewsSelected;
}

#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setupConstraintsWithSubviewsInContainer:(UIView *)container {
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
    item = _containerSelected.subviews[0];
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


@implementation YUIndicatorView

#pragma mark - Initialization

- (instancetype)initWithStyle:(YUIndicatorViewStyle)style {
    self = [super init];
    if (self) {
        _style = style;
        self.maskView = [UIView new];
        self.maskView.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"IndicatorView layoutSubviews");
    self.maskView.frame = self.frame;
    if (_style == YUIndicatorViewStyleLine) {
        self.lineLayer.frame = (CGRect){0, CGRectGetHeight(self.frame) - 2.0, CGRectGetWidth(self.frame), 2.0};
    }
}

#pragma mark -

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    [self setNeedsDisplay];
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

- (void)private_setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

#pragma mark - Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    NSParameterAssert(backgroundColor);
    switch (_style) {
        case YUIndicatorViewStyleLine:
            self.lineLayer.backgroundColor = backgroundColor.CGColor;
            break;
        case YUIndicatorViewStyleBox:
            [super setBackgroundColor:backgroundColor];
            break;
    }
}

#pragma mark - Getters

- (CALayer *)lineLayer {
    if (_lineLayer) {
        return _lineLayer;
    }
    _lineLayer = [CALayer layer];
    [self.layer addSublayer:_lineLayer];
    return _lineLayer;
}

@end
