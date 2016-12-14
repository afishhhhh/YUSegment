//
//  UUSegmentLabel.m
//  demo
//
//  Created by 虞冠群 on 2016/11/17.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YULabel.h"

@implementation YULabel

- (instancetype)initWithAttributedText:(NSAttributedString *)attributedText {
    self = [super init];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.attributedText = attributedText;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end
