#import "TFJunYou_AddDepartViewController.h"
#define HEIGHT 50
#define IMGSIZE 170
static NSString *cellID = @"SearchCellID";
@interface TFJunYou_AddDepartViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITextField* _desc;
    UILabel* _userName;
    UITextField* _roomName;
    UILabel* _size;
    roomData* _room;
    UIView *seekBackView;
    UITextField* _searchCompany;
}
@property (nonatomic,strong) NSString* userNickname;
@property (nonatomic,strong) TFJunYou_TableView *searchTableView;
@property (nonatomic,strong) NSMutableArray *companyArr;
@property (nonatomic,strong) UIButton *creatBut;
@end
@implementation TFJunYou_AddDepartViewController
-(instancetype)init{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.tableBody.backgroundColor = THEMEBACKCOLOR;
        self.isFreeOnClose = YES;
        self.isGotoBack = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT);
    [self createHeadAndFoot];
    if (_type == OrganizAddDepartment) {
        [self createDepartmentView];
    }else if (_type == OrganizAddCompany) {
        [self createCompanyView];
    }else if (_type == OrganizUpdateDepartmentName) {
        [self updateDepartmentNameView];
    }else if (_type == OrganizSearchCompany){
        [self searchCompany];
    }else if (_type == OrganizUpdateCompanyName){
        [self updateCompanyNameView];
    }else if (_type == OrganizModifyEmployeePosition){
        [self modifyEmployeePosition];
    }
}
- (void)searchCompany{
    self.title = Localized(@"JXAddDepart_search");
    seekBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.tableHeader.frame.size.width-10-10, 31)];
    seekBackView.backgroundColor = [UIColor lightGrayColor];
    seekBackView.layer.masksToBounds = YES;
    seekBackView.layer.cornerRadius = 16;
    [self.tableBody addSubview:seekBackView];
    self.companyArr = [NSMutableArray array];
    _searchCompany = [[UITextField alloc] initWithFrame:CGRectMake(5, 1, seekBackView.frame.size.width-5-25-5, 29)];
    _searchCompany.placeholder = Localized(@"JX_EnterKeyword");
    _searchCompany.delegate = self;
    [_searchCompany setTextColor:[UIColor whiteColor]];
    [_searchCompany setFont:SYSFONT(14)];
    [_searchCompany setTintColor:[UIColor whiteColor]];
    _searchCompany.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchCompany.returnKeyType = UIReturnKeyGoogle;
    [seekBackView addSubview:_searchCompany];
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(seekBackView.frame.size.width-30, 4, 25, 25);
    [but setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(onSearch) forControlEvents:UIControlEventTouchUpInside];
    [seekBackView addSubview:but];
    _creatBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _creatBut.frame = CGRectMake((TFJunYou__SCREEN_WIDTH-100)/2, 41, 100, 25);
    [_creatBut setTitle:Localized(@"OrgaVC_CreateCompany") forState:UIControlStateNormal];
    [_creatBut setTitleColor:THEMECOLOR forState:UIControlStateNormal];
    _creatBut.titleLabel.font = SYSFONT(14);
    [_creatBut addTarget:self action:@selector(creatBut:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableBody addSubview:_creatBut];
    _searchTableView = [[TFJunYou_TableView alloc]initWithFrame:CGRectMake(0, 71, TFJunYou__SCREEN_WIDTH, self.tableBody.frame.size.height-71)];
    _searchTableView.backgroundColor = [UIColor whiteColor];
    _searchTableView.alpha = 0.97;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _searchTableView.hidden = YES;
    [self.tableBody addSubview:_searchTableView];
}
- (void)onSearch{
    if ([self checkInput:_searchCompany.text]) {
        [g_server seachCompany:_searchCompany.text toView:self];
    }
}
- (void)creatBut:(UIButton *)but{
    seekBackView.hidden = YES;
    but.hidden = YES;
    _searchTableView.hidden = YES;
    [self createCompanyView];
}
-(void)createDepartmentView{
    self.title = Localized(@"JXAddDepartVC_AddDepart");
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:Localized(@"JXAddDepartVC_DepartName") drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _roomName = [self createTextField:iv default:nil hint:Localized(@"JXAddDepartVC_DepartPlacehold") type:1];
    h+=iv.frame.size.height;
    h+=INSETS;
    UIButton* _btn;
    _btn = [UIFactory createCommonButton:Localized(@"JXAddDepartVC_AddDepart") target:self action:@selector(onCreateDepartment)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15,h+20,TFJunYou__SCREEN_WIDTH-30,40);
    [self.tableBody addSubview:_btn];
}
-(void)createCompanyView{
    self.title = Localized(@"JXAddDepartVC_AddCompany");
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:Localized(@"JXAddDepartVC_CompName") drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _roomName = [self createTextField:iv default:nil hint:Localized(@"JXAddDepartVC_CompPlacehold") type:1];
    h+=iv.frame.size.height;
    h+=INSETS;
    UIButton* _btn;
    _btn = [UIFactory createCommonButton:Localized(@"JXAddDepartVC_AddCompany") target:self action:@selector(onCreateCompany)];
    _btn.custom_acceptEventInterval = .25f;
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15,h+20,TFJunYou__SCREEN_WIDTH-30,40);
    [self.tableBody addSubview:_btn];
}
-(void)updateDepartmentNameView{
    self.title = _oldName;
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:Localized(@"JXAddDepartVC_UpdateDepart") drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _roomName = [self createTextField:iv default:_oldName hint:nil type:1];
    h+=iv.frame.size.height;
    h+=INSETS;
    UIButton* _btn;
    _btn = [UIFactory createCommonButton:Localized(@"JXAddDepartVC_UpdateDepart") target:self action:@selector(onUpdateDepartmentName)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15,h+20,TFJunYou__SCREEN_WIDTH-30,40);
    [self.tableBody addSubview:_btn];
}
-(void)updateCompanyNameView{
    self.title = _oldName;
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:Localized(@"JXAddDepartVC_UpdateCompany") drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _roomName = [self createTextField:iv default:_oldName hint:nil type:1];
    h+=iv.frame.size.height;
    h+=INSETS;
    UIButton* _btn;
    _btn = [UIFactory createCommonButton:Localized(@"JXAddDepartVC_UpdateCompany") target:self action:@selector(onUpdateCompanyName)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15,h+20,TFJunYou__SCREEN_WIDTH-30,40);
    [self.tableBody addSubview:_btn];
}
-(void)modifyEmployeePosition{
    self.title = _oldName;
    int h = 0;
    TFJunYou_ImageView* iv;
    iv = [[TFJunYou_ImageView alloc]init];
    iv.frame = self.tableBody.bounds;
    iv.delegate = self;
    iv.didTouch = @selector(hideKeyboard);
    [self.tableBody addSubview:iv];
    iv = [self createButton:Localized(@"OrgaVC_ModifyEmployeePosition") drawTop:NO drawBottom:YES must:NO click:nil];
    iv.frame = CGRectMake(0, h, TFJunYou__SCREEN_WIDTH, HEIGHT);
    _roomName = [self createTextField:iv default:_oldName hint:nil type:1];
    h+=iv.frame.size.height;
    h+=INSETS;
    UIButton* _btn;
    _btn = [UIFactory createCommonButton:Localized(@"OrgaVC_ModifyEmployeePosition") target:self action:@selector(onUpdateCompanyName)];
    _btn.layer.cornerRadius = 7;
    _btn.clipsToBounds = YES;
    _btn.titleLabel.font = SYSFONT(16);
    _btn.frame = CGRectMake(15,h+20,TFJunYou__SCREEN_WIDTH-30,40);
    [self.tableBody addSubview:_btn];
}
#pragma mark - action
-(BOOL)hideKeyboard{
    BOOL b = _roomName.editing || _desc.editing;
    [self.view endEditing:YES];
    return b;
}
-(void)onCreateDepartment{
    if ([_roomName.text isEqualToString:@""]) {
        [g_App showAlert:Localized(@"JX_InputRoomName")];
    }else if ([_desc.text isEqualToString:@""]){
        [g_App showAlert:Localized(@"JXNewRoomVC_InputExplain")];
    }else{
        _roomName.text = [_roomName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (_roomName.text.length <= 0) {
            [TFJunYou_MyTools showTipView:@"????????????????????????"];
            return;
        }
        if(self.delegate != nil && [self.delegate respondsToSelector:@selector(inputDelegateType:text:)])
            [self.delegate inputDelegateType:_type text:_roomName.text];
        [self actionQuit];
    }
}
-(void)onCreateCompany{
    if (_roomName.text.length <= 0) {
        [g_App showAlert:Localized(@"JXAddDepartVC_CompPlacehold")];
        return;
    }
    _roomName.text = [_roomName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (_roomName.text.length <= 0) {
        [TFJunYou_MyTools showTipView:@"????????????????????????"];
        return;
    }
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(inputDelegateType:text:)])
        [self.delegate inputDelegateType:_type text:_roomName.text];
    [self actionQuit];
}
-(void)onUpdateDepartmentName{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(inputDelegateType:text:)])
        [self.delegate inputDelegateType:_type text:_roomName.text];
    [self actionQuit];
}
-(void)onUpdateCompanyName{
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(inputDelegateType:text:)])
        [self.delegate inputDelegateType:_type text:_roomName.text];
    [self actionQuit];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(TFJunYou_ImageView*)createButton:(NSString*)title drawTop:(BOOL)drawTop drawBottom:(BOOL)drawBottom must:(BOOL)must click:(SEL)click{
    TFJunYou_ImageView* btn = [[TFJunYou_ImageView alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.userInteractionEnabled = YES;
    if(click)
        btn.didTouch = click;
    else
        btn.didTouch = @selector(hideKeyboard);
    btn.delegate = self;
    [self.tableBody addSubview:btn];
    if(must){
        UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, 5, 20, HEIGHT-5)];
        p.text = @"*";
        p.font = g_factory.font18;
        p.backgroundColor = [UIColor clearColor];
        p.textColor = [UIColor redColor];
        p.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:p];
    }
    TFJunYou_Label* p = [[TFJunYou_Label alloc] initWithFrame:CGRectMake(15, 0, 130, HEIGHT)];
    p.text = title;
    p.font = g_factory.font15;
    p.backgroundColor = [UIColor clearColor];
    p.textColor = [UIColor blackColor];
    [btn addSubview:p];
    if(drawTop){
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0,0,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(drawBottom){
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0,HEIGHT-0.5,TFJunYou__SCREEN_WIDTH,LINE_WH)];
        line.backgroundColor = THE_LINE_COLOR;
        [btn addSubview:line];
    }
    if(click){
        UIImageView* iv;
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH-15-7, (HEIGHT-13)/2, 7, 13)];
        iv.image = [UIImage imageNamed:@"new_icon_>"];
        [btn addSubview:iv];
    }
    return btn;
}
-(UITextField*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint type:(BOOL)name{
    UITextField* p = [[UITextField alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2-15,HEIGHT-INSETS*2)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.borderStyle = UITextBorderStyleNone;
    p.returnKeyType = UIReturnKeyDone;
    p.clearButtonMode = UITextFieldViewModeWhileEditing;
    p.textAlignment = NSTextAlignmentRight;
    p.userInteractionEnabled = YES;
    if (s)
        p.text = s;
    if (hint)
        p.placeholder = hint;
    p.font = g_factory.font14;
    if (name) {
        [p addTarget:self action:@selector(textLong12:) forControlEvents:UIControlEventEditingChanged];
    }else{
        [p addTarget:self action:@selector(textLong32:) forControlEvents:UIControlEventEditingChanged];
    }
    [parent addSubview:p];
    return p;
}
- (void)textLong12:(UITextField *)textField
{
    [self validationText:textField length:12];
}
- (void)textLong32:(UITextField *)textField
{
    [self validationText:textField length:32];
}
- (NSString *)disable_Text:(NSString *)text
{
    NSLog(@"??????--->%@",text);
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [self disable_emoji:text];
}
- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
- (NSString *)validationText:(UITextField *)textField length:(int)length
{
    NSString *toBeString = [self disable_Text:textField.text];
    NSString *lang = [textField.textInputMode primaryLanguage];
    NSLog(@"%@",lang);
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length>=length) {
                NSString *strNew = [NSString stringWithString:toBeString];
                [textField setText:[strNew substringToIndex:length]];
            }else{
                [textField setText:toBeString];
            }
        }
        else
        {
            NSLog(@"????????????????????????????????????????????????");
        }
    }
    else{
        if (toBeString.length > length) {
            textField.text = [toBeString substringToIndex:length];
        }else{
            textField.text = toBeString;
        }
    }
    return textField.text;
}
-(UILabel*)createLabel:(UIView*)parent default:(NSString*)s{
    UILabel* p = [[UILabel alloc] initWithFrame:CGRectMake(TFJunYou__SCREEN_WIDTH/2,INSETS,TFJunYou__SCREEN_WIDTH/2 - INSETS,HEIGHT-INSETS*2)];
    p.userInteractionEnabled = NO;
    p.text = s;
    p.font = g_factory.font14;
    p.textAlignment = NSTextAlignmentRight;
    [parent addSubview:p];
    return p;
}
#pragma mark----UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.companyArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = _companyArr[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"companyName"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark----UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.searchTableView.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField == _searchCompany) {
        [self onSearch];
    }
    return YES;
}
- (BOOL)checkInput:(NSString *)name{
    if ([name length] <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:Localized(@"JX_ContentEmpty") delegate:self cancelButtonTitle:Localized(@"OK") otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    return YES;
}
#pragma mark -????????????
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if ([aDownload.action isEqualToString:act_seachCompany]) {
        if (array1) {
            self.searchTableView.hidden = NO;
            [_companyArr addObjectsFromArray:array1];
            [_searchTableView reloadData];
        }else{
            [g_App showAlert:Localized(@"JXAddDepart_notFind")];
        }
    }
}
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait hide];
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait hide];
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    [_wait start];
}
@end
