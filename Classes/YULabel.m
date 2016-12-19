//
//  YULabel.m
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YULabel.h"

@implementation YULabel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
