#import "TFJunYou_TransferNoticeVC.h"
#import "TFJunYou_TransferNoticeCell.h"
#import "TFJunYou_TransferNoticeModel.h"
#import "TFJunYou_TransferModel.h"
#import "TFJunYou_TransferOpenPayModel.h"
@interface TFJunYou_TransferNoticeVC ()
@property (nonatomic, strong) NSArray *array;
@end
@implementation TFJunYou_TransferNoticeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"JX_PaymentNo.");
    self.heightHeader = TFJunYou__SCREEN_TOP;
    self.heightFooter = 0;
    self.isGotoBack = YES;
    [self createHeadAndFoot];
    self.isShowFooterPull = NO;
    self.isShowHeaderPull = NO;
    _table.backgroundColor = HEXCOLOR(0xF2F2F2);
    [self getData];
}
- (void)getData {
    _array = [[TFJunYou_MessageObject sharedInstance] fetchAllMessageListWithUser:SHIKU_TRANSFER];
    if (_array.count > 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionMiddle];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_MessageObject *msg=[_array objectAtIndex:indexPath.row];
    return [TFJunYou_TransferNoticeCell getChatCellHeight:msg];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"TFJunYou_TransferNoticeCell";
    TFJunYou_TransferNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TFJunYou_TransferNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TFJunYou_MessageObject *msg = _array[indexPath.row];
    NSDictionary *dict = [self dictionaryWithJsonString:msg.content];
    if ([msg.type intValue] == kWCMessageTypeTransferBack) {
        TFJunYou_TransferModel *model = [[TFJunYou_TransferModel alloc] init];
        [model getTransferDataWithDict:dict];
        [cell setDataWithMsg:msg model:model];
    }
    else if ([msg.type intValue] == kWCMessageTypeOpenPaySuccess) {
        TFJunYou_TransferOpenPayModel *model = [[TFJunYou_TransferOpenPayModel alloc] init];
        [model getTransferDataWithDict:dict];
        [cell setDataWithMsg:msg model:model];
    }
    else {
        TFJunYou_TransferNoticeModel *model = [[TFJunYou_TransferNoticeModel alloc]init];
        [model getTransferNoticeWithDict:dict];
        [cell setDataWithMsg:msg model:model];
    }
    return cell;
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
