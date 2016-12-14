//
//  UUImageTextView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUImageTextView.h"
#import "YULabel.h"
#import "YUImageView.h"

@interface YUImageTextView ()

@property (nonatomic, strong) YULabel     *label;
@property (nonatomic, strong) YUImageView *imageView;

@end

@implementation YUImageTextView

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image style:(YUImageTextViewStyle)style {
    self = [super init];
    if (self) {
        _label = [[YULabel alloc] initWithText:title];
        _imageView = [[YUImageView alloc] initWithImage:image style:YUImageViewStyleBasic];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_label];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"ImageTextView layoutSubviews");
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    _imageView.frame = (CGRect){0, 0, width, (height - 8) * 0.7};
    _label.frame = (CGRect){0, CGRectGetMaxY(_imageView.frame) + 8, width, (height - 8) * 0.3};
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (YULabel *)getLabel {
    return _label;
}

- (YUImageView *)getImageView {
    return _imageView;
}

@end
