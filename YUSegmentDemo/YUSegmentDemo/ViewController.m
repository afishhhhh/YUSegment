//
//  ViewController.m
//  YUSegmentDemo
//
//  Created by 虞冠群 on 2017/4/4.
//  Copyright © 2017年 Yu Guanqun. All rights reserved.
//

#import "ViewController.h"
#import "FirstCell.h"
#import "SecondCell.h"
#import <YUSegment/YUSegment.h>

@interface ViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YUSegmentedControl *segmentedControl;
@property (nonatomic, copy) NSArray *titlesForCell;
@property (nonatomic, copy) NSArray *subtitlesForCell;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titlesForCell = @[@"隐藏底部分割线",
                           @"隐藏顶部分割线",
                           @"显示垂直分割线",
                           @"隐藏指示器",
                           @"指示器显示在顶部",
                           @"显示 badge",
                           @"增加左右内边距"];
    self.subtitlesForCell = @[@"Hides bottom separator",
                              @"Hides top separator",
                              @"Shows vertical divider",
                              @"Hides indicator",
                              @"Moves indicator from bottom to top",
                              @"Shows badge",
                              @"Increases padding(left and right)"];
    
    self.segmentedControl = [[YUSegmentedControl alloc] initWithTitles:@[@"健身", @"摄影", @"科技", @"美食", @"旅行"]];
    [_segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"FirstCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SecondCell" bundle:nil] forCellReuseIdentifier:@"SecondCell"];
}

- (void)segmentedControlTapped:(YUSegmentedControl *)sender {
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)switchTapped:(UISwitch *)sender {
    switch (sender.tag) {
        case 1:
            if (sender.isOn) { 
                _segmentedControl.showsBottomSeparator = NO;
            } else {
                _segmentedControl.showsBottomSeparator = YES;
            }
            break;
        case 2:
            if (sender.isOn) {
                _segmentedControl.showsTopSeparator = NO;
            } else {
                _segmentedControl.showsTopSeparator = YES;
            }
            break;
        case 3: {
            if (sender.isOn) {
                _segmentedControl.showsVerticalDivider = YES;
            } else {
                _segmentedControl.showsVerticalDivider = NO;
            }
            // items is private, not recommended to access it.
            NSArray *items = [_segmentedControl valueForKey:@"items"];
            for (UIView *item in items) {
                [item setNeedsLayout];
            }
            break;
        }
        case 4:
            if (sender.isOn) {
                _segmentedControl.showsIndicator = NO;
            } else {
                _segmentedControl.showsIndicator = YES;
            }
            break;
        case 5:
            if (sender.isOn) {
                _segmentedControl.indicator.locate = YUSegmentedControlIndicatorLocateTop;
            } else {
                _segmentedControl.indicator.locate = YUSegmentedControlIndicatorLocateBottom;
            }
            [_segmentedControl setNeedsLayout];
            break;
        case 6:
            if (sender.isOn) {
                [_segmentedControl showBadgeAtIndexes:@[@1]];
            } else {
                [_segmentedControl hideBadgeAtIndex:1];
            }
            break;
        case 7:
            if (sender.isOn) {
                _segmentedControl.horizontalPadding = 32.0;
            } else {
                _segmentedControl.horizontalPadding = 0.0;
            }
            break;
    }
}

#pragma mark - table view delegate & table view dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        FirstCell *cell = (FirstCell *)[tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        
        //
        NSUInteger selectedIndex = _segmentedControl.selectedSegmentIndex;
        cell.selectedIndexLabel.text = [@(selectedIndex) stringValue];
        cell.selectedTitleLabel.text = [_segmentedControl titleAtIndex:selectedIndex];
        
        return cell;
    } else {
        SecondCell *cell = (SecondCell *)[tableView dequeueReusableCellWithIdentifier:@"SecondCell" forIndexPath:indexPath];
        cell.titleLabel.text = _titlesForCell[indexPath.row - 1];
        cell.subtitleLabel.text = _subtitlesForCell[indexPath.row - 1];
        cell.aSwitch.tag = indexPath.row;
        [cell.aSwitch addTarget:self action:@selector(switchTapped:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    [view addSubview:_segmentedControl];
    [_segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    return view;
}

@end
