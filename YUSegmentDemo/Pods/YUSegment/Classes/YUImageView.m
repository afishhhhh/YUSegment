//
//  YUImageView.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUImageView.h"

@implementation YUImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
