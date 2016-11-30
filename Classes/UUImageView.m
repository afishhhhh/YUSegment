//
//  UUImageView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/21.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UUImageView.h"

@implementation UUImageView

- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
//        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAutomatic];
//        self.tintColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
