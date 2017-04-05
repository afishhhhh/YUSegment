//
//  YUSegment
//  Created by afishhhhh on 2017/3/25.
//  Copyright © 2017年 Yu Guanqun. All rights reserved.
//

#import "YUSegmentedControl.h"
#import "YUSegmentedControlItem.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

typedef YUSegmentedControlItem Item;

typedef NS_ENUM(NSUInteger, YUSegmentedControlContentType) {
    YUSegmentedControlContentTypeText,
    YUSegmentedControlContentTypeImage,
};

static const NSTimeInterval kAnimationDuration = 0.5;
static const CGFloat        kSeparatorDefaultHeight = 1.0;
static const CGFloat        kIndicatorDefaultHeight = 3.0;

@interface YUSegmentedControl ()

@property (nonatomic, weak) UIView *contentContainer;
@property (nonatomic, weak) CALayer *separatorTop;
@property (nonatomic, weak) CALayer *separatorBottom;
@property (nonatomic, strong, readwrite) YUSegmentedControlIndicator *indicator;

@property (nonatomic, copy) NSDictionary *attributesNormal;
@property (nonatomic, copy) NSDictionary *attributesSelected;

@property (nonatomic, assign) YUSegmentedControlContentType contentType;
@property (nonatomic, copy) NSArray *contents;              // text or images as content
@property (nonatomic, copy) NSArray <UIImage *> *selectedImages;
@property (nonatomic, strong) NSMutableArray <Item *> *items;        // labels or imageViews as elements

@end

@implementation YUSegmentedControl

#pragma mark - Initialization

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self copyTitles:titles];
        _contentType = YUSegmentedControlContentTypeText;
        _attributesNormal = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight],
                              NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        _attributesSelected = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight],
                                NSForegroundColorAttributeName: [UIColor blackColor]};
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images {
    return [self initWithImages:images selectedImages:nil];
}

- (instancetype)initWithImages:(NSArray <UIImage *> *)images
                selectedImages:(NSArray <UIImage *> *)selectedImages {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _contents = [images copy];
        _contentType = YUSegmentedControlContentTypeImage;
        if (selectedImages) {
            NSAssert([images count] == [selectedImages count], @"[YUSegment]: ERROR the count of parameter images is not equal to the count of parameter selectedImages.");
            _selectedImages = [selectedImages copy];
        }
        
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.backgroundColor = [UIColor whiteColor];
    self.showsTopSeparator = YES;
    self.showsBottomSeparator = YES;
    self.showsIndicator = YES;
    _showsVerticalDivider = NO;
    _selectedSegmentIndex = 0;
    _horizontalPadding = 0.0;
    _numberOfSegments = [_contents count];
    _items = [NSMutableArray array];
    
    // setup views
    [self setupViews];
    
    // Setup gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_contentContainer addGestureRecognizer:tap];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // separator
    if (_showsTopSeparator) {
        CGRect frame = (CGRect){0, 0, CGRectGetWidth(self.bounds), kSeparatorDefaultHeight};
        _separatorTop.frame = frame;
    }
    if (_showsBottomSeparator) {
        CGRect frame = (CGRect){0, CGRectGetHeight(self.bounds) - kSeparatorDefaultHeight, CGRectGetWidth(self.bounds), kSeparatorDefaultHeight};
        _separatorBottom.frame = frame;
    }
    
    // indicator
    if (!_indicator) {
        return;
    }
    CGFloat y;
    CGFloat width = (CGRectGetWidth(self.bounds) - 2 * _horizontalPadding) / _numberOfSegments;
    CGFloat height = _indicator.height;
    switch (_indicator.locate) {
        case YUSegmentedControlIndicatorLocateBottom: {
            y = CGRectGetHeight(self.bounds) - height;
            if (_showsBottomSeparator) y -= kSeparatorDefaultHeight;
            CGRect frame = (CGRect){_horizontalPadding + width * _selectedSegmentIndex, y, width, height};
            _indicator.frame = frame;
            break;
        }
        case YUSegmentedControlIndicatorLocateTop: {
            y = 0;
            if (_showsTopSeparator) y += kSeparatorDefaultHeight;
            CGRect frame = (CGRect){_horizontalPadding + width * _selectedSegmentIndex, y, width, height};
            _indicator.frame = frame;
            break;
        }
    }
    
}

#pragma mark - Private

- (void)copyTitles:(NSArray <NSString *> *)titles {
    NSMutableArray *contents = [NSMutableArray array];
    for (NSString *title in titles) {
        [contents addObject:[title copy]];
    }
    self.contents = contents;
}

- (void)segmentDidSelectAtIndex:(NSUInteger)newIndex didDeselectAtIndex:(NSUInteger)oldIndex {
    
    // update UI
    if (_contentType == YUSegmentedControlContentTypeText) {
        UILabel *selectedLabel = (UILabel *)(_items[newIndex].view);
        selectedLabel.attributedText = [[NSAttributedString alloc] initWithString:_contents[newIndex] attributes:_attributesSelected];
        
        UILabel *deselectedLabel = (UILabel *)(_items[oldIndex].view);
        deselectedLabel.attributedText = [[NSAttributedString alloc] initWithString:_contents[oldIndex] attributes:_attributesNormal];
    }
    else {
        if (_selectedImages) {
            UIImageView *selectedImageView = (UIImageView *)(_items[newIndex].view);
            selectedImageView.image = _selectedImages[newIndex];
            UIImageView *deselectedImageView = (UIImageView *)(_items[oldIndex].view);
            deselectedImageView.image = _contents[oldIndex];
        }
    }
    // animation
    [self moveIndicatorFromIndex:oldIndex toIndex:newIndex];
}

- (void)moveIndicatorFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    
//    CABasicAnimation *animation;
//    CGPoint position = _indicator.position;
//    CGFloat position_x = position.x + CGRectGetWidth(_indicator.bounds) * (toIndex - fromIndex);
//    position.x = position_x;
//
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
//        animation = [CASpringAnimation animationWithKeyPath:@"position.x"];
//    } else {
//        animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
//    }
//    animation.toValue = [NSValue valueWithCGPoint:position];
//    animation.duration = 0.25;
    
    // indicator animate
    CGRect frame = _indicator.frame;
    frame.origin.x += CGRectGetWidth(_indicator.bounds) * (toIndex - fromIndex);
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
         usingSpringWithDamping:0.66
          initialSpringVelocity:3.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _indicator.frame = frame;
        
    } completion:^(BOOL finished) {
        if (finished) {
            _selectedSegmentIndex = toIndex;
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }];
}

#pragma mark - 

- (NSString *)titleAtIndex:(NSUInteger)index {
    if (_contentType == YUSegmentedControlContentTypeImage) {
        NSLog(@"[YUSegment]: WARN use -imageAtIndex: instead.");
        return nil;
    } else {
        NSAssert(index < _numberOfSegments, @"[YUSegment]: ERROR Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
        return (NSString *)_contents[index];
    }
}

- (UIImage *)imageAtIndex:(NSUInteger)index {
    if (_contentType == YUSegmentedControlContentTypeText) {
        NSLog(@"[YUSegment]: WARN use -titleAtIndex: instead.");
        return nil;
    } else {
        NSAssert(index < _numberOfSegments, @"[YUSegment]: ERROR Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
        return (UIImage *)_contents[index];
    }
}

- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index {
    if (_contentType == YUSegmentedControlContentTypeImage) {
        NSLog(@"[YUSegment]: WARN use setImage:atIndex: instead.");
        return;
    }
    NSAssert(title, @"[YUSegment]: ERROR Title cannot be nil.");
    NSAssert(index < _numberOfSegments, @"[YUSegment]: ERROR Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");
    
    // update contents
    NSMutableArray *contents = [_contents mutableCopy];
    contents[index] = [title copy];
    self.contents = contents;
    
    // update UI
    UILabel *label = (UILabel *)(_items[index].view);
    NSMutableAttributedString *string = [label.attributedText mutableCopy];
    [string.mutableString setString:title];
    label.attributedText = string;
}

- (void)setImage:(UIImage *)image atIndex:(NSUInteger)index {
    [self setImage:image selectedImage:nil atIndex:index];
}

- (void)setImage:(UIImage *)image selectedImage:(UIImage *)selectedImage atIndex:(NSUInteger)index {
    if (_contentType == YUSegmentedControlContentTypeText) {
        NSLog(@"[YUSegment]: WARN use setTitle:atIndex: instead.");
        return;
    }
    NSAssert(image, @"[YUSegment]: ERROR image cannot be nil.");
    NSAssert(index < _numberOfSegments, @"[YUSegment]: ERROR Index must be a number between 0 and the number of segments (numberOfSegments) minus 1.");

    NSMutableArray *contents = [_contents mutableCopy];
    contents[index] = image;
    self.contents = contents;
    
    UIImageView *imageView = (UIImageView *)(_items[index].view);
    
    if (selectedImage) {
        NSMutableArray *selectedImages = [_selectedImages mutableCopy];
        selectedImages[index] = selectedImage;
        self.selectedImages = selectedImages;
        
        if (_selectedSegmentIndex == index) {
            imageView.image = selectedImage;
        } else {
            imageView.image = image;
        }
    }
    else {
        imageView.image = image;
    }
}

- (void)setTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    if (state == UIControlStateNormal) {
        self.attributesNormal = attributes;
    } else {
        self.attributesSelected = attributes;
    }
}

- (void)showBadgeAtIndexes:(NSArray <NSNumber *> *)indexes {
    for (NSNumber *value in indexes) {
        NSUInteger index = [value unsignedLongValue];
        if (index >= _numberOfSegments) continue;
        [_items[index] showBadge];
    }
}

- (void)hideBadgeAtIndex:(NSUInteger)index {
    if (index < _numberOfSegments) {
        [_items[index] hideBadge];
    }
}

#pragma mark - Event Response

- (void)tap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint location = [gestureRecognizer locationInView:_contentContainer];
    location.y = CGRectGetHeight(self.bounds) / 2;
    UIView *hitView = [_contentContainer hitTest:location withEvent:nil];
    NSUInteger toIndex = [_contentContainer.subviews indexOfObject:hitView];
    if (toIndex != NSNotFound) {
        if (_selectedSegmentIndex != toIndex) {
            [self segmentDidSelectAtIndex:toIndex didDeselectAtIndex:_selectedSegmentIndex];
        }
    }
}

#pragma mark - Draw

- (void)drawRect:(CGRect)rect {
    
    if (_contentType == YUSegmentedControlContentTypeText) {
        for (int i = 0; i < _numberOfSegments; i++) {
            UILabel *label = (UILabel *)(_items[i].view);
            if (i == _selectedSegmentIndex) {
                label.attributedText = [[NSAttributedString alloc] initWithString:_contents[i] attributes:_attributesSelected];
            } else {
                label.attributedText = [[NSAttributedString alloc] initWithString:_contents[i] attributes:_attributesNormal];
            }
        }
    }
    else {
        if (_selectedImages) {
            UIImageView *imageView = (UIImageView *)(_items[_selectedSegmentIndex].view);
            imageView.image = _selectedImages[_selectedSegmentIndex];
        }
    }
}

#pragma mark - Setter

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

- (void)setShowsVerticalDivider:(BOOL)showsVerticalDivider {
    
    if (_showsVerticalDivider != showsVerticalDivider) {
        _showsVerticalDivider = showsVerticalDivider;
        
        // update divider
        if (showsVerticalDivider) {
            for (int i = 1; i < _numberOfSegments; i++) {
                [_items[i] showVerticalDivider];
            }
        }
        else {
            for (int i = 1; i < _numberOfSegments; i++) {
                [_items[i] hideVerticalDivider];
            }
        }
    }
}

- (void)setShowsTopSeparator:(BOOL)showsTopSeparator {
    
    if (_showsTopSeparator != showsTopSeparator) {
        _showsTopSeparator = showsTopSeparator;
        
        // setup separator top
        if (showsTopSeparator) {
            CALayer *separatorTop = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:231.0 / 255 green:231.0 / 255 blue:231.0 / 255 alpha:1.0].CGColor;
                [self.layer addSublayer:layer];
                
                layer;
            });
            self.separatorTop = separatorTop;
            [self setNeedsLayout];
        } else {
            if (_separatorTop) {
                [_separatorTop removeFromSuperlayer];
            }
        }
    }
}

- (void)setShowsBottomSeparator:(BOOL)showsBottomSeparator {
    
    if (_showsBottomSeparator != showsBottomSeparator) {
        _showsBottomSeparator = showsBottomSeparator;
        
        // setup separator bottom
        if (showsBottomSeparator) {
            CALayer *separatorBottom = ({
                CALayer *layer = [CALayer layer];
                layer.backgroundColor = [UIColor colorWithRed:231.0 / 255 green:231.0 / 255 blue:231.0 / 255 alpha:1.0].CGColor;
                [self.layer addSublayer:layer];
                
                layer;
            });
            self.separatorBottom = separatorBottom;
            [self setNeedsLayout];
        } else {
            if (_separatorBottom) {
                [_separatorBottom removeFromSuperlayer];
            }
        }
    }
}

- (void)setShowsIndicator:(BOOL)showsIndicator {
    
    if (_showsIndicator != showsIndicator) {
        _showsIndicator = showsIndicator;
        
        // setup indicator
        if (showsIndicator) {
            _indicator = ({
                YUSegmentedControlIndicator *indicator = [YUSegmentedControlIndicator new];
                indicator.backgroundColor = [UIColor darkGrayColor];
                indicator.height = kIndicatorDefaultHeight;
                indicator.locate = YUSegmentedControlIndicatorLocateBottom;
                [self addSubview:indicator];
                
                indicator;
            });
            [self setNeedsLayout];
        } else {
            if (_indicator) {
                [_indicator removeFromSuperview];
                _indicator = nil;
            }
        }
    }
}

- (void)setHorizontalPadding:(CGFloat)horizontalPadding {
    _horizontalPadding = horizontalPadding;
    // update constraints
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeading ||
            constraint.firstAttribute == NSLayoutAttributeTrailing) {
            constraint.constant = horizontalPadding;
        }
    }
}

#pragma mark - Getter

- (YUSegmentedControlIndicator *)indicator {
    if (_indicator) {
        return _indicator;
    }
    NSLog(@"[YUSegment]: WARN indicator is nil.");
    
    return nil;
}

#pragma mark - Setup views

- (void)setupViews {
    
    // prepare content views
    if (_contentType == YUSegmentedControlContentTypeText) {
        // content of segmented control is text
        for (int i = 0; i < _numberOfSegments; i++) {
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentCenter;
            label.translatesAutoresizingMaskIntoConstraints = NO;
//            label.userInteractionEnabled = YES;
            [_items addObject:[[Item alloc] initWithView:label]];
        }
    }
    else {
        // content of segmented control is image
        for (int i = 0; i < _numberOfSegments; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:_contents[i]];
            imageView.contentMode = UIViewContentModeCenter;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
//            imageView.userInteractionEnabled = YES;
            [_items addObject:[[Item alloc] initWithView:imageView]];
        }
    }
    
    // setup container
    UIView *container = ({
        UIView *container = [UIView new];
        container.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:container];
        
        // layout view
        NSDictionary *views = @{@"container": container};
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container]|" options:0 metrics:nil views:views]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|" options:0 metrics:nil views:views]];
        
        container;
    });
    self.contentContainer = container;
    
    // setup segment views
    id lastView;
    for (int i = 0; i < _numberOfSegments; i++) {
        Item *view = _items[i];
        [_contentContainer addSubview:view];
        
        [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentContainer attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0].active = YES;
        
        if (lastView) {
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
            
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0].active = YES;
        }
        else {
            [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_contentContainer attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0].active = YES;
        }
        lastView = view;
    }
    [NSLayoutConstraint constraintWithItem:_contentContainer attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0].active = YES;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end


@implementation YUSegmentedControlIndicator

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}

@end

