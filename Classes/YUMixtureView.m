//
//  YUMixtureView.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUMixtureView.h"

@interface YUMixtureView ()

@property (nonatomic, strong) UILabel     *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YUMixtureView

#pragma mark - Initialization

- (instancetype)initWithLabel:(UILabel *)label imageView:(UIImageView *)imageView {
    self = [super init];
    if (self) {
        _label = label;
        _imageView = imageView;
        _label.translatesAutoresizingMaskIntoConstraints = YES;
        _imageView.translatesAutoresizingMaskIntoConstraints = YES;
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
    _imageView.frame = (CGRect){0, 0, width, (height - 8) * 0.6};
    _label.frame = (CGRect){0, CGRectGetMaxY(_imageView.frame) + 8, width, (height - 8) * 0.4};
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end
