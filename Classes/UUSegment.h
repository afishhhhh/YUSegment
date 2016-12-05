//
//  RDYSegmentedControl.h
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UUSegmentStyle) {
    // The default style for a segment with a line-style indicator.
    UUSegmentStyleSlider,
    // A style for s segment with a rounded-style indicator.
    UUSegmentStyleRounded,
};

typedef NS_ENUM(NSUInteger, UUSegmentAutosizingMode) {
    UUSegmentAutosizingModeEqualWidths,
    UUSegmentAutosizingModeProportionalToContent,
};

typedef NS_ENUM(NSUInteger, UUFontWeight) {
    UUFontWeightThin,
    UUFontWeightMedium,
    UUFontWeightBold,
};

typedef struct UUFont {
    CGFloat      size;
    UUFontWeight weight;
}UUFont;

@class UUSegment;

@protocol UUSegmentDelegate <NSObject>

- (void)segmentControl:(UUSegment *)segmentControl didSelectedAtIndex:(NSUInteger)index;

@end

//@protocol UUSegmentDataSource <NSObject>
//
//- (NSAttributedString *)segmentControl:(UUSegment *)segmentControl setAttributedTextForSegmentUsingCurrentText:(NSString *)text;
//
//@end

@interface UUSegment : UIControl

///------------------------
/// @name Managing Segments
///------------------------

/**
 The number of segments.
 */
@property (nonatomic, assign, readonly) NSUInteger numberOfSegments;

/**
 The index of segment which selected currently. The default is 0;
 */
@property (nonatomic, assign) NSUInteger currentIndex;

///------------------------
/// @name Managing Protocol
///------------------------

//@property (nonatomic, weak) id<UUSegmentDataSource> dataSource;

@property (nonatomic, weak) id<UUSegmentDelegate> delegate;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

/**
 A constant indicating a segment style. The default is `UUSegmentStyleSlider`. See `UUSegmentStyle` for descriptions of these constants.
 */
@property (nonatomic, assign) UUSegmentStyle style;

/**
 The background color of the segment.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 The width of the segment's border.
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 The color of the segment's border.
 */
@property (nonatomic, strong) UIColor *borderColor;

/**
 The width for each segment. Assignment to this value will make segment scroll enable. Set width to 0 is not valid.
 */
@property (nonatomic, assign) CGFloat widthOfSegment;

@property (nonatomic, assign) UUSegmentAutosizingMode autosizingMode;

///-------------------------
/// @name Managing Indicator
///-------------------------

/**
 The spacing of the indicator to its superview. Only works with `UUSegmentRounded` style. The default is 2.
 */
@property (nonatomic, assign) CGFloat indicatorMargin;

/**
 The color of the indicator.
 */
@property (nonatomic, strong) UIColor *indicatorColor;

///-------------------------------
/// @name Managing Text Appearance
///-------------------------------

/**
 The color of the text, it only works when the type of items is `NSString`. The default is lightGrayColor.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 The color of the text when the segment is selected. The default is darkGrayColor.
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 The font of the text, identical to `textColor`, it only works when the type of items is `NSString`.
 */
@property (nonatomic, assign) UUFont font;

/**
 The font of the text when the segment is selected. The default is the same as `font`.
 */
@property (nonatomic, assign) UUFont selectedFont;

///--------------------------------
/// @name Managing Image Appearance
///--------------------------------

/**
 The color of the selected image. The default is lightGrayColor. The value is nil if the image not be selected.
 */
@property (nonatomic, strong) UIColor *imageColor;

///---------------------------
/// @name Managing Scroll View
///---------------------------


///---------------------
/// @name Initialization
///---------------------

/**
 Initializes and returns a segmented control with segments having the given titles.

 @param titles An array of `NSString` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `UUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

/**
 Initializes and returns s segmented control with segments having the given images.

 @param images An array of `UIImage` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `UUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns s segmented control with segments having the given titles and images. The image is at the top of the title.

 @param titles An array of `NSString` objects. This value must not be nil or empty array.
 @param images An array of `UIImage` objects. This value must not be nil or empty array.
 @return The newly-created instance of the `UUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images;

///---------------------------------------
/// @name Managing Segment Content Setting
///---------------------------------------

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

- (void)addSegmentWithTitle:(NSString *)title;

- (void)addSegmentWithImage:(UIImage *)image;

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)index;

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)index;
 
///-------------------------------
/// @name Managing Segments Delete
///-------------------------------

- (void)removeAllItems;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

/**
 Set the radius of rounded corners for the segment's background.
 
 @param cornerRadius The radius to use when drawing rounded corners for the segment's background.
 */
- (void)setSegmentWithCornerRadius:(CGFloat)cornerRadius;

@end
