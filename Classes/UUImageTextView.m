//
//  UUImageTextView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUImageTextView.h"
#import "UULabel.h"

@interface UUImageTextView ()

@property (nonatomic, strong) UULabel     *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation UUImageTextView

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title forImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _label = [[UULabel alloc] initWithText:title];
        _imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_label];
        [self addSubview:_imageView];
    }
    return self;
}

#pragma mark -

- (void)setTitle:(NSString *)title {
    self.label.text = title;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end
