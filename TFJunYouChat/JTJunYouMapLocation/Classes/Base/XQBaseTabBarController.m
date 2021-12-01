//
//  XQBaseTabBarController.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/24.
//  Copyright © 2020 zengwOS.  All rights reserved.
//

#import "XQBaseTabBarController.h"
#import "XQBaseNavigationController.h"
#import "XQCompassViewController.h"
#import "XQMapViewController.h"
#import "XQSettingViewController.h"

@interface XQBaseTabBarController ()

@end

@implementation XQBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [CYTabBarConfig shared].selectedTextColor = kColorFromHex(0xf4ea2a);
        [CYTabBarConfig shared].textColor = kColorFromHex(0xffffff);
        [CYTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedAlone;
        [CYTabBarConfig shared].selectIndex = 0;
//        [CYTabBarConfig shared].centerBtnIndex = 1;
//        [CYTabBarConfig shared].bulgeHeight = 8.0f;
        [CYTabBarConfig shared].backgroundColor = [UIColor blackColor];
        self.tabBar.translucent = NO;
        [self addChildViewControllers];
        
    }
    return self;
}


- (void)addChildViewControllers {
    [self addChildController:[[XQBaseNavigationController alloc] initWithRootViewController:[XQMapViewController new]] title:@"地图" imageName:@"map" selectedImageName:@"map_selected"];
    [self addChildController:[XQCompassViewController new] title:@"指南针" imageName:@"compass" selectedImageName:@"compass_selected"];
    [self addChildController:[[XQBaseNavigationController alloc] initWithRootViewController:[XQSettingViewController new]] title:@"设置" imageName:@"setting" selectedImageName:@"setting_selected"];
    
//    [self addCenterController:[XQCompassViewController new] bulge:YES title:@"指南针" imageName:@"compass_center" selectedImageName:@"compass_center"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
