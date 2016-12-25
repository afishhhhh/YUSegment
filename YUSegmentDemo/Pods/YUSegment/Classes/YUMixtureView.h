//
//  YUMixtureView.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YUMixtureView : UIView

- (instancetype)initWithLabel:(UILabel *)label imageView:(UIImageView *)imageView;
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
