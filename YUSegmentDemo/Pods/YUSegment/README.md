# YUSegment
[![Pod Version](https://img.shields.io/cocoapods/v/YUSegment.svg)]()
[![Pod Platform](https://img.shields.io/cocoapods/p/YUSegment.svg?style=flat)]()
[![Pod License](https://img.shields.io/cocoapods/l/YUSegment.svg)]()

[中文文档](http://www.jianshu.com/p/dfe654b749b3)

A customizable segmented control for iOS.

![YUSegment-demo](https://github.com/afishhhhh/YUSegment/blob/master/Images/demo.png)

## Features

- Supports both (Attributed)text and image
- Has two styles(linear and rectangular) to choose
- Supports horizontal scrolling
- Supports customize font and color
- YUSegment works on iOS 8.0+ and is compatible with ARC projects

## Installation

### Cocoapods

1. Add a pod entry to your Podfile `pod 'YUSegment'`
2. Running `pod install`
3. `#import "YUSegment.h"` where you need

## Usage

### Creating a YUSegment Programmatically (Recommended)

```objective-c
NSArray *titles = @[@"Left", @"Medium", @"Right"];
YUSegment *segment = [[YUSegment alloc] initWithTitles:titles];
[self.view addSubview:segment];
segment.frame = (CGRect){20, 60, [UIScreen mainScreen].bounds.size.width - 40, 44};
```

### Creating a YUSegment Using a Storyboard

1. In the Object Library, select the "UIView" object and drag it into the view.
2. Change the position and size of the view.

  ![YUSegment-storyboard](https://github.com/afishhhhh/YUSegment/blob/master/Images/storyboard2.png)
3. In the Identify Inspector, change the class to "YUSegment". Then connect outlet.

  ![YUSegment-storyboard](https://github.com/afishhhhh/YUSegment/blob/master/Images/storyboard1.png)
  ```objective-c
  @property (weak, nonatomic) IBOutlet YUSegment *segment;
  ```
4. You could modify some properties in Attributes Inspector.

  ![YUSegment-storyboard](https://github.com/afishhhhh/YUSegment/blob/master/Images/storyboard3.png)

More details in [YUSegmentDemo](YUSegmentDemo).

## APIs

### Target-Action

Similar to UISegmentedControl, you just need the following code:
```objective-c
[segment addTarget:self action:@selector(someMethod) forControlEvents:UIControlEventValueChanged];
```

### Image

The image is the same by default, no matter whether the image selected. If you want to show different image when a specific segment selected, you should call `-replaceDeselectedImagesWithImages:` or `-replaceDeselectedImageWithImage:atIndex:`.

### Attributed Text

You should use `-setTitleTextAttributes:forState:` to set attributed string. For example:
```objeective-c
NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
[segment setTitleTextAttributes:attributes forState:YUSegmentedControlStateNormal];
```

### Layer

You could set `borderColor`, `borderWidth`, and `cornerRadius` in Attributes Inspector. If you don't use interface builder, the code should look like this:
```objective-c
segment.layer.borderWidth = someValue;
segment.layer.borderColor = someValue;
```
~~Note: You should use `cornerRadius` instead of `layer.cornerRadius`. Because if you set `cornerRaduis` for segmented control, the indicator will become rounded automatically.~~
Note: About `cornerRadius`. Both segmented control and its indicator have default value of `cornerRadius`. The default value is equal to half the height of the segmented control. In version 0.2.0, the indicator will not become rounded automatically if you just set `cornerRaduis` of the segmented control. You also need to set `cornerRadius` for indicator manually.

### Scrolling Enabled

YUSegment don't have property look like `scrollEnabled`, you just need to set the width of each segment(`segmentWidth`). This property will make the segmented control scroll horizontally.

## New Features

###### Version 0.1.4:

- Supports chainable syntax. You could set `borderWidth` and `borderColor` for segmented control look like:
```objective-c
sgement.borderWidth(1.0).borderColor([UIColor redColor]);
```

###### Version 0.2.0:

- Exposes property `indicator(readonly)`, you could set attributes for indicator such as `backgroundColor`, `borderWidth`, `borderColor`, etc.
```objective-c
segment.indicator.backgroundColor = [UIColor redColor];
segment.indicator.layer.borderWidth = 1.0;
segment.indicator.layer.borderColor = [UIColor redColor].CGColor;
```

- Supports chainable syntax. You could set `borderWidth` and `borderColor` for indicator look like:
```objective-c
segment.indicator.borderWidth(1.0).borderColor([UIColor redColor]);
```	

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).
