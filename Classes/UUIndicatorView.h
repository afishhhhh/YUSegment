//
//  UUIndicatorView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/28.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UUIndicatorViewType) {
    UUIndicatorViewTypeRectangle,
    UUIndicatorViewTypeUnderline,
};

@interface UUIndicatorView : UIView

@property (nonatomic, strong) UIView  *maskView;
@property (nonatomic, assign) CGFloat cornerRadius;

- (instancetype)initWithType:(UUIndicatorViewType)type;

- (void)setCenterX:(CGFloat)centerX;

@end
