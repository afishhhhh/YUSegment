//
//  RDYSegmentedControl.h
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

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

typedef void(^UUSegmentContentSelectedBlock)(void);

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
 The index of segment that selected currently. The default is 0;
 */
@property (nonatomic, assign)           NSUInteger currentIndex;

///------------------------
/// @name Managing Protocol
///------------------------

//@property (nonatomic, weak) id<UUSegmentDataSource> dataSource;

@property (nonatomic, weak) id<UUSegmentDelegate> delegate;

///----------------------------------
/// @name Managing Segment Appearance
///----------------------------------

/**
 The background color of the segment.
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 The radius to use when drawing rounded corners of the segement' background.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 The width of the segment's border.
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 The color of the segment's border.
 */
@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) UUSegmentAutosizingMode autosizingMode;

///-------------------------------
/// @name Managing Text Appearance
///-------------------------------

/**
 The color of the text, it only works when the type of items is `NSString`.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 The font of the text, identical to `textColor`, it only works when the type of items is `NSString`.
 */
@property (nonatomic, assign) UUFont font;

/**
 The maximum number of lines to use for rendering text, it only works when the type of items is `NSString`.
 */
@property (nonatomic, assign) NSUInteger numberOfLines;

///---------------------------
/// @name Managing Scroll View
///---------------------------

/**
 The Boolean value that controls whether scrolling is enabled. The default is `NO`.
 */
@property (nonatomic, assign, getter = isScrollOn) BOOL scrollOn;


@property (nonatomic, copy)     UUSegmentContentSelectedBlock       contentSelectedAction;

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes and returns a segmented control with segments having the given titles.

 @param titles An array of `NSString` objects for segment titles. This value must not be nil or empty array.
 @return The newly-created instance of `UUSegment`.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;

/**
 Initializes and returns s segmented control with segments having the given images.

 @param images An array of `UIImage` objects for segment images. This value must not be nil or empty array.
 @return The newly-created instance of `UUSegment`.
 */
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;

/**
 Initializes and returns s segmented control with segments having the given titles and images.

 @param titles An array of `NSString` objects for segment titles. This value must not be nil or empty array.
 @param images An array of `UIImage` objects for segment images. This value must not be nil or empty array.
 @return The newly-created instance of `UUSegment` that images are above the titles.
 */
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles forImages:(NSArray <UIImage *> *)images;

///---------------------------------------
/// @name Managing Segment Content Setting
///---------------------------------------

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index;

//- (void)setItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index;

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

- (void)setTitle:(NSString *)title forImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

///---------------------------------------
/// @name Managing Segment Content Getting
///---------------------------------------

- (NSString *)titleForSegmentAtIndex:(NSUInteger)index;

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index;

- (NSDictionary *)titleAndImageForSegmentAtIndex:(NSUInteger)index;

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

@end
