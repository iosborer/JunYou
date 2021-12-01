#import "TFJunYou_TelAreaListVC.h"
#import "TFJunYou_MyTools.h"
#import "TFJunYou_TelAreaCell.h"
#define TELAREA_CELL_HEIGHT 42
@interface TFJunYou_TelAreaListVC ()<UITextFieldDelegate>
{
    NSString *_language;
}
@property (nonatomic, strong) NSMutableArray *telAreaArray;
@property (nonatomic, strong) UITextField *seekTextField;
@end
@implementation TFJunYou_TelAreaListVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.isGotoBack = YES;
        self.title = Localized(@"JX_SelectCountryOrArea");
        [self createHeadAndFoot];
        _telAreaArray = [[NSMutableArray alloc] init];
        _telAreaArray = [g_constant.telArea mutableCopy];
        [self customView];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _language = [[NSString alloc] initWithFormat:@"%@",g_constant.sysLanguage];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void) customView {
    self.isShowHeaderPull = NO;
    self.isShowFooterPull = NO;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TELAREA_CELL_HEIGHT+5)];
    self.tableView.tableHeaderView = headView;
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH - 20 - 15, 14, 20, 20)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"ic_search_history"] forState:UIControlStateNormal];
    [headView addSubview:searchBtn];
    UIView *seekBackView = [[UIView alloc] initWithFrame:CGRectMake(15, 6, TFJunYou__SCREEN_WIDTH - 30, 35)];
    seekBackView.layer.masksToBounds = YES;
    seekBackView.layer.cornerRadius = 3.f;
    seekBackView.backgroundColor = HEXCOLOR(0xF2F2F2);
    [headView addSubview:seekBackView];
    _seekTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, seekBackView.frame.size.width-10, 35)];
    _seekTextField.delegate = self;
    _seekTextField.placeholder = Localized(@"JX_EnterCountry");
    [_seekTextField setFont:SYSFONT(14)];
    _seekTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _seekTextField.returnKeyType = UIReturnKeyGoogle;
    [seekBackView addSubview:_seekTextField];
    [_seekTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void) textFieldDidChange:(UITextField *)textField {
    [_telAreaArray removeAllObjects];
    if (textField.text.length > 0) {
        _telAreaArray = [g_constant getSearchTelAreaWithName:textField.text];
    }else {
        _telAreaArray = [g_constant.telArea mutableCopy];
    }
    [self.tableView reloadData];
}
#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _telAreaArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TELAREA_CELL_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    TFJunYou_TelAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TFJunYou_TelAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    [cell doRefreshWith:[_telAreaArray objectAtIndex:indexPath.row] language:_language];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.telAreaDelegate respondsToSelector:self.didSelect]) {
        [self.telAreaDelegate performSelectorOnMainThread:self.didSelect withObject:[(NSDictionary *)[_telAreaArray objectAtIndex:indexPath.row] objectForKey:@"prefix"] waitUntilDone:NO];
    }
    [self actionQuit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
