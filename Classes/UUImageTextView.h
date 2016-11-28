//
//  UUImageTextView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUImageTextView : UIView

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image;
- (void)setTitle:(NSString *)title;
- (void)setImage:(UIImage *)image;

@end
