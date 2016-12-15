//
//  ExampleOneViewController.m
//  demo
//
//  Created by 虞冠群 on 2016/12/13.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "ExampleOneViewController.h"
#import "YUSegment.h"

@interface ExampleOneViewController ()

@property (nonatomic, strong) YUSegment *segment1;
@property (nonatomic, strong) YUSegment *segment2;
@property (nonatomic, strong) YUSegment *segment3;

@end

@implementation ExampleOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"Left3", @"Left2", @"Left1", @"Medium", @"Right1", @"Right2", @"Right3"];
//    NSArray *titles = @[@"Left", @"Medium", @"Right"];
    
    self.segment1 = [[YUSegment alloc] initWithTitles:titles];
    [self.view addSubview:self.segment1];
    self.segment1.frame = (CGRect){20, 60, [UIScreen mainScreen].bounds.size.width - 40, 44};
    self.segment1.segmentWidth = 88.0;

    self.segment2 = [[YUSegment alloc] initWithTitles:titles style:YUSegmentStyleLine];
    [self.view addSubview:self.segment2];
    self.segment2.frame = (CGRect){20, 144, [UIScreen mainScreen].bounds.size.width - 40, 44};
    self.segment2.segmentWidth = 88.0;
    
    self.segment3 = [[YUSegment alloc] initWithTitles:titles style:YUSegmentStyleBox];
    [self.view addSubview:self.segment3];
    self.segment3.frame = (CGRect){20, 228, [UIScreen mainScreen].bounds.size.width - 40, 44};
    self.segment3.segmentWidth = 88.0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
