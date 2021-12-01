//
//  TFJunYou_admobViewController.m
//  TFJunYouChat
//
//  Created by lifengye on 2020/7/15.
//  Copyright © 2020 zengwOS. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "AppDelegate.h"
#import "TFJunYou_versionManage.h"
#import "TFJunYou_ImageView.h"
#import "TFJunYou_Label.h"
#import "UIImage+Tint.h"


@implementation TFJunYou_admobViewController

#define AdMob_REFRESH_PERIOD 60.0 // display fresh ads once per second

-(id)init{
    self = [super init];
    _heightHeader=TFJunYou__SCREEN_TOP;
    _heightFooter=TFJunYou__SCREEN_BOTTOM;
    _isFreeOnClose = YES;
    [g_window endEditing:YES];
    //self.view.frame = CGRectMake(TFJunYou__SCREEN_WIDTH, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _heightHeader=TFJunYou__SCREEN_TOP;
        _heightFooter=49;
        _isFreeOnClose = YES;

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isGotoBack) {
//        self.view.frame = CGRectMake(TFJunYou__SCREEN_WIDTH, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
        
//        [self screenEdgePanGestureRecognizer];
    }
    _wait = [ATMHud sharedInstance];
    if (THESIMPLESTYLE) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }

//    _pSelf = self;
}


//创建边缘手势
-(void)screenEdgePanGestureRecognizer
{
    
    UIScreenEdgePanGestureRecognizer *screenPan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenPanAction:)];
    screenPan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenPan];
    
    [self.tableBody.panGestureRecognizer requireGestureRecognizerToFail:screenPan];
    
}
//边缘手势事件
-(void)screenPanAction:(UIScreenEdgePanGestureRecognizer *)screenPan
{
    
    CGPoint p = [screenPan translationInView:self.view];
    NSLog(@"p = %@",NSStringFromCGPoint(p));
    self.view.frame = CGRectMake(p.x, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    if (screenPan.state == UIGestureRecognizerStateEnded) {
        if (p.x > TFJunYou__SCREEN_WIDTH/2) {
            [self actionQuit];
        }else {
            [self resetViewFrame];
        }
    }
    
}

- (void)dealloc {
    NSLog(@"dealloc - %@",[self class]);
    self.title = nil;
    self.headerTitle = nil;
//    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"CurrentController = %@",[self class]);
    //页面zuo移
//    if (self.isGotoBack) {
//        if (self.view.frame.origin.x != 0) {
////            UIView *view = g_window.subviews.lastObject;
//            [UIView animateWithDuration:0.3 animations:^{
////                view.frame = CGRectMake(-85, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
//                //自己归位
//                [self resetViewFrame];
//            }];
//        }
//    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//================== 定制的


-(void)createHeadAndFootCancel:(NSString *)title colorStr:(UIColor *)backColor {
    int heightTotal = self.view.frame.size.height;

    if(_heightHeader>0){
        [self createHeadeCancelView:title  colorStr:backColor];
        [self.view addSubview:_tableHeader];
    }
    if(_heightFooter>0){
        [self createFooterView];
        [self.view addSubview:_tableFooter];
        _tableFooter.frame = CGRectMake(0,heightTotal-_heightFooter,self_width,_heightFooter);
    }

    _tableBody = [[UIScrollView alloc]init];
    _tableBody.userInteractionEnabled = YES;
    _tableBody.backgroundColor = [UIColor whiteColor];
    _tableBody.showsVerticalScrollIndicator = NO;
    _tableBody.showsHorizontalScrollIndicator = NO;
    _tableBody.frame =CGRectMake(0,_heightHeader,self_width,heightTotal-_heightHeader-_heightFooter);
    _tableBody.contentSize = CGSizeMake(self_width, _tableBody.frame.size.height + LINE_WH);
    [self.view addSubview:_tableBody];
//    [tableBody release];
}

-(void)createHeadeCancelView:(NSString *)title colorStr:(UIColor *)backColor {
    _tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, _heightHeader)];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, _heightHeader)];
    
//    if (THESIMPLESTYLE) {
//        iv.image = [[UIImage imageNamed:@"navBarBackground"] imageWithTintColor:[UIColor whiteColor]];
//    }else {
//        iv.image = [g_theme themeTintImage:@"navBarBackground"];//[UIImage imageNamed:@"navBarBackground"];
//    }
    iv.backgroundColor = backColor;
    iv.userInteractionEnabled = YES;
    [_tableHeader addSubview:iv];
    
        
    TFJunYou_Label* p = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(60, TFJunYou__SCREEN_TOP -15- 17, TFJunYou__SCREEN_WIDTH-60*2, 20)];
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor];;
    p.text = self.title;
    p.font = [UIFont systemFontOfSize:18.0];
    p.userInteractionEnabled = YES;
    p.didTouch = @selector(actionTitle:);
    p.delegate = self;
    p.changeAlpha = NO;
    [_tableHeader addSubview:p];

    self.headerTitle = p;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeader addSubview:btn];
     
   
}

//================================  原来的 ======

-(void)createHeaderView{
    _tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, _heightHeader)];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, _heightHeader)];
    
    if (THESIMPLESTYLE) {
        iv.image = [[UIImage imageNamed:@"navBarBackground"] imageWithTintColor:[UIColor whiteColor]];
//        [self LX_SetShadowPathWith:HEXCOLOR(0xD9D9D9) shadowOpacity:0.3 shadowRadius:2 shadowPathWidth:10 view:tableHeader];
    }else {
        iv.image = [g_theme themeTintImage:@"navBarBackground"];//[UIImage imageNamed:@"navBarBackground"];
    }
    iv.userInteractionEnabled = YES;
    [_tableHeader addSubview:iv];
    
        
    TFJunYou_Label* p = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(60, TFJunYou__SCREEN_TOP -15- 17, TFJunYou__SCREEN_WIDTH-60*2, 20)];
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor];;
    p.text = self.title;
    p.font = [UIFont systemFontOfSize:18.0];
    p.userInteractionEnabled = YES;
    p.didTouch = @selector(actionTitle:);
    p.delegate = self;
    p.changeAlpha = NO;
    [_tableHeader addSubview:p];
//    [p release];

    self.headerTitle = p;
    
    if(_isGotoBack){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
        [btn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
        [self.tableHeader addSubview:btn];
    }
}

-(void)createFooterView{
    _tableFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, _heightFooter)];
    _tableFooter.backgroundColor = [UIColor whiteColor];

    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
    line.backgroundColor = THE_LINE_COLOR;
    [_tableFooter addSubview:line];
    UIButton* btn;
    
    if(_isGotoBack)
        return;

    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-76)/2, (49-36)/2, 152/2, 72/2);
//    btn.showsTouchWhenHighlighted = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"singing_button_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"singing_button_press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onSing) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooter addSubview:btn];
//    [btn release];
    self.footerBtnMid = btn;
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-53-5, (49-33)/2, 53, 66/2);
//    btn.showsTouchWhenHighlighted = YES;
    [btn setBackgroundImage:[UIImage imageNamed:@"nearby_button_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"nearby_button_press"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onBtnRight) forControlEvents:UIControlEventTouchUpInside];
    [_tableFooter addSubview:btn];
//    [btn release];
    self.footerBtnRight = btn;
}

-(void)createHeadAndFoot{
    int heightTotal = self.view.frame.size.height;

    if(_heightHeader>0){
        [self createHeaderView];
        [self.view addSubview:_tableHeader];
//        [tableHeader release];
    }
    
    if(_heightFooter>0){
        [self createFooterView];
        [self.view addSubview:_tableFooter];
//        [tableFooter release];
        _tableFooter.frame = CGRectMake(0,heightTotal-_heightFooter,self_width,_heightFooter);
    }

    _tableBody = [[UIScrollView alloc]init];
    _tableBody.userInteractionEnabled = YES;
    _tableBody.backgroundColor = [UIColor whiteColor];
    _tableBody.showsVerticalScrollIndicator = NO;
    _tableBody.showsHorizontalScrollIndicator = NO;
    _tableBody.frame =CGRectMake(0,_heightHeader,self_width,heightTotal-_heightHeader-_heightFooter);
    _tableBody.contentSize = CGSizeMake(self_width, _tableBody.frame.size.height + LINE_WH);
    [self.view addSubview:_tableBody];
//    [tableBody release];
}

-(void) onGotoHome{
    if(self.view.frame.origin.x == 260){
//        [g_App.leftView onClick];
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    
    self.view.frame = CGRectMake (260, 0, self_width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

-(void)actionQuit{
    [_wait stop];
    [g_server stopConnection:self];
    [g_window endEditing:YES];
    [g_notify removeObserver:self];
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [UIView beginAnimations:nil context:context];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:0.2];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(doQuit)];
    
    [g_navigation dismissViewController:self animated:YES];
    
//    self.view.frame = CGRectMake (TFJunYou__SCREEN_WIDTH, 0, self_width, self.view.frame.size.height);
//    NSInteger index = g_window.subviews.count;
//    if (index - 2 >= 0) {
//        UIView *view = g_window.subviews[index - 2];
//        view.frame = CGRectMake (0, 0, self_width, self.view.frame.size.height);
//    }
//    [UIView commitAnimations];
}

-(void)doQuit{
    [self.view removeFromSuperview];
//    if(isFreeOnClose)
//        _pSelf = nil;
}

-(void) setLeftBarButtonItem:(UIBarButtonItem*)button{
    _leftBarButtonItem = button;
//    button.customView.frame = CGRectMake(7, 7, 65, 30);
    button.customView.frame = CGRectMake(25, TFJunYou__SCREEN_TOP - 38, 65, 30);
    [_tableHeader addSubview:button.customView];
//    [button release];
}

-(void) setRightBarButtonItem:(UIBarButtonItem*)button{
    _rightBarButtonItem = button;
    button.customView.frame = CGRectMake(self_width-65, TFJunYou__SCREEN_TOP - 38, 65, 30);
    [_tableHeader addSubview:button.customView];
//    [button release];
}

-(void)onSing{
//    [g_App.leftView onSing];
}

-(void)onBtnRight{
//    [g_App.leftView onNear];
}

-(void)actionTitle:(TFJunYou_Label*)sender{
    
}

-(void)setTitle:(NSString *)value{
    self.headerTitle.text = value;
    [super setTitle:value];
}

//归位
- (void)resetViewFrame{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, self.view.frame.size.height);
    }];
}



-(void)LX_SetShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowPathWidth:(CGFloat)shadowPathWidth
                        view:(UIView *)view {
    
    view.layer.masksToBounds = NO;
    
    view.layer.shadowColor = shadowColor.CGColor;
    
    view.layer.shadowOpacity = shadowOpacity;
    
    view.layer.shadowRadius =  shadowRadius;
    
    view.layer.shadowOffset = CGSizeZero;
    CGRect shadowRect;
    
    CGFloat originX = 0;
    
    CGFloat originW = view.bounds.size.width;
    
    CGFloat originH = view.bounds.size.height;

    shadowRect  = CGRectMake(originX, originH -shadowPathWidth/2, originW, shadowPathWidth);

    UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
    
    view.layer.shadowPath = path.CGPath;

}

@end
