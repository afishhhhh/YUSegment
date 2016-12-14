//
//  RDYSegmentedControl.h
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUSegmentStyle) {
    // 添加一个 default
    // The default style for a segment with a line-style indicator.
    YUSegmentStyleSlider,
    // A style for s segment with a rounded-style indicator.
    YUSegmentStyleRounded,
};

NS_ASSUME_NONNULL_BEGIN

@interface YUSegment : UIControl

///------------------------
/// @name Managing Segments
///------------------------

/**
 The number of segments the receiver has.
 */
@property (nonatomic, assign, readonly) NSUInteger numberOfSegments;

/**
 The index number identifying the selected segment. The default is 0;
 */
@property (nonatomic, assign) IBInspectable NSUInteger selectedIndex;

/**
 
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *titles;

/**
 
 */
@property (nonatomic, copy, readonly) NSArray <UIImage *>  *images;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

#if TARGET_INTERFACE_BUILDER

/**
 A boolean value indicating a segment style. The default is false. This property will work only in interface builder.
 */
@property (nonatomic, assign) IBInspectable NSUInteger segmentStyle;
#else

/**
 A constant indicating a segment style. The default is `YUSegmentStyleSlider`. See `YUSegmentStyle` for descriptions of these constants.
 */
@property (nonatomic, assign, readonly) YUSegmentStyle style;
#endif

#if TARGET_INTERFACE_BUILDER

/**
 The width of the segment's border.
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 The color of the segment's border.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 The radius to use when drawing rounded corners for the layer’s background.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
#endif

/**
 The width for each segment. Assignment to this value will make segment scroll enable. Set width to 0 is not valid.
 */
@property (nonatomic, assign) IBInspectable CGFloat segmentWidth;

///-------------------------
/// @name Managing Indicator
///-------------------------

/**
 The spacing of the indicator to its superview. Only works with `YUSegmentRounded` style. The default is 2.
 */
@property (nonatomic, assign) IBInspectable CGFloat indicatorMargin;

/**
 The color of the indicator.
 */
@property (nonatomic, strong) IBInspectable UIColor *indicatorColor;

///-------------------------------
/// @name Managing Text Appearance
///-------------------------------

/**
 The color of the text, it only works when the type of items is `NSString`. The default is lightGrayColor.
 */
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/**
 The color of the text when the segment is selected. The default is darkGrayColor.
 */
@property (nonatomic, strong) IBInspectable UIColor *selectedTextColor;

/**
 The font of the text, identical to `textColor`, it only works when the type of items is `NSString`.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The font of the text when the segment is selected. The default is the same as `font`.
 */
@property (nonatomic, strong) UIFont *selectedFont;

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
 Initializes and returns s segmented control with segments having the given images.

 @param images An array of `UIImage` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns s segmented control with segments having the given titles and images. The image is at the top of the title.

 @param titles An array of `NSString` objects. This value must not be nil or empty array.
 @param images An array of `UIImage` objects. This value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images;

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles style:(YUSegmentStyle)style;

- (instancetype)initWithImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style;

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style;

///---------------------------------------
/// @name Managing Segment Content Setting
///---------------------------------------

/**
 <#Description#>

 @param titles <#titles description#>
 @param images <#images description#>
 */
- (void)setTitles:(nullable NSArray <NSString *> *)titles forImages:(nullable NSArray <UIImage *> *)images;

/**
 Set the content of a segment to a given title.

 @param title A new title display in the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;

/**
 Set the content of a segment to a given image.

 @param image A new image display in the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

/**
 Set the content of a segment to given title and image. You could just use `-setTitle:forSegmentAtIndex:` or `-setImage:forSegmentAtIndex:` to modify title or image only.

 @param title A new title display in the segment.
 @param image A new image display in the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)setTitle:(NSString *)title forImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

///---------------------------------------
/// @name Managing Segment Content Getting
///---------------------------------------

/**
 Returns the title for a specific segment.

 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 @return The title for a specific segment.
 */
- (NSString *)titleForSegmentAtIndex:(NSUInteger)index;

/**
 Returns the image for a specific segment.

 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 @return The image for a specific segment.
 */
- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index;

///-------------------------------
/// @name Managing Segments Insert
///-------------------------------

/**
 Inserts a segment at the end and gives it a title as content.

 @param title A `NSString` object to use as the content of the segment.
 */
- (void)addSegmentWithTitle:(NSString *)title;

/**
 Inserts a segment at the end and gives it an image as content.

 @param image A `UIImage` object to use as the content of the segment.
 */
- (void)addSegmentWithImage:(UIImage *)image;

/**
 Inserts a segment at the end and gives it a title and an image as content.

 @param title A `NSString` object to use as the content of the segment.
 @param image A `UIImage` object to use as the content of the segment.
 */
- (void)addSegmentWithTitle:(NSString *)title forImage:(UIImage *)image;

/**
 Inserts a segment at a specificed position in the receiver and gives it a title as content.

 @param title A `NSString` object to use as the content of the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index;

/**
 Inserts a segment at a specificed position in the receiver and gives it an image as content.

 @param image A `UIImage` object to use as the content of the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)index;

/**
 Inserts a segment at a speecified position in the receiver and gives it a title and an image as content.

 @param title A `NSString` object to use as the content of the segment.
 @param image A `UIImage` object to use as the content of the segment.
 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)insertSegmentWithTitle:(NSString *)title forImage:(UIImage *)image atIndex:(NSUInteger)index;
 
///-------------------------------
/// @name Managing Segments Delete
///-------------------------------

/**
 Removes all segments of the receiver.
 */
- (void)removeAllItems;

/**
 Removes the first segment of the receiver.
 */
- (void)removeLastItem;

/**
 Removes the specified segment of the receiver.

 @param index An index number identifying a segment in the control. It must be a number between 0 and the number of segments (numberOfSegments) minus 1; values exceeding this upper range are pinned to it.
 */
- (void)removeItemAtIndex:(NSUInteger)index;

@end

@interface YUSegment (Deprecated)

- (NSArray<NSString *> *)titles __attribute__((deprecated("Use -titleForSegmentAtIndex: instead.")));
- (NSArray<UIImage *> *)images __attribute__((deprecated("Use -imageForSegmentAtIndex: instead.")));

@end

NS_ASSUME_NONNULL_END
