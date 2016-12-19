//
//  YUImageView.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUImageView.h"

@implementation YUImageView

- (instancetype)initWithImage:(UIImage *)image renderingMode:(UIImageRenderingMode)mode {
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.image = [self.image imageWithRenderingMode:mode];
        self.tintColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
