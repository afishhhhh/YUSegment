//
//  YUSegment+Internal.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#ifndef YUSegment_Internal_h
#define YUSegment_Internal_h

static const NSTimeInterval kMovingAnimationDuration = 0.3;
static const CGFloat        kEachSegmentDefaultMargin = 32.0;

NS_ASSUME_NONNULL_BEGIN

@interface YUIndicatorView ()

- (void)setCenterX:(CGFloat)centerX;

@end

@interface YUSegment ()

/// @name Views

@property (nonatomic, strong) UIView *containerNormal;
@property (nonatomic, strong) UIView *containerSelected;

@property (nonatomic, strong) NSMutableArray <UILabel *>        *labelsSelected;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageViewsSelected;

@property (nonatomic, strong) NSMutableArray <NSString *>       *internalTitles;
@property (nonatomic, strong) NSMutableArray <UIImage *>        *internalImages;
@property (nonatomic, strong) NSMutableArray <UIImage *>        *unselectImages;
@property (nonatomic, strong) NSMutableArray <UILabel *>        *labelsNormal;
@property (nonatomic, strong) NSMutableArray <UIImageView *>    *imageViewsNormal;

@property (nonatomic, strong)   NSMutableDictionary  *textAttributesNormal;
@property (nonatomic, strong)   NSMutableDictionary  *textAttributesSelected;

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images unselectedImages:(nullable NSArray <UIImage *> *)unselectedImages;
- (void)makeContainerUsable;
- (void)addLabels;
- (void)addImageViews;
- (void)makeSegmentCenterIfNeeded;

@end

NS_ASSUME_NONNULL_END

#endif /* YUSegment_Internal_h */
