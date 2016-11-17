//
//  UUSegmentTabbed.m
//  Read
//
//  Created by 虞冠群 on 2016/11/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUSegmentTabbed.h"
#import "UUSegmentPrivate.h"

@interface UUSegmentTabbed ()

@property (nonatomic, strong) UIView                    *containerView;

@property (nonatomic, strong) UIScrollView              *scrollView;

@end

@implementation UUSegmentTabbed

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            [self addSubview:scrollView];
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.pagingEnabled = NO;
            
            scrollView;
        });
        
        _containerView = [UIView new];
        [_scrollView addSubview:_containerView];
        
        [self setupScrollViewConstraints];
        [self setupContainerViewConstraints];
    }
    return self;
}


#pragma mark - Views

- (void)setupScrollViewContentView {
    
}

- (void)setupSegmentViewConstraintsInScrollView {
    
}


#pragma mark - Constraints

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

- (void)setupContainerViewConstraints {
    
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // containerView height equal to scrollView
    [NSLayoutConstraint constraintWithItem:_containerView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_scrollView
                                 attribute:NSLayoutAttributeHeight
                                multiplier:1.0
                                  constant:0.0
     ].active = YES;
}

@end
