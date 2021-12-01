#import "TFJunYou_LikeListViewController.h"
#import "TFJunYou_UserInfoVC.h"
#import "TFJunYou_Cell.h"
@interface TFJunYou_LikeListViewController ()
@property (nonatomic, strong) NSArray *data;
@end
@implementation TFJunYou_LikeListViewController
- (instancetype)init {
    if (self = [super init]) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        [self createHeadAndFoot];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%d%@",self.weibo.praiseCount,Localized(@"WeiboData_PerZan1")];
    if (self.weibo.praises.count > 20) {
        self.weibo.praises = [NSMutableArray arrayWithArray:[self.weibo.praises subarrayWithRange:NSMakeRange(0, 20)]];
    }
}
- (void)getServerData {
    [g_server listPraise:self.weibo.messageId pageIndex:_page pageSize:20 praiseId:nil toView:self];
}
- (void)scrollToPageDown {
    [super scrollToPageDown];
}
#pragma mark - Table view     --------代理--------     data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weibo.praises.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 59;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"TFJunYou_LikeListCell";
    TFJunYou_Cell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [[TFJunYou_Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TFJunYou_WeiboReplyData *data = self.weibo.praises[indexPath.row];
    cell.title = data.userNickName;
    cell.index = (int)indexPath.row;
    cell.delegate = self;
    cell.timeLabel.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 120-20, 9, 115, 20);
    cell.userId = data.userId;
    [cell.lbTitle setText:cell.title];
    [cell headImageViewImageWithUserId:nil roomId:nil];
    cell.isSmall = YES;
    [self doAutoScroll:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TFJunYou_WeiboReplyData *data = self.weibo.praises[indexPath.row];
    TFJunYou_UserInfoVC *userVC = [TFJunYou_UserInfoVC alloc];
    userVC.userId = data.userId;
    userVC.fromAddType = 6;
    userVC = [userVC init];
    [g_navigation pushViewController:userVC animated:YES];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [self stopLoading];
    [g_wait stop];
    if ([aDownload.action isEqualToString:act_PraiseList]) {
        if (_page == 0) {
            [self.weibo.praises removeAllObjects];
        }
        for (int i = 0; i < array1.count; i++) {
            TFJunYou_WeiboReplyData * reply=[[TFJunYou_WeiboReplyData alloc]init];
            reply.type=reply_data_praise;
            [reply getDataFromDict:[array1 objectAtIndex:i]];
            [self.weibo.praises addObject:reply];
        }
        [_table reloadData];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [g_wait stop];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [g_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [g_wait start:nil];
}
@end
