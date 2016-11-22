//
//  UUSegmentLabel.m
//  demo
//
//  Created by 虞冠群 on 2016/11/17.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "UULabel.h"

@implementation UULabel

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
        self.textColor = [UIColor blackColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 1;
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.text = text;
    }
    return self;
}

@end
