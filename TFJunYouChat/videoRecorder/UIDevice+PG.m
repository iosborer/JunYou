//
//  UIDevice+PG.m
//  TFJunYouChat
//
//  Created by JayLuo on 2020/9/8.
//  Copyright © 2020 Reese. All rights reserved.
//

#import "UIDevice+PG.h"

@implementation UIDevice (PG)
static inline void pg_swizzleSelector(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)load {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 13.0) {
        pg_swizzleSelector(UIDevice.class, @selector(endGeneratingDeviceOrientationNotifications), @selector(pgEndGeneratingDeviceOrientationNotifications));
    }
}

- (void)pgEndGeneratingDeviceOrientationNotifications {
    NSLog(@"pgEndGeneratingDeviceOrientationNotifications isMainThread:%d", [NSThread isMainThread]);
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pgEndGeneratingDeviceOrientationNotifications];
        });
        return;
    }
    [self pgEndGeneratingDeviceOrientationNotifications];
}
@end
