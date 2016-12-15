//
//  UUImageTextView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YUImageTextView : UIView

- (instancetype)initWithLabel:(UILabel *)label imageView:(UIImageView *)imageView;
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
