#import "TFJunYou_TransferRecordTableVC.h"
#import "TFJunYou_RecordModel.h"
#import "TFJunYou_RecordCell.h"
@interface TFJunYou_TransferRecordTableVC ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *indexArr;
@end
@implementation TFJunYou_TransferRecordTableVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    [self createHeadAndFoot];
    _array = [[NSMutableArray alloc] init];
    _indexArr = [[NSMutableArray alloc] init];
    self.title = Localized(@"JX_TransferTheDetail");
    _table.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self getServerData];
}
- (void)getServerData {
    [g_server getConsumeRecordList:self.userId pageIndex:_page pageSize:20 toView:self];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.indexArr.count > 0) {
        return self.indexArr.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_array.count > 0) {
        return [(NSArray *)[_array objectAtIndex:section] count];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TFJunYou_RecordCell";
    TFJunYou_RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_RecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TFJunYou_RecordModel *model = _array[indexPath.section][indexPath.row];
    [cell setData:model];
    if (indexPath.row == [(NSArray *)[_array objectAtIndex:indexPath.section] count]-1) {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,0);
    }else {
        cell.lineView.frame = CGRectMake(cell.lineView.frame.origin.x, cell.lineView.frame.origin.y, cell.lineView.frame.size.width,LINE_WH);
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 40)];
    view.backgroundColor = HEXCOLOR(0xF2F2F2);
    UILabel *label = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, 48)];
    double payMoney = 0;
    double getMoney = 0;
    if (self.indexArr.count > 0) {
        for (TFJunYou_RecordModel *model in _array[section]) {
            if (model.type == 1 || model.type == 2 || model.type == 3 || model.type == 4 || model.type == 7 || model.type == 10 || model.type == 12) {
                payMoney += model.money;
            }else {
                getMoney += model.money;
            }
        }
        label.text = [NSString stringWithFormat:@"%@   支出:%.2f  收入:%.2f",[self.indexArr objectAtIndex:section],payMoney,getMoney];
    }
    label.font = SYSFONT(13);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    return view;
}
- (void)handleBillData:(NSArray *)arr
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSInteger currentYear = nowCmps.year;
    NSInteger currentMonth = nowCmps.month;
    for (TFJunYou_RecordModel *model in arr) {
        NSString *key;
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate dateWithTimeIntervalSince1970:model.time]];
        NSInteger billYear = [components year];
        NSInteger billMonth = [components month];
        if (billYear == currentYear)
        {
            if (billMonth ==currentMonth)
            {
                key =@"本月";
            }
            else
            {
                key =[NSString stringWithFormat:@"%02ld月",billMonth];
            }
        }
        else
        {
            key =[NSString stringWithFormat:@"%ld年%2ld月",billYear,billMonth];
        }
        BOOL isContained =NO;
        NSInteger containedIndex = 0;
        if ([self.indexArr containsObject:key]) {
            isContained = YES;
            containedIndex = [self.indexArr indexOfObject:key];
        }else {
            [self.indexArr addObject:key];
        }
        if (isContained)
        {
            [[_array objectAtIndex:containedIndex] addObject:model];
        }
        else
        {
            NSMutableArray *subArr = [[NSMutableArray alloc] init];
            [subArr addObject:model];
            [_array addObject:subArr];
        }
    }
    [_table reloadData];
}
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if( [aDownload.action isEqualToString:act_getConsumeRecordList]){
        NSArray *arr = [dict objectForKey:@"pageData"];
        if (arr.count <= 0) {
        }
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        if(_page == 0){
            [_array removeAllObjects];
            [_indexArr removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                TFJunYou_RecordModel *model = [[TFJunYou_RecordModel alloc] init];
                [model getDataWithDict:arr[i]];
                [mutArr addObject:model];
            }
        }else{
            if([arr count]>0){
                for (int i = 0; i < arr.count; i++) {
                    TFJunYou_RecordModel *model = [[TFJunYou_RecordModel alloc] init];
                    [model getDataWithDict:arr[i]];
                    [mutArr addObject:model];
                }
            }
        }
        _page ++;
        if (mutArr.count > 0) {
            [_table hideEmptyImage];
        }else {
            [_table showEmptyImage:EmptyTypeNoData];
        }
        [self setIsShowFooterPull:arr.count >= 20];
        [self handleBillData:mutArr];
    }
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
@end
