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

@interface UUSegment : UIView

///------------------------
/// @name Managing Segments
///------------------------

@property (nonatomic, assign, readonly) NSUInteger numberOfSegments;

///------------------------
/// @name Managing Protocol
///------------------------

//@property (nonatomic, weak) id<UUSegmentDataSource> dataSource;

@property (nonatomic, weak) id<UUSegmentDelegate> delegate;

@property (nonatomic, assign)   UUSegmentAutosizingMode             autosizingMode;

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
@property (nonatomic, assign)   CGFloat                             borderWidth;

/**
 The color of the segment's border.
 */
@property (nonatomic, strong)   UIColor                             *borderColor;

///-------------------------------
/// @name Managing Text Appearance
///-------------------------------

@property (nonatomic, strong) UIColor           *textColor;

@property (nonatomic, assign) UUFont            font;

@property (nonatomic, assign) NSUInteger        numberOfLine;

///---------------------------
/// @name Managing Scroll View
///---------------------------

@property (nonatomic, assign, getter = isScrollOn) BOOL scrollOn;


@property (nonatomic, copy)     UUSegmentContentSelectedBlock       contentSelectedAction;

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes and returns a segmented control with segments having the given items.

 @param items Items showed in segment control, this array could be `NSString`, `UIImage`, custom `UIView`, also could be a mixture of the above elements.
 @return The newly-created instance of `UUSegment`.
 */
- (instancetype)initWithItems:(NSArray *)items;

///---------------------------------------
/// @name Managing Segment Content Setting
///---------------------------------------

- (void)setItemWithText:(NSString *)text forSegmentAtIndex:(NSUInteger)index;

//- (void)setItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index;

- (void)setItemWithImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

- (void)setItemWithView:(UIView *)view forSegmentAtIndex:(NSUInteger)index;

///---------------------------------------
/// @name Managing Segment Content Getting
///---------------------------------------

- (NSString *)textForSegmentAtIndex:(NSUInteger)index;

- (UIImage *)imageForSegmentAtIndex:(NSUInteger)index;

- (UIView *)viewForSegmentAtIndex:(NSUInteger)index;

///-------------------------------
/// @name Managing Segments Insert
///-------------------------------

- (void)addItemWithText:(NSString *)text;

- (void)addItemWithImage:(UIImage *)image;

- (void)insertItemWithText:(NSString *)text atIndex:(NSUInteger)index;

- (void)insertItemWithImage:(UIImage *)image atIndex:(NSUInteger)index;

///-------------------------------
/// @name Managing Segments Delete
///-------------------------------

- (void)removeAllItems;

- (void)removeLastItem;

- (void)removeItemAtIndex:(NSUInteger)index;

@end
