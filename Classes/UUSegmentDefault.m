//
//  UUSegmentDefault.m
//  Read
//
//  Created by 虞冠群 on 2016/11/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUSegmentDefault.h"
#import "UUSegmentPrivate.h"

static void *UUSegmentDefaultKVODataSourceContext = &UUSegmentDefaultKVODataSourceContext;

@interface UUSegmentDefault ()

/**
 The items showed in segment control, this array could be `NSString`, `UIImage`, custom `UIView`, also could be a mixture of the above elements.
 */
@property (nonatomic, copy)   NSArray                   *segmentItems;

/**
 The amount of the elements in `segmentItems`.
 */
@property (nonatomic, assign) NSUInteger                segments;

@property (nonatomic, strong) UIView                    *containerView;

@property (nonatomic, copy)   NSArray                   *segmentViews;

@end

@implementation UUSegmentDefault

#pragma mark - Initialization

/**
 Creates and returns an instance of UUSegmentDefault with the items.

 @param items The items showed in segment control.
 @return An instance of UUSegmentDefault newly-created.
 */
- (instancetype)initWithItems:(NSArray *)items {
    
    NSAssert((items && [items count]), @"Items can not be empty");
    
    self = [super init];
    if (self) {
        _segmentItems = [items copy];
        _segments = [items count];
        [self setupSegmentViewsByTraversingSegmentItems];
        
        _containerView = [UIView new];
        [self addSubview:_containerView];
        [self setupConstraintsForContainerView];
        
        [self setupConstraintsForSegmentViews];
        
        [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:UUSegmentDefaultKVODataSourceContext];
    }
    return self;
}


#pragma mark - Life Cycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        _containerView.layer.borderWidth = self.borderWidth ?: 0.0;
        _containerView.layer.borderColor = self.borderColor.CGColor ?: [UIColor blackColor].CGColor;
        _containerView.layer.cornerRadius = self.cornerRadius ?: 0.0;
    }
}


#pragma mark - Private Methods

- (void)reloadData {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:setAttributedTextForSegmentUsingCurrentText:)]) {
        [self updateAttributedTextForSegmentView];
    }
}


#pragma mark - Views Setup

/**
 Setup views for each item and insert into `segmentViews`.
 Called in the initialization method `-initWithItmes:`.
 */
- (void)setupSegmentViewsByTraversingSegmentItems {
    NSMutableArray *l_segmentViews = [NSMutableArray array];
    for (id item in _segmentItems) {
        UIView *segmentView = [self createSegmentViewsWithItem:item];
        [l_segmentViews addObject:segmentView];
    }
    self.segmentViews = [l_segmentViews copy];
}

/**
 Creates and returns the view and its subviews for each item.
 Called in `-setupSegmentViewsByTraversingSegmentItems`.

 @param item The data type of item could be `NSString`, `UIImage` and `UIView`.
 @return A newly-created view configured completely.
 */
- (UIView *)createSegmentViewsWithItem:(id)item {
    
    UIView *segmentView = [UIView new];
    UIView *innerView;

    if ([item isKindOfClass:[NSString class]]) {
        UILabel *label = ({
            UILabel *label = [UILabel new];
            label.font = self.fontConverted;
            label.text = item;
            label.textColor = self.textColor;
            label.textAlignment = NSTextAlignmentCenter;
            
            label;
        });
        innerView = label;
    }
    else if ([item isKindOfClass:[UIImage class]]) {
        UIImageView *imageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:item];
            
            imageView;
        });
        innerView = imageView;
    }
    else if ([item isKindOfClass:[UIView class]]) {
        
    }
    else {
        // 不是以上类型
    }

    [segmentView addSubview:innerView];
    [self setupConstraintsForInnerView:innerView inSegmentView:segmentView];
    
    return segmentView;
}


#pragma mark - Views Update

- (void)resetItemWithText:(NSString *)text forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index could not beyond the range of array");
    
    NSMutableArray *array = [self.segmentItems mutableCopy];
    array[index] = text;
    self.segmentItems = [array copy];
}

- (void)resetItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index {
    NSAssert(index < _segments, @"Index could not beyond the range of array");
    
    [self updateAttributedText:attributedText ForSegmentViewAtIndex:index];
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

- (void)updateAttributedText:(NSAttributedString *)attributedText ForSegmentViewAtIndex:(NSUInteger)index {
    UIView *segmentView = _segmentViews[index];
    UILabel *label = segmentView.subviews.firstObject;
    label.attributedText = attributedText;
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
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Constraints

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


#pragma mark - Getters & Setters

@end
