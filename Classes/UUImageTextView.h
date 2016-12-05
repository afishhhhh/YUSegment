//
//  UUImageTextView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UULabel, UUImageView;

@interface UUImageTextView : UIView

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image selected:(BOOL)selected;
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;

- (UULabel *)getLabel;
- (UUImageView *)getImageView;

@end
