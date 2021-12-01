#import "CYWebAddPointVC.h"
#import <WebKit/WebKit.h>
@interface CYWebAddPointVC ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *wkWebView;
@end
@implementation CYWebAddPointVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack   = NO;
    self.title = self.name;
    [self createHeadAndFoot];
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP, self_width,self_height- TFJunYou__SCREEN_TOP-TFJunYou__SCREEN_BOTTOM)];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL]]];
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self setupUI];
}
- (void)setupUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"刷新";
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonClick)]];
    label.userInteractionEnabled = YES;
    [self setRightBarButtonItem:rItem];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label1.text = @"主页";
    UIBarButtonItem *lItem = [[UIBarButtonItem alloc] initWithCustomView:label1];
    [label1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonClick)]];
    label1.userInteractionEnabled = YES;
    [self setLeftBarButtonItem:lItem];
}
- (void)rightButtonClick {
    [self.wkWebView reload];
}
- (void)leftButtonClick {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL]]];
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString * urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"发送跳转请求：%@",urlStr);
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSString * urlStr = navigationResponse.response.URL.absoluteString;
    NSLog(@"当前跳转地址：%@",urlStr);
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
     [SVProgressHUD showWithStatus:@"正在加载中..."];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
     [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
     [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
     [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
     [SVProgressHUD dismiss];
}
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [SVProgressHUD dismiss];
}
@end
