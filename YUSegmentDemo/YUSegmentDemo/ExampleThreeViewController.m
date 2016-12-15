//
//  ExampleThreeViewController.m
//  demo
//
//  Created by 虞冠群 on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "ExampleThreeViewController.h"
#import "YUSegment.h"

@interface ExampleThreeViewController ()

@property (nonatomic, strong) YUSegment *segment1;
@property (nonatomic, strong) YUSegment *segment2;
@property (nonatomic, strong) YUSegment *segment3;

@end

@implementation ExampleThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"Left", @"Medium", @"Right"];
    NSArray *images = @[[UIImage imageNamed:@"pic1"], [UIImage imageNamed:@"pic2"], [UIImage imageNamed:@"pic3"]];
    
    self.segment1 = [[YUSegment alloc] initWithTitles:titles forImages:images];
    [self.view addSubview:self.segment1];
    self.segment1.frame = (CGRect){20, 60, [UIScreen mainScreen].bounds.size.width - 40, 72};
    
    self.segment2 = [[YUSegment alloc] initWithTitles:titles forImages:images style:YUSegmentStyleLine];
    [self.view addSubview:self.segment2];
    self.segment2.frame = (CGRect){20, 172, [UIScreen mainScreen].bounds.size.width - 40, 72};
    
    self.segment3 = [[YUSegment alloc] initWithTitles:titles forImages:images style:YUSegmentStyleBox];
    [self.view addSubview:self.segment3];
    self.segment3.frame = (CGRect){20, 280, [UIScreen mainScreen].bounds.size.width - 40, 72};
    self.segment3.indicatorColor = [UIColor lightGrayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
