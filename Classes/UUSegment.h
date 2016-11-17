//
//  RDYSegmentedControl.h
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UUSegmentType) {
    UUSegmentTypeDefault,
    UUSegmentTypeTabbed,
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

typedef void(^UUSegmentContentSelectedBlock)(void);

@protocol UUSegmentDelegate <NSObject>

- (void)segmentControl:(UUSegment *)segmentControl didSelectedAtIndex:(NSUInteger)index;

@end

@protocol UUSegmentDataSource <NSObject>

- (NSAttributedString *)segmentControl:(UUSegment *)segmentControl setAttributedTextForSegmentUsingCurrentText:(NSString *)text;

@end

@interface UUSegment : UIView

@property (nonatomic, weak)     id<UUSegmentDataSource>             dataSource;

@property (nonatomic, weak)     id<UUSegmentDelegate>               delegate;

@property (nonatomic, assign)   UUSegmentAutosizingMode             autosizingMode;

///----------------------------
/// @name Backgorund Of Segment
///----------------------------

/**
 The background color of the segment.
 */
@property (nonatomic, strong)   UIColor                             *backgroundColor;

/**
 The radius to use when drawing rounded corners of the segement' background.
 */
@property (nonatomic, assign)   CGFloat                             cornerRadius;

///------------------------
/// @name Border Of Segment
///------------------------

/**
 The width of the segment's border.
 */
@property (nonatomic, assign)   CGFloat                             borderWidth;

/**
 The color of the segment's border.
 */
@property (nonatomic, strong)   UIColor                             *borderColor;


/**
 The color of the text. Only works in the case that the elements of `items` is `NSString` when you use `+segmentWithType:items:`.
 */
@property (nonatomic, strong)   UIColor                             *textColor;

@property (nonatomic, assign)   UUFont                              font;

//@property (nonatomic, assign)   CGRect                            frame;

//@property (nonatomic, copy)     NSArray                             *segmentTitles;

@property (nonatomic, copy)     UUSegmentContentSelectedBlock       contentSelectedAction;


+ (instancetype)segmentWithType:(UUSegmentType)type items:(NSArray *)items;

- (void)resetItemWithText:(NSString *)text forSegmentAtIndex:(NSUInteger)index;

- (void)resetItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index;

- (void)resetItemWithImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index;

- (void)resetItemWithView:(UIView *)view forSegmentAtIndex:(NSUInteger)index;

@end
