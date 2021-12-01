//
//  TFJunYou_PublishVc.m
//  TFJunYouChat
//
//  Created by mac on 2020/9/24.
//  Copyright © 2020 zengwOS. All rights reserved.
//
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define Margin 10
#define RootV [UIApplication sharedApplication].keyWindow.rootViewController.view

#import "TFJunYou_PublishVc.h"

#import "TFJunYou_TGPublishV.h"
#import "TFJunYou_TGPostWordVC.h"
#import "JTJunYou_TGFastBtn.h"
#import "JTJunYou_TGNavigationVC.h"
#import "UIView+LK.h"
#import <POP.h>
#import "JTYouJun_ContaintMapVc.h"

// 浏览器
//#import "BrowserViewController.h"
//计算器
#import "TFJunYou_CalculatorVc.h"
//天气
#import "ViewController.h"
//笔记本
#import "TFJunYouChat_MainNoteVc.h"

//闹钟


//PDF阅读
#import "ReaderDocument.h"
#import "ReaderViewController.h"
#import "XKFileManager.h"
#import "XKNetworkHelper.h"


static CGFloat const AnimationDelay = 0.1;
static CGFloat const SpringFactor = 10;


@interface TFJunYou_PublishVc ()<ReaderViewControllerDelegate>
@property (weak, nonatomic) UIImageView *topIMG;
@property (nonatomic, assign) int pageNum;

@property (nonatomic,weak)  UIView *backView ;
@end

@implementation TFJunYou_PublishVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGB(245, 245, 247);
    UIButton  *cancelButton=[[UIButton alloc]init];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor=RGB(245, 245, 247);
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        
    }];
    
    
    UIImageView *backIMG=[[UIImageView alloc]init];
    backIMG.image=[UIImage imageNamed:@"shareBottomBackground"];
    backIMG.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:backIMG];
    [backIMG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(cancelButton.mas_top);
        
    }];
    
      
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createPopUI];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self cancelWithCompletionBlock:nil];
}

- (void)createPopUI{
    
   UIView *backView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenW, SCREEN_HEIGHT)];
   [self.view addSubview:backView];
    self.backView=backView;
    
    RootV.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    NSArray *titles = @[@"地图",@"记事本",@"计算器"];
    NSArray *images = @[@"地图地图",@"publish-text",@"计算器"];
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    NSInteger maxCols = 3;
    CGFloat buttonStratX = 2 * Margin;
    CGFloat buttonXMargin = (ScreenW - 2 * buttonStratX - maxCols * buttonW) / (maxCols - 1);
    CGFloat buttonYMargin = Margin;
    CGFloat buttonStratY = (ScreenH - 2 * buttonH) * 0.5;
    for (NSInteger i = 0 ; i < titles.count; i++) {
        JTJunYou_TGFastBtn *button = [JTJunYou_TGFastBtn buttonWithType:UIButtonTypeCustom];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSInteger row = i / maxCols;
        NSInteger col = i % maxCols;
        CGFloat buttonX = buttonStratX + col * (buttonW + buttonXMargin);
        CGFloat buttonEndY = buttonStratY + row * (buttonH + buttonYMargin);
        CGFloat buttonBeginY = buttonEndY - ScreenH;
        [backView addSubview:button];
        
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.springSpeed = SpringFactor;
        anim.springBounciness = SpringFactor;
        anim.beginTime = CACurrentMediaTime() + AnimationDelay * i;
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    UIImageView *titleImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    titleImageV.y = ScreenH * 0.15 - ScreenH;
    [self.view addSubview:titleImageV];
    CGFloat centerX = ScreenW * 0.5;
    CGFloat titleStartY = titleImageV.y;
    CGFloat titleEndY = ScreenH * 0.15;
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    [titleImageV pop_addAnimation:anim forKey:nil];
    anim.springSpeed = SpringFactor;
    anim.springBounciness = SpringFactor;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, titleStartY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, titleEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * AnimationDelay;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        RootV.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)cancel:(id)sender {
    [self cancelWithCompletionBlock:nil];
}

- (void)cancelWithCompletionBlock:(void(^)(void))completionBlock{
    RootV.userInteractionEnabled = NO;
    self.view.userInteractionEnabled = NO;
    NSInteger beginI = 2;
    for (NSInteger i = beginI; i < self.view.subviews.count; i++) {
        UIView *currentView = self.view.subviews[i];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat endY = currentView.y + ScreenH;
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(currentView.centerX, endY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginI) * AnimationDelay;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [currentView pop_addAnimation:anim forKey:nil];
        if (i == self.view.subviews.count - 1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                RootV.userInteractionEnabled =YES;
                self.view.userInteractionEnabled = YES;
                [self.backView removeFromSuperview];
                !completionBlock ? : completionBlock();
            }];
        }
    }
}

- (void)btnClick:(JTJunYou_TGFastBtn *)button{
    
    _pageNum=1;
 
    
    [self cancelWithCompletionBlock:^{
       // TGLog(@"点击%@",button.titleLabel.text);
        
//        if (button.tag == 0){/// 浏览器
//            BrowserViewController *postWordVc = [[BrowserViewController alloc] init];
//            JTJunYou_TGNavigationVC *nav = [[JTJunYou_TGNavigationVC alloc]initWithRootViewController:postWordVc];
//            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
//            [root presentViewController:postWordVc animated:YES completion:nil];
//            return;
//        }
         
        if (button.tag == 0){ ///地图
            JTYouJun_ContaintMapVc *postWordVc = [[JTYouJun_ContaintMapVc alloc] init];
            JTJunYou_TGNavigationVC *nav = [[JTJunYou_TGNavigationVC alloc]initWithRootViewController:postWordVc];
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
            return;
        }
        
        if (button.tag == 1){ /// 笔记本
            TFJunYouChat_MainNoteVc *postWordVc = [[TFJunYouChat_MainNoteVc alloc] init];
            JTJunYou_TGNavigationVC *nav = [[JTJunYou_TGNavigationVC alloc]initWithRootViewController:postWordVc];
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
            return;
        }
        if (button.tag == 2){ //计算器
            TFJunYou_CalculatorVc *postWordVc = [[TFJunYou_CalculatorVc alloc] init];
            //JTJunYou_TGNavigationVC *nav = [[JTJunYou_TGNavigationVC alloc]initWithRootViewController:postWordVc];
           // UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [self presentViewController:postWordVc animated:YES completion:nil];
            
            return;
        }
 
        if (button.tag == 4){ //天气
            
            [[NSNotificationCenter defaultCenter] addObserverForName:@"pushAlert" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
                ViewController *postWordVc = [[ViewController alloc] init];
                JTJunYou_TGNavigationVC *nav = [[JTJunYou_TGNavigationVC alloc]initWithRootViewController:postWordVc];
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                [root presentViewController:postWordVc animated:YES completion:nil];
                
            }];
            
           
            return;
        }
        
          if (button.tag==3) {
               
               ReaderDocument *doc = [[ReaderDocument alloc] initWithFilePath:[XKFileManagerInstance xk_GetMainBundlePathForResource:@"xktest" ofType:@"pdf"] password:nil]; //解析pdf文件
               
               ReaderViewController *rederVC = [[ReaderViewController alloc] initWithReaderDocument:doc];
       //        rederVC.delegate = self;
               rederVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
               rederVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
               UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
               [self presentViewController:rederVC animated:YES completion:nil];
               
           }
        
    }];
}

-(void)dismissReaderViewController:(ReaderViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}


@end
