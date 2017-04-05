# YUSegment
[![Pod Version](https://img.shields.io/cocoapods/v/YUSegment.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Pod Platform](https://img.shields.io/cocoapods/p/YUSegment.svg?style=flat)]()
[![Pod License](https://img.shields.io/cocoapods/l/YUSegment.svg)]()

[中文文档](https://afishhhhh.github.io/2017/04/05/yusegment-doc/)

A customizable segmented control for iOS.

![YUSegment-demo](https://github.com/afishhhhh/YUSegment/blob/master/Screenshots/demo.png)

## Features

- Supports both (Attributed)text and image
- Supports show separator
- Supports hide indicator
- Indicator could be located at the top and bottom
- YUSegment works on iOS 8.0+ and is compatible with ARC projects

## Installation

### Cocoapods

1. Add a pod entry to your Podfile `pod 'YUSegment'`
2. Running `pod install`
3. `#import <YUSegment/YUSegment.h>` where you need

### Carthage

`github "afishhhhh/YUSegment"`

## Usage

`YUSegmentedControl` inherits from `UIControl`, supports `Target-Action`.

```objective-c
YUSegmentedControl *segmentedControl = [[YUSegmentedControl alloc] initWithTitles:@[@"健身", @"摄影", @"科技", @"美食", @"旅行"]];
[self.view addSubview:segmentedControl];
[segmentedControl addTarget:self action:@selector(segmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
```

By default, the background color of segmented control is `whiteColor`, the color of indicator is `darkGrayColor`, the height of indicator is 3.0, the color of separator is `#e7e7e7`.

## APIs

### Methods

```objective-c
- (instancetype)initWithTitles:(NSArray <NSString *> *)titles;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images;
- (instancetype)initWithImages:(NSArray <UIImage *> *)images
                selectedImages:(nullable NSArray <UIImage *> *)selectedImages;
```

You can use `selectedImages` if you want to show different images when a specific segment selected.

```objective-c
- (nullable NSString *)titleAtIndex:(NSUInteger)index;
- (nullable UIImage *)imageAtIndex:(NSUInteger)index;
```

You can get the corresponding text or image based on a specific index.

```objectve-c
- (void)showBadgeAtIndexes:(NSArray <NSNumber *> *)indexes;
- (void)hideBadgeAtIndex:(NSUInteger)index;
```

example:

```objective-c
[segmentedControl show BadgeAtIndexes:@[@1, @2]];
```

<br/>

```objective-c
- (void)setTextAttributes:(nullable NSDictionary *)attributes 
                 forState:(YUSegmentedControlState)state;
```

The attributes for text. For a list of attributes that you can include in this dictionary, see [Character Attributes](https://developer.apple.com/reference/foundation/nsattributedstring/character_attributes).
The value of `state` could be `YUSegmentedControlNormal` and `YUSegmentedControlSelected`.

example:

```objective-c
[segmentedControl setTextAttributes:@{
  NSFontAttributeName: [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight],
  NSForegroundColorAttributeName: [UIColor blackColor]
} forState:YUSegmentedControlNormal];
```

<br/>

### Properties

* numberOfSegments(NSUInteger, readonly)

  return the number of segments in a segmented control.

* selectedSegmentIndex(NSUInteger, readonly)

  The index number identifying the selected segment. Default is 0.

* horizontalPadding

  Default is 0.

  ![padding-0](https://github.com/afishhhhh/YUSegment/blob/master/Screenshots/padding-0.png)

  If assign it to 32.0.

  ![padding-32](https://github.com/afishhhhh/YUSegment/blob/master/Screenshots/padding-32.png)

* showsTopSeparator

  A Boolean value that controls whether the top separator is visible. Default is `YES`.

* showsBottomSeparator

  A Boolean value that controls whether the bottom separator is visible. Default is `YES`.

* showsVerticalDivider

  A Boolean value that controls whether the vertical divider is visible. Default is `NO`.

* showsIndicator

  A Boolean value that controls whether the indicator is visible. Default is `YES`.

* backgroundColor(YUSegmentedControl)

  The background color of segmented control. Default is white.

* height(YUSegmentedControlIndicator)

  The height of indicator. Default is 3.0. 
  You should use this property like this:

  ```objective-c
  segment.indicator.height = 3.0;
  ```

* locate(YUSegmentedControlIndicator)

  The vertical alignment of indicator. Default is `YUSegmentedControlIndicatorLocateBottom`. Also could be `YUSegmentedControlIndicatorLocateTop`
  You should use this property like this:

  ```objective-c
  segment.indicator.locate = YUSegmentedControlIndicatorLocateTop;
  ```

* backgroundColor(YUSegmentedControlIndicator)

  The background color of indicator. Default is dark gray.
  You should use this property like this:

  ```objective-c
  segment.indicator.backgroundColor = [UIColor whiteColor];
  ```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
