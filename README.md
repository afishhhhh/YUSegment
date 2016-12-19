# YUSegment
[![Pod Version](https://img.shields.io/cocoapods/v/YUSegment.svg)]()
[![Pod Platform](https://img.shields.io/cocoapods/p/YUSegment.svg?style=flat)]()
[![Pod License](https://img.shields.io/cocoapods/l/YUSegment.svg)]()

A customizable segmented control for iOS.

## Features

- Supports both (Attributed)text and image
- Supports three style
- Supports horizontal scrolling
- YUSegment works on iOS 8.0+ and is compatible with ARC projects.

## Installation

### Cocoapods

1. Add a pod entry to your Podfile `pod 'YUSegment'`
2. Running `pod install`
3. `#import "YUSegment.h"` where you need.

## Usage

### Creating a YUSegment Using a Storyboard

1. In the Object Library, select the "UIView" object and drag it into the view.
2. Change the position and size of the view.
3. In the Identify Inspector, change the class to "YUSegment". Connect outlet.
4. Add the following code to where you need to set content. For example, in the `viewDidLoad:` method.

### Creating a YUSegment Programmatically

```objective-c
NSArray *titles = @[@"Left", @"Medium", @"Right"];
YUSegment *segment = [[YUSegment alloc] initWithTitles:titles];
[self.view addSubview:segment];
segment.frame = (CGRect){20, 60, [UIScreen mainScreen].bounds.size.width - 40, 44};
```

More details in [YUSegmentDemo](YUSegmentDemo).

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
