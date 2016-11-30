//
//  UUImageTextView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUImageTextView.h"
#import "UULabel.h"
#import "UUImageView.h"

@interface UUImageTextView ()

@property (nonatomic, strong) UULabel     *label;
@property (nonatomic, strong) UUImageView *imageView;

@end

@implementation UUImageTextView

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _label = [[UULabel alloc] initWithText:title];
        _imageView = [[UUImageView alloc] initWithImage:image];
        [self addSubview:_label];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"ImageTextView layoutSubviews");
    _imageView.frame = (CGRect){0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.7};
    _label.frame = (CGRect){0, CGRectGetMaxY(_imageView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * 0.3};
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UULabel *)label {
    return _label;
}

- (UUImageView *)imageView {
    return _imageView;
}

@end
