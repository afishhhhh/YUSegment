//
//  UUSegmentLabel.h
//  demo
//
//  Created by 虞冠群 on 2016/11/17.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YULabelStyle) {
    YULabelStyleCustom,
    YULabelStyleBasic,
    YULabelStyleSelected,
};

NS_ASSUME_NONNULL_BEGIN

@interface YULabel : UILabel

- (instancetype)initWithText:(NSString *)text style:(YULabelStyle)style;
- (instancetype)initWithText:(NSString *)text attributes:(nullable NSDictionary *)attributes;

@end

NS_ASSUME_NONNULL_END
