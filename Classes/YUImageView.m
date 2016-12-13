//
//  UUImageView.m
//  demo
//
//  Created by 虞冠群 on 2016/11/21.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUImageView.h"

@implementation YUImageView

- (instancetype)initWithImage:(UIImage *)image selected:(BOOL)selected {
    self = [super initWithImage:image];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        if (selected) {
            // ...
        } else {
            self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.tintColor = [UIColor lightGrayColor];
        }
    }
    return self;
}

@end
