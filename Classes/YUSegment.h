//
//  YUSegment.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2016 YyGgQq
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUSegmentStyle) {
    // The default style for a segment with a line-style indicator.
    YUSegmentStyleLine,
    // A style for s segment with a box-style indicator.
    YUSegmentStyleBox,
};

typedef NS_ENUM(NSUInteger, YUSegmentedControlState) {
    // The normal, or default state of the segmented control
    YUSegmentedControlStateNormal,
    // Selected state of the segmented control
    YUSegmentedControlStateSelected,
};

NS_ASSUME_NONNULL_BEGIN

@interface YUSegment : UIControl

#if TARGET_INTERFACE_BUILDER

///------------------------
/// @name Managing Segments
///------------------------

/**
 The titles the receiver has. Set this property in attributes inspector.
 */
@property (nonatomic, copy) IBInspectable NSString *segmentTitles;

/**
 The images(names) the receiver has. Set this property in attributes inspector.
 */
@property (nonatomic, copy) IBInspectable NSString *segmentImages;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

/**
 The width of the segmented control's border.
 */
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

/**
 The color of the segmented control's border.
 */
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

/**
 The boolean value whether to set the style to `YUSegmentStyleBox`.
 */
@property (nonatomic, assign) IBInspectable BOOL boxStyle;

#endif

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
 Return the titles the receiver has. It is the convenient method to return the title for a specific segment.
 For example, `titles[i]` and `titleForSegmentAtIndex:i` do the same thing.
 */
@property (nonatomic, copy, readonly) NSArray <NSString *> *titles;

/**
 Return the images the receiver has. It is the convenient method to return the image for a specific segment.
 For example `images[i]` and `imageForSegmentAtIndex:i` do the same thing.
 */
@property (nonatomic, copy, readonly) NSArray <UIImage *>  *images;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

/**
 The segmented control style. See `YUSegmentStyle` for the possible values. 
 The default is `YUSegmentStyleLine`.
 */
@property (nonatomic, assign, readonly) YUSegmentStyle style;

/**
 The radius to use when drawing rounded corners for the layer’s background.
 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

/**
 The width for each segment. Assignment to this value will make segment scroll enable. Set width to 0 is not valid.
 */
@property (nonatomic, assign) IBInspectable CGFloat segmentWidth;

///-------------------------
/// @name Managing Indicator
///-------------------------

/**
 The spacing of the indicator to its superview. The default is 2. 
 Only valid when the style is `YUSegmentStyleBox`.
 */
@property (nonatomic, assign) IBInspectable CGFloat indicatorMargin;

/**
 The color of the indicator. The default is `[UIColor colorWithWhite:0.2 alpha:1.0]`.
 */
@property (nonatomic, strong) IBInspectable UIColor *indicatorColor;

///-------------------------------
/// @name Managing Text Appearance
///-------------------------------

/**
 The color of the text. The default is `[UIColor lightGrayColor]`.
 */
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/**
 The color of the text when the segment is selected. The default is `[UIColor blackColor]`. If the style is `YUSegmentStyleBox`, the default is `[UIColor whiteColor]`.
 */
@property (nonatomic, strong) IBInspectable UIColor *selectedTextColor;

/**
 The font of the text. The default is `[UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium]`.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The font of the text when the segment is selected. The default is `[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]`.
 */
@property (nonatomic, strong) UIFont *selectedFont;

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes and returns a segmented control with segments having the given titles. 
 The style is `YUSegmentStyleLine`.

 @param titles An array of `NSString` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

/**
 Initializes and returns s segmented control with segments having the given images.
 The style is `YUSegmentStyleLine`.

 @param images An array of `UIImage` objects. The value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns s segmented control with segments having the given titles and images.
 The style is `YUSegmentStyleLine`.

 @param titles An array of `NSString` objects. This value must not be nil or empty array.
 @param images An array of `UIImage` objects. This value must not be nil or empty array.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns a segmented control with segments having the given titles and style.

 @param titles An array of `NSString` objects. The value must not be nil or empty array.
 @param style The segmented control style. See `YUSegmentStyle` for the possible values.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles style:(YUSegmentStyle)style;

/**
 Initializes and returns a segmented control with segments having the given images and style.

 @param images An array of `UIImage` objects. This value must not be nil or empty array.
 @param style The segmented control style. See `YUSegmentStyle` for the possible values.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style;

/**
 Initializes and returns s segmented control with segments having the given titles, images and style.

 @param titles An array of `NSString` objects. The value must not be nil or empty array.
 @param images An array of `UIImage` objects. This value must not be nil or empty array.
 @param style The segmented control style. See `YUSegmentStyle` for the possible values.
 @return The newly-created instance of the `YUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images style:(YUSegmentStyle)style;

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

///-----------------------------------
/// @name Managing Segments Appearance
///-----------------------------------

/**
 Sets the text attributes of the title for a given control state.

 @param attributes The text attributes of the title.
 @param state A control state.
 */
- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(YUSegmentedControlState)state;

- (NSDictionary *)titleTextAttributesForState:(YUSegmentedControlState)state;

@end

@interface YUSegment (Deprecated)

- (instancetype)initWithFrame:(CGRect)frame __attribute__((deprecated("This method is not supported.")));
- (instancetype)init __attribute__((deprecated("This method is not supported.")));
- (instancetype)new __attribute__((deprecated("This method is not supported.")));

@end

NS_ASSUME_NONNULL_END
