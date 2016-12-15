//
//  ExampleFourViewController.m
//  demo
//
//  Created by 虞冠群 on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import "ExampleFourViewController.h"
#import "YUSegment.h"

@interface ExampleFourViewController ()

@property (weak, nonatomic) IBOutlet YUSegment *segment1;
@property (weak, nonatomic) IBOutlet YUSegment *segment2;
@property (weak, nonatomic) IBOutlet YUSegment *segment3;

@end

@implementation ExampleFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles1 = @[@"Left3", @"Left2", @"Left1", @"Medium", @"Right1", @"Right2", @"Right3"];
    NSArray *titles2 = @[@"Left", @"Medium", @"Right"];
    NSArray *images = @[[UIImage imageNamed:@"pic1"], [UIImage imageNamed:@"pic2"], [UIImage imageNamed:@"pic3"]];
    
    [self.segment1 setTitles:titles1 forImages:nil];
    [self.segment2 setTitles:nil forImages:images];
    [self.segment3 setTitles:titles2 forImages:images];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
