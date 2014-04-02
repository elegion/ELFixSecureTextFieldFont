# ELFixSecureTextFieldFont
Simple fix for ios 7 secure text field font size bug.
Based on [Geri](http://stackoverflow.com/users/215282/geri) solution on [StackOverflow](http://stackoverflow.com/a/22596030).

## Usage

In you ViewController:

``` objective-c
#import "UITextField+ELFixSecureTextFieldFont.h"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mySecureTextField fixSecureTextFieldFont]
}
```

or in your custom TextField:

``` objective-c
#import "UITextField+ELFixSecureTextFieldFont.h"

@implementation MyCustomTextField

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupMyCustomTextField];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupMyCustomTextField];
}

- (void)setupMyCustomTextField {
    [self fixSecureTextFieldFont];
}

@end
```

## Installation

Via [CocoaPods](http://cocoapods.org):

``` ruby
pod 'ELFixSecureTextFieldFont', :git => 'https://github.com/elegion/ELFixSecureTextFieldFont.git'
```

or just add `ELFixSecureTextFieldFont/UITextField+ELFixSecureTextFieldFont` and `ELFixSecureTextFieldFont/UITextField+ELFixSecureTextFieldFont` to your project (ARC required)

## License

ELFixSecureTextFieldFont is available under the MIT license. See the LICENSE file for more info.