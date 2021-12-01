#import "TFJunYou_JLWithdrawalRecordVC.h"
#import "TFJunYou_JLWithdrawalRecordViewCell.h"
@interface TFJunYou_JLWithdrawalRecordVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UITableView *table;
@end
@implementation TFJunYou_JLWithdrawalRecordVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现记录";
    self.isGotoBack = YES;
    self.heightFooter = 0;
    self.heightHeader = TFJunYou__SCREEN_TOP;
    [self createHeadAndFoot];
    [self createTableView];
    [self getData];
}
- (void)createTableView {
    _table       = [[UITableView alloc] initWithFrame:self.tableBody.frame style:UITableViewStylePlain];
    _table.frame =CGRectMake(0,0,self_width,self_height-TFJunYou__SCREEN_TOP);
    _table.delegate      = self;
    _table.dataSource    = self;
    [_table  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _table.backgroundColor = [UIColor clearColor];
    [_table registerNib:[UINib nibWithNibName:@"TFJunYou_JLWithdrawalRecordViewCell" bundle:nil] forCellReuseIdentifier:@"TFJunYou_JLWithdrawalRecordViewCell"];
    self.tableBody.backgroundColor = HEXCOLOR(0xF0EFF4);
    self.tableBody.scrollEnabled = NO;
    [self.tableBody addSubview:_table];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_JLWithdrawalRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFJunYou_JLWithdrawalRecordViewCell" forIndexPath:indexPath];
    NSDictionary *dict = _array[indexPath.row];
    cell.dict = dict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = _array[indexPath.row];
    NSString *status = [NSString stringWithFormat:@"%@", dict[@"status"]];
    return [status intValue] == -1?150:120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (void)getData {
    [_wait show];
    _array = [NSMutableArray array];
    NSString *userId = [g_default objectForKey:kMY_USER_ID];
    [g_server withdrawlListUserId:userId toView:self];
}
-(void)didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_withdrawlList]){
        _array = array1.mutableCopy;
        [_table reloadData];
       }
}
@end
