//
//  UUImageView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/21.
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
