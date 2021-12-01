#import "TFJunYou_userWeiboVC.h"
@interface TFJunYou_userWeiboVC ()
@end
@implementation TFJunYou_userWeiboVC
- (id)init
{
    self.isNotShowRemind = YES;
    self = [super init];
    if (self) {
            self.title = self.user.userNickname;
    }
    return self;
}
- (void)dealloc {
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)getServerData{
    [self stopLoading];
    [g_App.jxServer getUserMessage:self.user.userId messageId:[self getLastMessageId:self.datas] toView:self];
}
@end
