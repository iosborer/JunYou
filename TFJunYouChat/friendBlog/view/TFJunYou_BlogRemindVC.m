#import "TFJunYou_BlogRemindVC.h"
#import "TFJunYou_BlogRemind.h"
#import "TFJunYou_BlogRemindCell.h"
#import "TFJunYou_WeiboVC.h"
@interface TFJunYou_BlogRemindVC ()
@property (nonatomic, assign) BOOL isHaveMore;
@end
@implementation TFJunYou_BlogRemindVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"JX_NewMessage");
    self.isHaveMore = YES;
    self.isGotoBack = YES;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    [self createHeadAndFoot];
    self.isShowFooterPull = NO;
    UIButton* btn = [UIFactory createButtonWithTitle:Localized(@"JX_Clear") titleFont:[UIFont systemFontOfSize:15] titleColor:[UIColor whiteColor] normal:nil highlight:nil];
    [btn setTitleColor:THESIMPLESTYLE ? [UIColor blackColor] : [UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClear) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-32-15, TFJunYou__SCREEN_TOP - 30, 32, 15);
    [self.tableHeader addSubview:btn];
    if (self.isShowAll) {
        self.remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetch];
        self.isHaveMore = NO;
        [_table reloadData];
    }
    [g_notify addObserver:self selector:@selector(remindNotif:) name:kXMPPMessageWeiboRemind object:nil];
}
- (void) remindNotif:(NSNotification *)notif {
    _remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
    [_table reloadData];
}
- (void) onClear {
    [[TFJunYou_BlogRemind sharedInstance] deleteAllMsg];
    [self.remindArray removeAllObjects];
    self.isHaveMore = NO;
    [_table reloadData];
}
#pragma mark   ---------tableView协议----------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.remindArray.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellName"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 30)];
        label.textColor = [UIColor grayColor];
        label.font = g_factory.font14;
        label.text = Localized(@"JX_GetPreviousMessage");
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        return cell;
    }
    NSString* cellName = [NSString stringWithFormat:@"TFJunYou_BlogRemindCell"];
    TFJunYou_BlogRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[TFJunYou_BlogRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];;
    }
    TFJunYou_BlogRemind *br = self.remindArray[indexPath.row];
    [cell doRefresh:br];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isHaveMore) {
        return self.remindArray.count + 1;
    }else {
        return self.remindArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.remindArray.count) {
        return 85;
    }
    TFJunYou_BlogRemind *br = self.remindArray[indexPath.row];
    NSString *content = br.content;
    if (br.toUserName.length > 0)
        content = [NSString stringWithFormat:@"%@%@: %@", Localized(@"JX_Reply"),br.toUserName, br.content];
    CGSize size = [content boundingRectWithSize:CGSizeMake(TFJunYou__SCREEN_WIDTH - 60 - 10 - 85, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYSFONT(15)} context:nil].size;
    if (size.height > 20) {
        return 85 - 20 + size.height;
    }
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.remindArray.count) {
        self.remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetch];
        self.isHaveMore = NO;
        [_table reloadData];
        return;
    }
    TFJunYou_BlogRemind *br = self.remindArray[indexPath.row];
    TFJunYou_WeiboVC *weibo = [TFJunYou_WeiboVC alloc];
    weibo.detailMsgId = br.objectId;
    weibo.isDetail = YES;
    weibo = [weibo init];
    [g_navigation pushViewController:weibo animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
