//
//  YUSegment
//  Created by afishhhhh on 2017/3/25.
//  Copyright © 2017年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YUSegmentedControlIndicator;

typedef NS_ENUM(NSUInteger, YUSegmentedControlState) {
    YUSegmentedControlStateNormal,
    YUSegmentedControlStateSelected,
};

typedef NS_ENUM(NSUInteger, YUSegmentedControlIndicatorLocate) {
    YUSegmentedControlIndicatorLocateTop,
    YUSegmentedControlIndicatorLocateBottom,
//    YUSegmentedControlIndicatorLocateHide,
};

NS_ASSUME_NONNULL_BEGIN

/**
 Display a segmented control which containing text or images.
 */
@interface YUSegmentedControl : UIControl

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes and returns a segmented control with segments having the given titles.

 @param titles An array of `NSString` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

/**
 Initializes and returns a segmented control with segments having the given images.

 @param images An array of `UIImage` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns a segmented control with segments having the given images.

 @param images An array of `UIImage` objects. The value must not be nil or empty array. Shows for normal state.
 @param selectedImages An array of `UIImage` objects. The value must not be nil or empty array. Shows for selected state.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images
                selectedImages:(nullable NSArray <UIImage *> *)selectedImages;

/**
 Returns the title for a specific segment.
 
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1.
 @return The title for a specific segment.
 */
- (nullable NSString *)titleAtIndex:(NSUInteger)index;

/**
 Returns the image for a specific segment.
 
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1.
 @return The image for a specific segment.
 */
- (nullable UIImage *)imageAtIndex:(NSUInteger)index;

/**
 Set the content of a segment to a given title.
 
 @param title A new title display in the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1.
 */
- (void)setTitle:(NSString *)title atIndex:(NSUInteger)index;

/**
 Set the content of a segment to a given image.
 
 @param image A new image display in the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1.
 */
- (void)setImage:(UIImage *)image atIndex:(NSUInteger)index;

/**
 Set the content of a segment to a given image.

 @param image A new image display in the segment. Displayed for normal state.
 @param selectedImage A new image display in the segment. Displayed for selected state.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1.
 */
- (void)setImage:(UIImage *)image selectedImage:(nullable UIImage *)selectedImage atIndex:(NSUInteger)index;

/**
 Displays badge at the top right of the specific segments.

 @param indexes An array of `NSNumber` objects. Identifying segments in the segmented control.
 */
- (void)showBadgeAtIndexes:(NSArray <NSNumber *> *)indexes;

/**
 Hides badge for a specific segment.

 @param index An index number identifying a segment in the segmented control.
 */
- (void)hideBadgeAtIndex:(NSUInteger)index;

/**
 Sets the text attributes of the title for a given control state.

 @param attributes The text attributes of the title.
 @param state A control state.
 */
- (void)setTextAttributes:(nullable NSDictionary *)attributes forState:(UIControlState)state;

///------------------------
/// @name Managing Segments
///------------------------

/**
 The number of segments the receiver has.
 */
@property (nonatomic, assign, readonly) NSUInteger numberOfSegments;

/**
 The index number identifying the selected segment.
 */
@property (nonatomic, assign, readonly) NSUInteger selectedSegmentIndex;

///-----------------------------------
/// @name Managing Segments Appearance
///-----------------------------------

/**
 The background color of the `YUSegmentedControl`. The default is white.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 The padding(including left and right) at which the origin of the contents is offset from the origin of the segmented control. Default is 0.
 */
@property (nonatomic, assign) CGFloat horizontalPadding;

/**
 A Boolean value that controls whether the top separator is visible. Default is `YES`.
 */
@property (nonatomic, assign, getter=isShowsTopSeparator) BOOL showsTopSeparator;

/**
 A Boolean value that controls whether the bottom separator is visible. Default is `YES`.
 */
@property (nonatomic, assign, getter=isShowsBottomSeparator) BOOL showsBottomSeparator;

/**
 A Boolean value that controls whether the divider is visible between each segment. Default is `NO`.
 */
@property (nonatomic, assign, getter=isShowsVerticalDivider) BOOL showsVerticalDivider;

///-------------------------
/// @name Managing Indicator
///-------------------------

/**
 A Boolean value that controls whether the indicator is visible. Default is `YES`.
 */
@property (nonatomic, assign, getter=isShowsIndicator) BOOL showsIndicator;

/**
 Returns a indicator of the segmented control.
 */
@property (nonatomic, strong, readonly) YUSegmentedControlIndicator *indicator;

@end


@interface YUSegmentedControlIndicator : UIView

/**
 The height of the indicator. The default is 2.0.
 */
@property (nonatomic, assign) CGFloat height;

/**
 The background color of the `YUSegmentedControl`. The default is white.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 The location of indicator. Could be top or bottom. Default is bottom.
 */
@property (nonatomic, assign) YUSegmentedControlIndicatorLocate locate;

@end


@interface YUSegmentedControl (Deprecated)

- (instancetype)initWithFrame:(CGRect)frame __attribute__((deprecated("This method is not supported.")));
- (instancetype)init __attribute__((deprecated("This method is not supported.")));
- (instancetype)new __attribute__((deprecated("This method is not supported.")));
/**
 Make a note for normal state.
 
 @return Return an existing instance of `YUSegmentedControl`.
 */
- (YUSegmentedControl *)normalState __attribute__((deprecated("This method is not supported.")));
/**
 Make a note for selected state.
 
 @return Return an existing instance of `YUSegmentedControl`.
 */
- (YUSegmentedControl *)selectedState __attribute__((deprecated("This method is not supported.")));
/**
 Sets the text attributes of the title.
 */
- (void (^)(NSDictionary * _Nullable attributes))setTextAttributes  __attribute__((deprecated("This method is not supported.")));

@end

NS_ASSUME_NONNULL_END
