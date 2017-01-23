//
//  YUSegmentLine.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "YUSegment.h"

NS_ASSUME_NONNULL_BEGIN

@interface YUSegmentLine : YUSegment

- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images
              unselectedImages:(nullable NSArray <UIImage *> *)unselectedImages;

@end

NS_ASSUME_NONNULL_END
