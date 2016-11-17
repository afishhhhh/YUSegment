//
//  RDYSegmentedControl.m
//  Read
//
//  Created by 虞冠群 on 2016/11/12.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUSegment.h"
#import "UUSegmentPrivate.h"
#import "UUSegmentDefault.h"
#import "UUSegmentTabbed.h"

@interface UUSegment ()



@end

@implementation UUSegment

@dynamic font;

#pragma mark - Initialization

+ (instancetype)segmentWithType:(UUSegmentType)type items:(NSArray *)items {
    switch (type) {
        case UUSegmentTypeDefault:
            return [[UUSegmentDefault alloc] initWithItems:items];
            break;
        case UUSegmentTypeTabbed:
            return [UUSegmentTabbed new];
            break;
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)resetItemWithText:(NSString *)text forSegmentAtIndex:(NSUInteger)index {
    
}

- (void)resetItemWithAttributedText:(NSAttributedString *)attributedText forSegmentAtIndex:(NSUInteger)index {
    
}

- (void)resetItemWithImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)index {
    
}

- (void)resetItemWithView:(UIView *)view forSegmentAtIndex:(NSUInteger)index {
    
}


#pragma mark - Getters & Setters

- (void)setFont:(UUFont)font {
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(segmentControl:setAttributedTextForSegmentUsingCurrentText:)]) {
        return;
    }
    
    CGFloat fontSize = font.size;
    CGFloat fontWeight;
    
    switch (font.weight) {
        case UUFontWeightThin:
            fontWeight = UIFontWeightThin;
            break;
        case UUFontWeightMedium:
            fontWeight = UIFontWeightMedium;
            break;
        case UUFontWeightBold:
            fontWeight = UIFontWeightBold;
            break;
    }
    
    self.fontConverted = [UIFont systemFontOfSize:fontSize weight:fontWeight];
}

@end
