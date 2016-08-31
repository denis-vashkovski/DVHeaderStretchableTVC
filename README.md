# DVHeaderStretchableTVC

<p align="center">
<img src="DVHeaderStretchableTVC_Example/DVHeaderStretchableTVC_Example.gif" alt="Sample">
</p>

UITableViewController with elastic header.

## Installation
*DVHeaderStretchableTVC requires iOS 7.1 or later.*

### iOS 7

1.  Copying all the files from DVHeaderStretchableTVC folder into your project.
2.  Make sure that the files are added to the Target membership.

### Using [CocoaPods](http://cocoapods.org)

1.  Add the pod `DVHeaderStretchableTVC` to your [Podfile](http://guides.cocoapods.org/using/the-podfile.html).

        pod 'DVHeaderStretchableTVC', :git => 'https://github.com/denis-vashkovski/DVHeaderStretchableTVC.git'

2.  Run `pod install` from Terminal, then open your app's `.xcworkspace` file to launch Xcode.

## Basic Usage

Import the class header.

``` objective-c
#import "UITableViewController+HeaderStretchable.h"
```

Just redefine method `dv_heightForStretchableView` and `dv_viewForStretchableView`.

``` objective-c
// Asks the data source about the height of the header with stretchable effect
- (CGFloat)dv_heightForStretchableView {
    return 100.;
}

// Asks the data source about the UIView of the header with stretchable effect
- (UIView *)dv_viewForStretchableView {
    UILabel *label = [UILabel new];
    [label setText:@"Elastic header"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor lightGrayColor]];
    return label;
}
```

## Demo

Build and run the `DVHeaderStretchableTVC_Example` project in Xcode to see `DVHeaderStretchableTVC` in action.

## Contact

Denis Vashkovski

- https://github.com/denis-vashkovski
- denis.vashkovski.vv@gmail.com

## License

This project is is available under the MIT license. See the LICENSE file for more info. Attribution by linking to the [project page](https://github.com/denis-vashkovski/DVHeaderStretchableTVC) is appreciated.
