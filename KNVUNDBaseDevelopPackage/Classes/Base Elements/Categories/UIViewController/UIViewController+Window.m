//
//  UIViewController+Window.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 26/9/19.
//

#import "UIViewController+Window.h"

#import <objc/runtime.h>

@interface UIViewController (Private)

@property (nonatomic, strong) UIWindow *newWindow;

@end

@implementation UIViewController (Private)

@dynamic newWindow;

- (void)setNewWindow:(UIWindow *)newWindow {
    objc_setAssociatedObject(self, @selector(newWindow), newWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)newWindow {
    return objc_getAssociatedObject(self, @selector(newWindow));
}

@end

@implementation UIViewController (Window)

#pragma mark - Methods to Override
+ (UIWindowLevel)windowLevel
{
    return UIWindowLevelNormal;
}

#pragma mark - General Methods
- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.newWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.newWindow.rootViewController = [[UIViewController alloc] init];
        self.newWindow.windowLevel = [[self class] windowLevel];
        [self.newWindow makeKeyAndVisible];
        [self.newWindow.rootViewController presentViewController:self animated:animated completion:nil];
    });
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // precaution to insure window gets destroyed
    self.newWindow.hidden = YES;
    self.newWindow = nil;
}

- (void)dismiss {
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.newWindow.rootViewController dismissViewControllerAnimated:animated completion:nil];
    });
}

@end
