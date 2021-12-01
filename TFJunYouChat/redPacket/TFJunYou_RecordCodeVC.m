#import "TFJunYou_RecordCodeVC.h"
#import "TFJunYou_RecordTBCell.h"
@interface TFJunYou_RecordCodeVC ()
@end
@implementation TFJunYou_RecordCodeVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        _dataArr = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customView];
    [self getServerData];
}
-(void)getServerData{
    [_wait start];
    [g_server getConsumeRecord:_page toView:self];
}
- (void)customView{
    self.title = Localized(@"JXRecordCodeVC_Title");
    [self createHeadAndFoot];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.allowsSelection = NO;
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
-(void)getDataObjFromArr:(NSMutableArray*)arr{
    [_table reloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFJunYou_RecordTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TFJunYou_RecordTBCell"];
    NSDictionary * cellModel = _dataArr[indexPath.row];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TFJunYou_RecordTBCell" owner:self options:nil][0];
    }
    cell.titleLabel.text = cellModel[@"desc"];
    NSTimeInterval  creatTime = [cellModel[@"time"]  doubleValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:creatTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    cell.timeLabel.text = [dateFormatter stringFromDate:date];
    NSString *symbolStr;
    int type = [cellModel[@"type"] intValue];
    if (type == 2 || type == 4 || type == 7 || type == 10 || type == 12 || type == 14) {
        symbolStr = @"-";
        cell.moneyLabel.textColor = [UIColor blackColor];
    }else {
        symbolStr = @"+";
        cell.moneyLabel.textColor = THEMECOLOR;
    }
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@%@ %@",symbolStr,cellModel[@"money"],Localized(@"JX_ChinaMoney")];
    cell.refundLabel.text = @"";
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    [self stopLoading];
    if ([aDownload.action isEqualToString:act_consumeRecord]) {
        if (dict == nil) {
            return;
        }
        _footer.hidden = [(NSArray *)dict[@"pageData"] count] < 20;
        if(_page == 0){
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:dict[@"pageData"]];
        }else{
            if([(NSArray *)dict[@"pageData"] count]>0){
                [_dataArr addObjectsFromArray:dict[@"pageData"]];
            }
        }
        _page ++;
        [self getDataObjFromArr:_dataArr];
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    [self stopLoading];
    return hide_error;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
