//
//  XQThemeMacro.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/24.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#ifndef XQThemeMacro_h
#define XQThemeMacro_h

#define kColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kColorRGB(r, g, b) kColorRGBA(r, g, b, 1)
#define kColorRandom kColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define kColorFromHex(s) kColorRGB(((s&0xFF0000)>>16), ((s&0xFF00)>>8), (s&0xFF))

#define kGetImage(name) [UIImage imageNamed:(name)]

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

//屏幕适配
#define CCVSuitParam (kScreenW)/375.0   //375根据设计图宽度
#define KSuitParam(R) R * CCVSuitParam


// 字体适配
#define kScaleWidth(width) ((width)*(kScreenW/375.f))
#define IsIphone6P kScreenW==414
#define SizeScale (IsIphone6P ? 414/375.f : 1)
#define kPingFangFont(s) [UIFont fontWithName:@"PingFangSC-Regular" size:((s)*CCVSuitParam)]
#define kPingFangMediumFont(s) [UIFont fontWithName:@"PingFangSC-Medium" size:((s)*CCVSuitParam)]

// iPhoneX statusBar的高度为44 其他的为20
#define kStatusBarFrame [[UIApplication sharedApplication] statusBarFrame]

#define kIphoneXSafeAreaInsetBottom 34

#define kNavigationBarMaxY (CGRectGetHeight(kStatusBarFrame) + 44)

#define kCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 比例
#define kRadioH (kScreenH / 677.0)
#define kRadioW (kScreenW / 375.0)

// px py 为美工给的大小
#define kCal_x(px) ((px)/2.0 * kRadioW)
#define kCal_y(py) ((py)/2.0 * kRadioH)

// iPhone X/XS:      375pt * 812pt (@3x)
// iPhone XS Max:    414pt * 896pt (@3x)
// iPhone XR:        414pt * 896pt (@2x)
//#define kIsiPhoneX ((kScreenH == 812.0f) || (kScreenH == 896.0f))
// @see: https://kangzubin.com/iphonex-detect/
#define kIsiPhoneX \
({BOOL isPhoneX = NO;\
if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {\
CGFloat maxLength = kScreenW > kScreenH ? kScreenW : kScreenH;\
if (maxLength == 812.0f || maxLength == 896.0f) {\
isPhoneX = YES;\
}\
}\
(isPhoneX);})

#ifndef __OPTIMIZE__
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

#define sxDelay(seconds, block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), block)

//数据验证
#define StrValid(f) (f!=nil &&[f isKindOfClass:[NSString class]]&& ![f isEqualToString:@""])

#define SafeStr(f) (StrValid(f)?f:@"")

#define HasString(str,eky) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)

#define ValidDict(f) (f!=nil &&[f isKindOfClass:[NSDictionary class]])

#define ValidArray(f) (f!=nil &&[f isKindOfClass:[NSArray class]]&&[f count]>0)

#define ValidNum(f) (f!=nil &&[f isKindOfClass:[NSNumber class]])

#define ValidClass(f,cls) (f!=nil &&[f isKindOfClass:[cls class]])

#define ValidData(f) (f!=nil &&[f isKindOfClass:[NSData class]])

// notify
#define kPostNotifyName(n) [[NSNotificationCenter defaultCenter] postNotificationName:(n) object:nil]

#endif /* XQThemeMacro_h */
