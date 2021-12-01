#import "TFJunYou_RedPacketListVC.h"
#import "TFJunYou_RecordTBCell.h"
@interface TFJunYou_RedPacketListVC ()
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) int selIndex;
@end
@implementation TFJunYou_RedPacketListVC
- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [NSMutableArray array];
    self.isShowFooterPull = YES;
    self.isShowHeaderPull = YES;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 150)];
    headView.backgroundColor = HEXCOLOR(0xFD7070);
    [self.view addSubview:headView];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(headView.frame), TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT - CGRectGetMaxY(headView.frame));
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
    [closeBtn setBackgroundImage:[[UIImage imageNamed:@"title_back_black_big"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:closeBtn];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(60, TFJunYou__SCREEN_TOP -15- 17, TFJunYou__SCREEN_WIDTH-60*2, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = Localized(@"JX_RedPacketRecord");
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:18.0];
    [headView addSubview:title];
    _getBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 37, headView.frame.size.width / 2, 30)];
    [_getBtn setTitle:Localized(@"PACKETS_RECEIVED") forState:UIControlStateNormal];
    [_getBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [_getBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _getBtn.selected = YES;
    _getBtn.tag = 1000;
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_getBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_getBtn];
    _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(headView.frame.size.width / 2, headView.frame.size.height - 37, headView.frame.size.width / 2, 30)];
    [_sendBtn setTitle:Localized(@"ENVELOPES_ISSUED") forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _sendBtn.selected = NO;
    _sendBtn.tag = 1001;
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_sendBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:_sendBtn];
    _selIndex = 0;
    _page = 0;
    [self getServerData];
}
- (void)closeBtnAction:(UIButton *)btn {
    [self actionQuit];
}
- (void)btnAction:(UIButton *)btn {
    if (_selIndex == 0 && btn.tag == 1000) {
        return;
    }
    if (_selIndex == 1 && btn.tag == 1001) {
        return;
    }
    _getBtn.selected = !_getBtn.selected;
    _sendBtn.selected = !_sendBtn.selected;
    _page = 0;
    if (btn.tag == 1000) {
        _selIndex = 0;
    }else {
        _selIndex = 1;
    }
    [self getServerData];
}
- (void)scrollToPageUp {
    _page = 0;
    [self getServerData];
}
- (void)scrollToPageDown {
    _page ++;
    [self getServerData];
}
- (void) getServerData {
    if (_selIndex == 0) {
        [g_server redPacketGetRedReceiveListIndex:_page toView:self];
    }else {
        [g_server redPacketGetSendRedPacketListIndex:_page toView:self];
    }
}
#pragma mark  --------------------TableView-------------------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_array count];
}
-(TFJunYou_RecordTBCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellName = @"TFJunYou_RecordTBCell";
    TFJunYou_RecordTBCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"TFJunYou_RecordTBCell" owner:self options:nil][0];
    }
    NSDictionary *dict = _array[indexPath.row];
    cell.titleLabel.text = dict[@"sendName"];
    if(_selIndex == 1) {
        NSString *str;
        int type = [dict[@"type"] intValue];
        if (type == 1) {
            str = Localized(@"JX_UsualGift");
        }
        if (type == 2) {
            str = Localized(@"JX_LuckGift");
        }
        if (type == 3) {
            str = Localized(@"JX_MesGift");
        }
        cell.titleLabel.text = str;
    }
    NSTimeInterval  getTime = [dict[@"time"] longLongValue];
    if (_selIndex == 1) {
        getTime = [dict[@"sendTime"] longLongValue];
    }
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:getTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    cell.timeLabel.text = [dateFormatter stringFromDate:date];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f %@",[dict[@"money"] doubleValue],Localized(@"JX_ChinaMoney")];
    cell.refundLabel.text = @"";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self stopLoading];
    if (_page == 0) {
        [_array removeAllObjects];
        [_array addObjectsFromArray:array1];
    }else {
        [_array addObjectsFromArray:array1];
    }
    [self.tableView reloadData];
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
