#import "TFJunYou_LaunchVc.h"
@interface TFJunYou_LaunchVc ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIImageView *imgView;
@end
@implementation TFJunYou_LaunchVc{
    int a ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.imgView.image = [UIImage imageNamed:@"launch2688"];
    [self.view addSubview:self.imgView];
   [g_server getCompanyAuto:self];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), ^{
                [weakSelf goToLoginVc];
            });
        }else {
            [g_App showAlert:@"网络不可用，请检查网络"];
        }
    }];
}
-(void)gotoLoginClick{
    [self.timer invalidate];
    self.timer = nil;
    [g_App showLoginUI];
}
-(void)goToLoginVc{
    if (a == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"cylunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [g_App showLoginUI];
        [self.timer invalidate];
        self.timer = nil;
    }
    [self.button setTitle:[NSString stringWithFormat:@"跳过 %ds",a] forState:UIControlStateNormal];
    a -= 1;
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
}
@end
