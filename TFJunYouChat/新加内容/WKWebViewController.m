//
//  WKWebViewController.m
//  TFJunYouChat
//
//  Created by Leroy Garcia on 12/1/21.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

#import "LXFloaintButton.h"

@interface WKWebViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (nonatomic, strong) LXFloaintButton *floatBtn;
@end

@implementation WKWebViewController
-(LXFloaintButton *)floatBtn{
    if(!_floatBtn){
        _floatBtn = [LXFloaintButton buttonWithType:0];
        [self.view addSubview:_floatBtn];
        
        [_floatBtn setBackgroundImage:[UIImage imageNamed:@"btn_float_fresh"] forState:0];
        [_floatBtn addTarget:self action:@selector(floatBTNAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _floatBtn.frame = CGRectMake(0, self.view.bounds.size.height /4, 46, 46);
        _floatBtn.layer.cornerRadius = 25;

        UIEdgeInsets insets = self.view.window.safeAreaInsets;
        _floatBtn.safeInsets = insets;
        _floatBtn.parentView = self.view;
    }
    return _floatBtn;
}

-(void)floatBTNAction:(LXFloaintButton *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.backgroundColor = [UIColor whiteColor];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    NSURL *ebURL = [NSURL URLWithString: @"https://mallplaza.vip"];
    NSURLRequest *req = [NSURLRequest requestWithURL:ebURL];
    [_webView loadRequest:req];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURL *ebURL = [NSURL URLWithString: @"https://mallplaza.vip"];
    NSURLRequest *req = [NSURLRequest requestWithURL:ebURL];
    [_webView loadRequest:req];
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.view bringSubviewToFront:self.floatBtn];
    [self.view bringSubviewToFront:self.imageView];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    double progress = _webView.estimatedProgress;
    if (progress >= 0.99) {
        __weak typeof (self)weakSelf = self;
        [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakSelf.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.imageView.hidden = YES;
        }];
    }
}
@end
