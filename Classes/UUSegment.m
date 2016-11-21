//
//  RDYSegmentedControl.m
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUSegment.h"
#import "UUSegmentView.h"
#import "UULabel.h"

static void *UUSegmentDefaultKVODataSourceContext = &UUSegmentDefaultKVODataSourceContext;
static void *UUSegmentDefaultKVOFontConvertedContext = &UUSegmentDefaultKVOFontConvertedContext;
static void *UUSegmentDefaultKVOTextColorContext = &UUSegmentDefaultKVOTextColorContext;

@interface UUSegment ()

///-----------------
/// @name Appearence
///-----------------

@property (nonatomic, strong) UIFont *fontConverted;

///---------
/// @name UI
///---------

@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, strong) UIScrollView  *scrollView;

///-----------------------
/// @name Segment Elements
///-----------------------

@property (nonatomic, strong) NSMutableArray                    *segmentItems;
@property (nonatomic, assign) NSUInteger                        segments;
@property (nonatomic, strong) NSMutableArray <UUSegmentView *>  *segmentViews;

///--------------------
/// @name Mapping Table
///--------------------

@property (nonatomic, strong) NSMutableArray <UULabel *>        *labelTable;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageTable;
@property (nonatomic, strong) NSMutableArray <UIView *>         *viewTable;

@property (nonatomic, assign, getter = isDataSourceNil) BOOL dataSourceNil;

@end

@implementation UUSegment

@dynamic font;

#pragma mark - Initialization

- (instancetype)initWithItems:(NSArray *)items {
    
    NSAssert((items && [items count]), @"Items can not be empty");
    
    self = [super init];
    if (self) {
        _segmentItems = [items mutableCopy];
        _segments = [items count];
        [self setupSegmentViewsByTraversingSegmentItems];
        
        _containerView = [UIView new];
        [self addSubview:_containerView];
        [self setupConstraintsForContainerView];
        
        [self setupConstraintsForSegmentViews];
        
        [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:UUSegmentDefaultKVODataSourceContext];
        [self addObserver:self forKeyPath:@"fontConverted" options:NSKeyValueObservingOptionNew context:UUSegmentDefaultKVOFontConvertedContext];
        [self addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew context:UUSegmentDefaultKVOTextColorContext];
    }
    return self;
}


#pragma mark - Views Setup

- (void)setupSegmentViewsByTraversingSegmentItems {

    UUSegmentView *segmentView;
    
    for (id item in _segmentItems) {
        
        if ([item isKindOfClass:[NSString class]]) {
            segmentView = [self setupSegmentViewsWithString:(NSString *)item];
        }
        else if ([item isKindOfClass:[UIImage class]]) {
            segmentView = [self setupSegmentViewsWithImage:(UIImage *)item];
        }
        else if ([item isKindOfClass:[UIView class]]) {
            segmentView = [self setupSegmentViewsWithView:(UIView *)item];
        }
        else {
            @throw [NSException exceptionWithName:@"Exception!" reason:@"You should use the item whose class is not include in NSString, UIImage and UIView." userInfo:nil];
        }
        [self.segmentViews addObject:segmentView];
    }
}

- (UUSegmentView *)setupSegmentViewsWithString:(NSString *)string {
    
    UUSegmentView *segmentView = [UUSegmentView new];
    UULabel *label = [[UULabel alloc] initWithText:string];
    
    [segmentView addSubview:label];
    [self.labelTable addObject:label];
    
    segmentView.mappingTo = UUSegmentViewMappingTableLabel;
    segmentView.indexInTable = [_labelTable count] - 1;
    
    [self setupConstraintsForInnerView:label inSegmentView:segmentView];
    
    return segmentView;
}

- (UUSegmentView *)setupSegmentViewsWithImage:(UIImage *)image {
    
    UUSegmentView *segmentView = [UUSegmentView new];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [segmentView addSubview:imageView];
    [self.imageTable addObject:imageView];
    
    segmentView.mappingTo = UUSegmentViewMappingTableImage;
    segmentView.indexInTable = [_imageTable count] - 1;
    
    [self setupConstraintsForInnerView:imageView inSegmentView:segmentView];
    
    return segmentView;
}

- (UUSegmentView *)setupSegmentViewsWithView:(UIView *)view {
    
    UUSegmentView *segmentView = [UUSegmentView new];
    
    [segmentView addSubview:view];
    [self.viewTable addObject:view];
    
    segmentView.mappingTo = UUSegmentViewMappingTableView;
    segmentView.indexInTable = [_viewTable count] - 1;
    
    [self setupConstraintsForInnerView:view inSegmentView:segmentView];
    
    return segmentView;
}


#pragma mark - Views Update

- (void)setItemWithText:(NSString *)text forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index should in the range of 0...%lu", _segments);
    
    [self updateItem:text forSegmentItemsAtIndex:index];
    [self updateText:text forSegmentViewAtIndex:index];
}

- (void)setItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index should in the range of 0...%lu", _segments);
    
    [self updateAttributedText:attributedText forSegmentViewAtIndex:index];
}

- (void)setItemWithImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index should in the range of 0...%lu", _segments);
    
    [self updateItem:image forSegmentItemsAtIndex:index];
    [self updateImage:image forSegmentViewAtIndex:index];
}

- (void)setItemWithView:(UIView *)view forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index should in the range of 0...%lu", _segments);
    
}

- (void)updateItem:(id)item forSegmentItemsAtIndex:(NSUInteger)index {
    self.segmentItems[index] = item;
}

/**
 Update the text for segment in a particular location of the segment.
 You should use this method to update text if you just use the `text` property of label, not the `attributedText` property.
 
 @param newText The new text will be assigned to the `text` property.
 @param index The particular location to update.
 */
- (void)updateText:(NSString *)newText forSegmentViewAtIndex:(NSUInteger)index {
    
    UUSegmentView *oldSegmentView = _segmentViews[index];
    
    switch (oldSegmentView.mappingTo) {
        case UUSegmentViewMappingTableLabel: {
            UULabel *label = _labelTable[oldSegmentView.indexInTable];
            label.text = newText;
            break;
        }
        case UUSegmentViewMappingTableImage: {
            // If the `segmentView` mapping to `imageTable`, remove it from `imageTable` at first.
            // Sencondly, create a new label added to `labelTable`, mapping the `segmentView` to `labelTable` at the same time.
            // Finally, assign the new value to the particular location of the `segmentViews`.
            [self.imageTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithString:newText];
            self.segmentViews[index] = newSegmentView;
            break;
        }
        case UUSegmentViewMappingTableView: {
            [self.viewTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithString:newText];
            self.segmentViews[index] = newSegmentView;
            break;
        }
    }
}

/**
 Update the attributed text for segment.
 When you assign the value to `dataSource` is not nil, and the `dataSource` could respond the method, invoked.
 */
- (void)updateAttributedTextForSegmentView {
    [_segmentViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = obj.subviews.firstObject;
        label.attributedText = [self dataSourceRespondsSelectorUsingCurrentText:label.text atIndex:idx];
    }];
}

/**
 Update the attributed text for segment in a particular location of the segment.
 You should use this method to update text if you just use the `attributedText` property of label, not the `text` property.
 
 @param newAttributedText The new attributed text will be assigned to the `attributedText` property.
 @param index The particular location to update.
 */
- (void)updateAttributedText:(NSAttributedString *)newAttributedText forSegmentViewAtIndex:(NSUInteger)index {
    UIView *segmentView = _segmentViews[index];
    UILabel *label = segmentView.subviews.firstObject;
    label.attributedText = newAttributedText;
}

/**
 Update the image for segment in a particular location of the segment.
 
 @param newImage The new image will be assigned to the `image` property.
 @param index The particular location to update.
 */
- (void)updateImage:(UIImage *)newImage forSegmentViewAtIndex:(NSUInteger)index {
    
    UUSegmentView *oldSegmentView = _segmentViews[index];
    
    switch (oldSegmentView.mappingTo) {
        case UUSegmentViewMappingTableLabel: {
            [self.labelTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithImage:newImage];
            self.segmentViews[index] = newSegmentView;
            break;
        }
        case UUSegmentViewMappingTableImage: {
            UIImageView *imageView = _imageTable[oldSegmentView.indexInTable];
            imageView.image = newImage;
            break;
        }
        case UUSegmentViewMappingTableView: {
            [self.viewTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithImage:newImage];
            self.segmentViews[index] = newSegmentView;
            break;
        }
    }
}

/**
 Update the custom view for segment in a particular location of the segment.

 @param newView The new custom view.
 @param index The particular location to update.
 */
- (void)updateView:(UIView *)newView forSegmentViewAtIndex:(NSUInteger)index {
    
    UUSegmentView *oldSegmentView = _segmentViews[index];
    
    switch (oldSegmentView.mappingTo) {
        case UUSegmentViewMappingTableLabel: {
            [self.labelTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithView:newView];
            self.segmentViews[index] = newSegmentView;
            break;
        }
        case UUSegmentViewMappingTableImage: {
            [self.imageTable removeObjectAtIndex:oldSegmentView.indexInTable];
            UUSegmentView *newSegmentView = [self setupSegmentViewsWithView:newView];
            self.segmentViews[index] = newSegmentView;
            break;
        }
        case UUSegmentViewMappingTableView: {
            
        }
    }
}

- (void)updateFontOfTextForSegmentView {
    for (UULabel *label in _labelTable) {
        label.font = self.fontConverted;
    }
}

- (void)updateColorOfTextForSegmentView {
    for (UULabel *label in _labelTable) {
        label.textColor = self.textColor;
    }
}


#pragma mark - Private Methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:setAttributedTextForSegmentUsingCurrentText:)]) {
        [self updateAttributedTextForSegmentView];
    }
}


#pragma mark - DataSource

/**
 Creates and returns the attributed text using the current text.
 The newly-created attributed text is created and returned by the object which adopts the `UUSegmentDataSource` protocol.
 
 @param text The current text which assigned in `segmentItems`.
 @param index The index in the `segmentItems`.
 @return The newly-created attributed text which will be assigned to label.
 */
- (NSAttributedString *)dataSourceRespondsSelectorUsingCurrentText:(NSString *)text atIndex:(NSUInteger)index {
    return [self.dataSource segmentControl:self setAttributedTextForSegmentUsingCurrentText:text];
}


#pragma mark - Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == UUSegmentDefaultKVODataSourceContext) {
        if (change[NSKeyValueChangeNewKey] != [NSNull null]) {
            [self reloadData];
        }
    }
    else if (context == UUSegmentDefaultKVOFontConvertedContext) {
        if (change[NSKeyValueChangeNewKey] != [NSNull null]) {
            [self updateFontOfTextForSegmentView];
        }
    }
    else if (context == UUSegmentDefaultKVOTextColorContext) {
        [self updateColorOfTextForSegmentView];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Constraints

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)setupConstraintsForInnerView:(UIView *)innerView inSegmentView:(UIView *)view {
    
    innerView.translatesAutoresizingMaskIntoConstraints = NO;
    
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

- (void)setupConstraintsForContainerView {
    
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
    
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

- (void)setupConstraintsForSegmentViews {
    
    UIView *lastView;
    
    for (UIView *view in _segmentViews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_containerView addSubview:view];
        
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
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:lastView
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                          constant:8.0
             ].active = YES;
            
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
            [NSLayoutConstraint constraintWithItem:view
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:_containerView
                                         attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                          constant:16.0
             ].active = YES;
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
                                  constant:16.0
     ].active = YES;
}

- (void)setupScrollViewConstraints {
    
    // scrollView edge equal to containerView
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
}

//- (void)setupContainerViewConstraints {
//    
//    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    // containerView height equal to scrollView
//    [NSLayoutConstraint constraintWithItem:_containerView
//                                 attribute:NSLayoutAttributeHeight
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:_scrollView
//                                 attribute:NSLayoutAttributeHeight
//                                multiplier:1.0
//                                  constant:0.0
//     ].active = YES;
//}


#pragma mark - Getters & Setters

- (void)setFont:(UUFont)font {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:setAttributedTextForSegmentUsingCurrentText:)]) {
        return;
    }
    
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
    
    self.fontConverted = [UIFont systemFontOfSize:fontSize weight:fontWeight];
}

@end
