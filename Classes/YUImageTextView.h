//
//  UUImageTextView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUImageTextViewStyle) {
    YUImageTextViewStyleCustom,
    YUImageTextViewStyleBasic,
    YUImageTextViewStyleSelected,
};

@class YULabel, YUImageView;

NS_ASSUME_NONNULL_BEGIN

@interface YUImageTextView : UIView

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image style:(YUImageTextViewStyle)style;
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;

- (YULabel *)getLabel;
- (YUImageView *)getImageView;

@end

NS_ASSUME_NONNULL_END
