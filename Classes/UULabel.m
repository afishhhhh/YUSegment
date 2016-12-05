//
//  UUSegmentLabel.m
//  demo
//
//  Created by 虞冠群 on 2016/11/17.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UULabel.h"

@implementation UULabel

- (instancetype)initWithText:(NSString *)text selected:(BOOL)selected {
    self = [super init];
    if (self) {
        if (selected) {
            self.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
//            self.textColor = [UIColor colorWithRed:238.0 / 255 green:143.0 / 255 blue:102.0 / 255 alpha:1.0];
            self.textColor = [UIColor blackColor];
        } else {
            self.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
            self.textColor = [UIColor lightGrayColor];
        }
        self.textAlignment = NSTextAlignmentCenter;
        self.text = text;
    }
    return self;
}

@end
