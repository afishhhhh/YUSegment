//
//  YULabel.h
//  Created by YyGqQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YULabel : UILabel

- (instancetype)initWithText:(NSString *)text;

- (instancetype)initWithAttributedText:(NSAttributedString *)text;

@end

NS_ASSUME_NONNULL_END
