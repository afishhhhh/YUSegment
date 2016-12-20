//
//  YUSegmentDemo
//  Created by YyGgQq on 2016/12/15.
//  Copyright © 2016年 Yu Guanqun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <YUSegment/YUSegment.h>

@interface YUSegmentDemoTests : XCTestCase

@end

@implementation YUSegmentDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializationWithTitle {
    NSArray *titles = @[@"Left", @"Medium", @"Right"];
    YUSegmentStyle style = YUSegmentStyleLine;
    YUSegment *segment = [[YUSegment alloc] initWithTitles:titles style:style];
    
    XCTAssertNotNil(segment, @"Segment should be created.");
    XCTAssertEqualObjects(segment.backgroundColor, [UIColor whiteColor], @"The background color should be equal to [UIColor whiteColor].");
    XCTAssertEqual(segment.numberOfSegments, [titles count], @"The number of segments should be equal to [titles count].");
    XCTAssertEqual([segment.subviews count], 1, @"The count of subviews should be only one.");
    XCTAssertEqualObjects(segment.textColor, [UIColor lightGrayColor], @"The color of text should be [UIColor lightGrayColor].");
    XCTAssertEqualObjects(segment.selectedTextColor, [UIColor blackColor], @"The color of selected text should be [UIColor blackColor].");
}

- (void)testInitializationWithImage {
    NSArray *images = @[[UIImage imageNamed:@"pic1"], [UIImage imageNamed:@"pic2"], [UIImage imageNamed:@"pic3"]];
    YUSegmentStyle style = YUSegmentStyleLine;
    YUSegment *segment = [[YUSegment alloc] initWithImages:images style:style];
    
    XCTAssertNotNil(segment, @"Segment should be created.");
    XCTAssertEqualObjects(segment.backgroundColor, [UIColor whiteColor], @"The background color should be equal to [UIColor whiteColor].");
    XCTAssertEqual(segment.numberOfSegments, [images count], @"The number of segments should be equal to [titles count].");
    XCTAssertEqual([segment.subviews count], 1, @"The count of subviews should be only one.");
}

- (void)testInitializationWithTitleAndImage {
    NSArray *titles = @[@"Left", @"Medium", @"Right"];
    NSArray *images = @[[UIImage imageNamed:@"pic1"], [UIImage imageNamed:@"pic2"], [UIImage imageNamed:@"pic3"]];
    YUSegmentStyle style = YUSegmentStyleLine;
    YUSegment *segment = [[YUSegment alloc] initWithTitles:titles forImages:images style:style];
    
    XCTAssertNotNil(segment, @"Segment should be created.");
    XCTAssertEqualObjects(segment.backgroundColor, [UIColor whiteColor], @"The background color should be equal to [UIColor whiteColor].");
    XCTAssertEqual(segment.numberOfSegments, [titles count], @"The number of segments should be equal to [titles count].");
    XCTAssertEqual([segment.subviews count], 1, @"The count of subviews should be only one.");
    XCTAssertEqualObjects(segment.textColor, [UIColor lightGrayColor], @"The color of text should be [UIColor lightGrayColor].");
    XCTAssertEqualObjects(segment.selectedTextColor, [UIColor blackColor], @"The color of selected text should be [UIColor blackColor].");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
