//
//  UITextField+ELFixSecureTextLabelFont.m
//  ELFixSecureTextLabelFont
//
//  Created by Vladimir Lyukov on 4/1/14.
//  Copyright (c) 2014 e-legion. All rights reserved.
//

#import "UITextField+ELFixSecureTextFieldFont.h"
#import <objc/runtime.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface UITextField ()

@property (nonatomic, assign) BOOL fstff_fixed; // use custom behaviour only if fixSecureTextFieldFont called for this field
@property (nonatomic, assign) BOOL fstff_secure; // store real value of self.secureTextEntry
@property (nonatomic, strong) NSString *fstff_actualText; // store real text of textField

@end

@implementation UITextField (ELFixSecureTextFieldFont)

- (void)fixSecureTextFieldFont {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return;
    }
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        // swizzle text method
        Method fstff_text = class_getInstanceMethod([UITextField class], @selector(fstff_text));
        Method text = class_getInstanceMethod([UITextField class], @selector(text));
        method_exchangeImplementations(fstff_text, text);

        // swizzle setText method
        Method fstff_setText = class_getInstanceMethod([UITextField class], @selector(fstff_setText:));
        Method setText = class_getInstanceMethod([UITextField class], @selector(setText:));
        method_exchangeImplementations(fstff_setText, setText);

        // swizzle setSecureTextEntry
        Method fstff_setSecureTextEntry = class_getInstanceMethod([UITextField class], @selector(fstff_setSecureTextEntry:));
        Method setSecureTextEntry = class_getInstanceMethod([UITextField class], @selector(setSecureTextEntry:));
        method_exchangeImplementations(fstff_setSecureTextEntry, setSecureTextEntry);
    });

    // add focus/blur handlers
    [self addTarget:self action:@selector(fstff_editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(fstff_editingChanged) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(fstff_editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];

    // initialize
    self.fstff_fixed = YES;
    self.fstff_actualText = [self fstff_text]; // super text
    // setSecureTextEntry can be called from initWithCoder: ... and then it's
    self.secureTextEntry = self.secureTextEntry || self.fstff_secure;
}

- (NSString *)fstff_dotPlaceholderForText:(NSString *)text {
    return [@"" stringByPaddingToLength:[text length] withString: @"•" startingAtIndex:0];
}

#pragma mark - Properties

- (BOOL)fstff_fixed {
    NSNumber *fixed = objc_getAssociatedObject(self, @selector(fstff_fixed));
    return fixed.boolValue;
}

- (void)setFstff_fixed:(BOOL)fixed {
    objc_setAssociatedObject(self, @selector(fstff_fixed), @(fixed), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)fstff_secure {
    NSNumber *secure = objc_getAssociatedObject(self, @selector(fstff_secure));
    return secure.boolValue;
}

- (void)setFstff_secure:(BOOL)secure {
    objc_setAssociatedObject(self, @selector(fstff_secure), @(secure), OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)fstff_actualText {
    return objc_getAssociatedObject(self, @selector(fstff_actualText));
}

- (void)setFstff_actualText:(NSString *)text {
    objc_setAssociatedObject(self, @selector(fstff_actualText), text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Methods swizzling

- (NSString *)fstff_text {
    if (!self.fstff_fixed) {
        return self.fstff_text;
    }

    return self.fstff_actualText;
}

- (void)fstff_setText:(NSString *)text {
    if (!self.fstff_fixed) {
        [self fstff_setText:text];
        return;
    }

    self.fstff_actualText = text;
    if (!self.fstff_secure) {
        [self fstff_setText:text];
    } else {
        [self fstff_setText:[self fstff_dotPlaceholderForText:self.fstff_actualText]];
    }
}

- (void)fstff_setSecureTextEntry:(BOOL)secureTextEntry {
    if (!self.fstff_fixed) {
        [self fstff_setSecureTextEntry:secureTextEntry];
        return;
    }

    if (secureTextEntry) {
        [self fstff_setSecureTextEntry:self.editing]; // super setSecureTextEntry
    } else {
        [self fstff_setSecureTextEntry:secureTextEntry]; // super setSecureTextEntry
    }
    self.fstff_secure = secureTextEntry;
    self.text = self.fstff_actualText;
}

#pragma mark - Actions

- (void)fstff_editingDidBegin {
    if (self.fstff_secure) {
        [self fstff_setSecureTextEntry:YES]; // super setSecureTextEntry;
        [self fstff_setText:self.fstff_actualText]; // super setText
    }
}

- (void)fstff_editingChanged {
    self.fstff_actualText = self.fstff_text; // super text
}

- (void)fstff_editingDidEnd {
    if (self.fstff_secure) {
        [self fstff_setSecureTextEntry:NO]; // super setSecureTextEntry
        [self fstff_setText:[self fstff_dotPlaceholderForText:self.fstff_actualText]]; // super setText
    }
}

@end
