//
//  JTYouJun_ContaintMapVc.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "JTYouJun_ContaintMapVc.h"
#import "UIView+LK.h"
#import "XQMapViewController.h"
#import "XQCompassViewController.h"

@interface JTYouJun_ContaintMapVc ()<UIScrollViewDelegate>
/** 标签栏底部的红色指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIButton *button_n;
@property (weak, nonatomic) UIView *sliderView;
@property (strong, nonatomic) MASConstraint *sliderViewCenterX;

@end

@implementation JTYouJun_ContaintMapVc


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];

    [self setupContentView];
    [self setupTitlesView];

}
 
-(void)setupContentView
{
    UIScrollView *contentView = [[UIScrollView alloc] init]; contentView.backgroundColor = RGB(250, 250, 250); contentView.frame = CGRectMake(0, TFJunYou__SCREEN_TOP, self.view.bounds.size.width, self.view.bounds.size.height-TFJunYou__SCREEN_TOP);
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self; contentView.showsHorizontalScrollIndicator = NO; contentView.showsVerticalScrollIndicator = NO; contentView.pagingEnabled = YES;
    contentView.bounces=NO;
    contentView.scrollEnabled=NO;
    contentView.contentSize = CGSizeMake(contentView.xmg_width *  self.childViewControllers.count, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
    
    
    return;
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate; UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [contentView addGestureRecognizer:pan];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc]       initWithTarget:self action:@selector(swipeAction:)]; swipeRight.direction = UISwipeGestureRecognizerDirectionLeft; [contentView addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer * swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    swipeleft.direction = UISwipeGestureRecognizerDirectionRight; [contentView addGestureRecognizer:swipeleft];
    // 手势的优先级 优先响应swipe手势
    [pan requireGestureRecognizerToFail:swipeRight];
    [pan requireGestureRecognizerToFail:swipeleft];

 }
 
-(void)setupTitlesView{
    
    
    UIView *titlesView = [[UIView alloc] init]; titlesView.backgroundColor = [UIColor blackColor]; titlesView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    titlesView.frame = CGRectMake(0, 0, self.view.frame.size.width,   44);
    [self.view addSubview:titlesView];
    self.navigationItem.titleView=titlesView;
    self.titlesView = titlesView;
    //
    // 5个按钮
    UIButton *button = [self setupTitleButton:@"地图"];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [self setupTitleButton:@"指南针"];
    [self titleClick:button];
    [self switchController:0];
    self.topButton=button;

 // 底部滑条
    UIView *sliderView = [[UIView alloc] init]; sliderView.backgroundColor = [UIColor redColor];
    [self.titlesView addSubview:sliderView];
    self.sliderView = sliderView;
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([[button titleForState:UIControlStateNormal] sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width/1.5, 3));
     
        make.bottom.mas_equalTo(self.titlesView.mas_bottom).mas_offset(-4);
        self.sliderViewCenterX = make.centerX.equalTo(button);
        
    }];
 
}
 
- (UIButton *)setupTitleButton:(NSString *)title {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(titleClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.titlesView addSubview:button]; self.topButton=button;
    [button mas_makeConstraints:^(MASConstraintMaker *make) { make.width.mas_equalTo(self.titlesView.xmg_width/3);
        make.top.mas_equalTo(0);
        NSUInteger index = self.titlesView.subviews.count - 1;
        if (index == 0) {
            make.left.mas_equalTo(self.titlesView.xmg_width/6);
            
        } else {
            make.left.mas_equalTo(self.titlesView.xmg_width/3*4.5);
        }
        
    }];
    return button;
    
    
}
- (void)titleClick:(UIButton *)button {
    
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 消除约束 [self.sliderViewCenterX uninstall]; self.sliderViewCenterX = nil;
    // 添加约束
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.sliderViewCenterX = make.centerX.equalTo(button);
        
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.sliderView layoutIfNeeded];
    }];
    
    int index = (int)[self.titlesView.subviews indexOfObject:button];
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
    
}

- (void)setupNavBar {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}
- (void)setupChildViewControllers {
    
    

    [self addChildViewController:[XQMapViewController new]];
    [self addChildViewController:[XQCompassViewController new]];
   
 
    
}
- (void)setupOneChildViewController:(UIViewController *)type {
    
    if([type isKindOfClass:[XQCompassViewController class]]){
        XQCompassViewController *vc = [[XQCompassViewController alloc] init];
        [self addChildViewController:vc];
    }else{
        XQMapViewController *vc = [[XQMapViewController alloc] init];
        [self addChildViewController:vc];
        
    }
}
- (void)switchController:(int)index {
     
    
  
    XQMapViewController *vc = self.childViewControllers[index]; vc.view.xmg_y = 0;
    vc.view.xmg_width = self.contentView.xmg_width; vc.view.xmg_height = self.contentView.xmg_height; vc.view.xmg_x = vc.view.xmg_width * index;
    [self.contentView addSubview:vc.view];
    
 
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {
int index = scrollView.contentOffset.x / scrollView.frame.size.width;
[self titleClick:self.titlesView.subviews[index]]; [self switchController:index];
}
- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView {
int a=(int)(scrollView.contentOffset.x / scrollView.frame.size.width);
[self switchController:a]; }
@end

 
