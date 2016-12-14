//
//  UUSegmentLabel.m
//  demo
//
//  Created by 虞冠群 on 2016/11/17.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YULabel.h"

@implementation YULabel

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.text = text;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text attributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
