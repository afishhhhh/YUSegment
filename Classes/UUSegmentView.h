//
//  UUSegmentView.h
//  demo
//
//  Created by 虞冠群 on 2016/11/20.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UUSegmentViewMappingTable) {
    UUSegmentViewMappingTableLabel,
    UUSegmentViewMappingTableImage,
    UUSegmentViewMappingTableView,
};

@interface UUSegmentView : UIView

@property (nonatomic, assign) UUSegmentViewMappingTable  mappingTo;
@property (nonatomic, assign) NSUInteger                 indexInTable;

@end
