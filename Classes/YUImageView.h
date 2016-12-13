//
//  UUImageView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/21.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YUImageViewStyle) {
    YUImageViewStyleCustom,
    YUImageViewStyleBasic,
    YUImageViewStyleSelected,
};

NS_ASSUME_NONNULL_BEGIN

@interface YUImageView : UIImageView

- (instancetype)initWithImage:(UIImage *)image style:(YUImageViewStyle)style;

@end

NS_ASSUME_NONNULL_END
