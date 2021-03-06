#import "OrganizTreeViewController.h"
#import "DepartObject.h"
#import "EmployeObject.h"
#import "RATreeView.h"
#import "OrganizTableViewCell.h"
#import "EmployeeTableViewCell.h"
#import "TFJunYou__DownListView.h"
#import "TFJunYou_AddDepartViewController.h"
#import "TFJunYou_SelFriendVC.h"
#import "TFJunYou_SelectFriendsVC.h"
#import "TFJunYou_UserInfoVC.h"
#import "TFJunYou_SelDepartViewController.h"
@interface OrganizTreeViewController ()<RATreeViewDelegate, RATreeViewDataSource,AddDepartDelegate,SelDepartDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray<DepartObject *> * dataArray;
@property (nonatomic, weak) RATreeView * treeView;
@property (nonatomic, strong) UIButton * moreButton;
@property (atomic, strong) id currentOrgObj;
@property (nonatomic, assign) BOOL afterDelCompany;
@property (nonatomic, strong) UIControl * control;
@property (nonatomic, strong) NSMutableDictionary * allDataDict;
@property (nonatomic, strong) NSMutableDictionary * employeesDict;
@property (nonatomic, strong) NSMutableDictionary * companyDict;
@property (nonatomic, strong) NSMutableDictionary * noticeDict;
@property (nonatomic, copy) NSString * companyId;
@property (nonatomic, copy) NSString * companyName;
@property (nonatomic, copy) void (^rowActionAfterRequestBlock)(id sender);
@property (nonatomic, strong) UIView * noCompanyView;
@property (atomic, strong) id item;
@property (nonatomic, assign) BOOL isNotDele;
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *replayTitle;
@property (nonatomic, strong) UITextView *replayTextView;
@property (nonatomic, strong) NSMutableDictionary *curAddDepObj;
@end
@implementation OrganizTreeViewController
- (id)init
{
    self = [super init];
    if (self) {
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.title = Localized(@"OrganizVC_Organiz");
        self.isFreeOnClose = YES;
        self.isGotoBack = YES;
#ifdef Live_Version
        self.isGotoBack = YES;
        self.heightFooter = 0;
#endif
        _dataArray = [NSMutableArray new];
        _allDataDict = [NSMutableDictionary new];
        _employeesDict = [NSMutableDictionary new];
        _companyDict = [NSMutableDictionary new];
        [self createTreeView];
        [self setupReplayView];
        [g_server getCompanyAuto:self];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadAndFoot];
    _moreButton = [UIFactory createButtonWithImage:@"msg_right_icon" highlight:nil target:self selector:@selector(onMore:)];
    _moreButton.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-18-15, TFJunYou__SCREEN_TOP -15-18, 18, 18);
    [self.tableHeader addSubview:_moreButton];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_treeView reloadRows];
}
- (void)setupReplayView {
    int height = 44;
    self.bigView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bigView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    self.bigView.hidden = YES;
    [g_App.window addSubview:self.bigView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.bigView addGestureRecognizer:tap];
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(40, TFJunYou__SCREEN_HEIGHT/4-.5, TFJunYou__SCREEN_WIDTH-80, 162.5)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    self.baseView.layer.masksToBounds = YES;
    self. baseView.layer.cornerRadius = 4.0f;
    [self.bigView addSubview:self.baseView];
    int n = 20;
    _replayTitle = [[UILabel alloc] initWithFrame:CGRectMake(INSETS, n, self.baseView.frame.size.width - INSETS*2, 20)];
    _replayTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    _replayTitle.textColor = HEXCOLOR(0x333333);
    _replayTitle.font = SYSFONT(16);
    _replayTitle.text = @"????????????";
    [self.baseView addSubview:_replayTitle];
    n = n + height;
    self.replayTextView = [self createTextField:self.baseView default:nil hint:nil];
    self.replayTextView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    self.replayTextView.frame = CGRectMake(10, n, self.baseView.frame.size.width - INSETS*2, 35.5);
    self.replayTextView.delegate = self;
    self.replayTextView.textColor = HEXCOLOR(0x595959);
    n = n + INSETS + height;
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, n, self.baseView.frame.size.width, 44)];
    [self.baseView addSubview:self.topView];
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseView.frame.size.width, LINE_WH)];
    topLine.backgroundColor = THE_LINE_COLOR;
    [self.topView addSubview:topLine];
    UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(self.baseView.frame.size.width/2, 0, LINE_WH, self.topView.frame.size.height)];
    botLine.backgroundColor = THE_LINE_COLOR;
    [self.topView addSubview:botLine];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topLine.frame), self.baseView.frame.size.width/2, botLine.frame.size.height)];
    [cancelBtn setTitle:Localized(@"JX_Cencal") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:SYSFONT(15)];
    [cancelBtn addTarget:self action:@selector(hideBigView) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelBtn];
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.baseView.frame.size.width/2, CGRectGetMaxY(topLine.frame), self.baseView.frame.size.width/2, botLine.frame.size.height)];
    [sureBtn setTitle:Localized(@"JX_Send") forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEXCOLOR(0x55BEB8) forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:SYSFONT(15)];
    [sureBtn addTarget:self action:@selector(onRelease) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:sureBtn];
}
- (void)resignKeyBoard {
    self.bigView.hidden = YES;
    [self hideKeyBoard];
    [self resetBigView];
}
- (void)resetBigView {
    self.replayTextView.frame = CGRectMake(10, 64, self.baseView.frame.size.width - INSETS*2, 35.5);
    self.baseView.frame = CGRectMake(40, TFJunYou__SCREEN_HEIGHT/4-.5, TFJunYou__SCREEN_WIDTH-80, 162.5);
    self.topView.frame = CGRectMake(0, 118, self.baseView.frame.size.width, 40);
}
- (void)hideKeyBoard {
    if (self.replayTextView.isFirstResponder) {
        [self.replayTextView resignFirstResponder];
    }
}
-(UITextView*)createTextField:(UIView*)parent default:(NSString*)s hint:(NSString*)hint{
    UITextView* p = [[UITextView alloc] initWithFrame:CGRectMake(0,INSETS,TFJunYou__SCREEN_WIDTH,54)];
    p.delegate = self;
    p.autocorrectionType = UITextAutocorrectionTypeNo;
    p.autocapitalizationType = UITextAutocapitalizationTypeNone;
    p.enablesReturnKeyAutomatically = YES;
    p.scrollEnabled = NO;
    p.showsVerticalScrollIndicator = NO;
    p.showsHorizontalScrollIndicator = NO;
    p.textAlignment = NSTextAlignmentLeft;
    p.userInteractionEnabled = YES;
    p.backgroundColor = [UIColor whiteColor];
    p.text = s;
    p.font = g_factory.font16;
    [parent addSubview:p];
    return p;
}
- (void)textViewDidChange:(UITextView *)textView {
    static CGFloat maxHeight =66.0f;
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [UIColor lightGrayColor];
    }
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(TFJunYou__SCREEN_WIDTH-80-INSETS*2, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   
    }
    else
    {
        textView.scrollEnabled = NO;    
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    NSLog(@"--------%@",NSStringFromCGRect(self.baseView.frame));
    self.baseView.frame = CGRectMake(40, TFJunYou__SCREEN_HEIGHT/4+35-size.height, TFJunYou__SCREEN_WIDTH-80, 162-35+size.height);
    self.topView.frame = CGRectMake(0, 118-35+size.height, self.baseView.frame.size.width, 40);
}
- (void)hideBigView {
    [self resignKeyBoard];
}
- (void)onRelease {
    if (_replayTextView.text.length <= 0) {
        [TFJunYou_MyTools showTipView:@"??????????????????"];
        return;
    }
    DepartObject * departObj = _currentOrgObj;
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        [(NSMutableDictionary *)[weakSelf.companyDict objectForKey:departObj.companyId] setObject:weakSelf.replayTextView.text forKey:@"noticeContent"];
        [weakSelf.treeView reloadRowsForItems:@[departObj] withRowAnimation:RATreeViewRowAnimationNone];
        [weakSelf hideBigView];
    };
    [g_server updataCompanyName:nil noticeContent:self.replayTextView.text companyId:departObj.companyId toView:self];
}
-(void)createTreeView{
    self.tableBody.backgroundColor = HEXCOLOR(0xF2F2F2);
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds style:RATreeViewStylePlain];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    treeView.estimatedRowHeight = 0;
    treeView.estimatedSectionHeaderHeight = 0;
    treeView.estimatedSectionFooterHeight = 0;
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlChanged:) forControlEvents:UIControlEventValueChanged];
    [treeView.scrollView addSubview:refreshControl];
    [treeView reloadData];
    [treeView setBackgroundColor:[UIColor clearColor]];
    self.treeView = treeView;
    treeView.frame = self.tableBody.bounds;
    treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.tableBody addSubview:treeView];
    [treeView registerClass:[OrganizTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OrganizTableViewCell class])];
    [treeView registerClass:[EmployeeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EmployeeTableViewCell class])];
}
#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    if ([item isMemberOfClass:[EmployeObject class]]) {
        return 60;
    }
    return 44;
}
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item
{
    if ([item isMemberOfClass:[DepartObject class]]) {
        OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:item];
        cell.arrowExpand = YES;
    }
}
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item
{
    if ([item isMemberOfClass:[DepartObject class]]) {
        OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:item];
        cell.arrowExpand = NO;
    }
}
#pragma mark ???????????? -??????
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item
{
    return NO;
}
-(UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item{
    if (treeView.editing)
        return UITableViewCellEditingStyleNone;
    else
        return UITableViewCellEditingStyleDelete;
}
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item
{
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    [self deleteNodeWithItem:item];
}
-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item{
    if ([item isMemberOfClass:[EmployeObject class]]){
        [self showEmployeeDownListView:item];
    }else{
        DepartObject * depart = item;
        if (depart.children.count == 0)
            [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_DepartNoChild")];
    }
}
#pragma mark TreeView Data Source
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    NSInteger level = [self.treeView levelForCellForItem:item];
    if ([item isMemberOfClass:[DepartObject class]]) {
        DepartObject * dataObject = item;
        BOOL expanded = [self.treeView isCellForItemExpanded:item];
        OrganizTableViewCell * cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([OrganizTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupWithData:dataObject level:level expand:expanded];
        cell.noticeLab.text = @"????????????";
        NSDictionary * dataObj = [_companyDict objectForKey:dataObject.companyId];
        if (!IsObjectNull(dataObj[@"noticeContent"])) {
            NSString *str = [NSString stringWithFormat:@"%@",dataObj[@"noticeContent"]];
            if (str.length > 0) {
                cell.noticeLab.text = str;
            }
        }
        __weak typeof(self) weakSelf = self;
        cell.additionButtonTapAction = ^(id sender){
            if (weakSelf.treeView.isEditing) {
                return;
            }
            [weakSelf showDepartDownListView:dataObject];
        };
        cell.noticeLabTapAction = ^(DepartObject *dataObj) {
            if (weakSelf.treeView.isEditing) {
                return;
            }
            _currentOrgObj = dataObj;
            weakSelf.bigView.hidden = NO;
            [weakSelf.replayTextView becomeFirstResponder];
        };
        return cell;
    }else if ([item isMemberOfClass:[EmployeObject class]]) {
        EmployeObject * dataObject = item;
        EmployeeTableViewCell * cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([EmployeeTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupWithData:dataObject level:level];
        return cell;
    }
    return nil;
}
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.dataArray count];
    }
    if ([item isMemberOfClass:[EmployeObject class]]) {
        return 0;
    }else{
        DepartObject * dataObject = item;
        return [dataObject.children count];
    }
}
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil) {
        return [self.dataArray objectAtIndex:index];
    }
    if ([item isMemberOfClass:[EmployeObject class]]) {
        return nil;
    }else{
        DepartObject * dataObject = item;
        return dataObject.children[index];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    self.rowActionAfterRequestBlock = nil;
}
#pragma mark - Actions
- (void)refreshControlChanged:(UIRefreshControl *)refreshControl
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
    });
}
#pragma mark ???????????????
-(void)onMore:(UIButton *)sender{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect moreFrame = [self.tableHeader convertRect:_moreButton.frame toView:window];
    TFJunYou__DownListView * downListView = [[TFJunYou__DownListView alloc] initWithFrame:self.view.bounds];
    downListView.listContents = @[Localized(@"OrgaVC_CreateNewCompany")];
    downListView.listImages = @[@"organize_add"];
    downListView.textColor = HEXCOLOR(0x333333);
    downListView.color = [UIColor whiteColor];
    __weak typeof(self) weakSelf = self;
    [downListView downlistPopOption:^(NSInteger index, NSString *content) {
        if (index == 0) {
            [weakSelf showAddCompanyView];
        }
    } whichFrame:moreFrame animate:YES];
    [downListView show];
}
-(void)showNoCompanyView{
    _noCompanyView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, TFJunYou__SCREEN_WIDTH-40, 200)];
    [self.tableBody addSubview:_noCompanyView];
    UILabel * noCompanyLabel = [[UILabel alloc] init];
    noCompanyLabel.frame = CGRectMake(0, 20, CGRectGetWidth(_noCompanyView.frame), 30);
    noCompanyLabel.textAlignment = NSTextAlignmentCenter;
    noCompanyLabel.center = CGPointMake(CGRectGetWidth(_noCompanyView.frame)/2, noCompanyLabel.center.y);
    noCompanyLabel.text = Localized(@"OrgaVC_NoCompanyAlert");
    [_noCompanyView addSubview:noCompanyLabel];
    UIButton * createButton = [UIButton buttonWithType:UIButtonTypeSystem];
    createButton.frame = CGRectMake(0, 70, 150, 45);
    createButton.center = CGPointMake(CGRectGetWidth(_noCompanyView.frame)/2, createButton.center.y);
    [createButton setTitle:Localized(@"OrgaVC_GotoCreateCompany") forState:UIControlStateNormal];
    [createButton setBackgroundColor:THEMECOLOR];
    [createButton addTarget:self action:@selector(showAddCompanyView) forControlEvents:UIControlEventTouchUpInside];
    [_noCompanyView addSubview:createButton];
}
-(void)showAddCompanyView{
    [self inputViewController:OrganizAddCompany oldName:nil];
}
#pragma mark - ????????????????????????
-(void)showDepartDownListView:(DepartObject *)orgObject{
    _currentOrgObj = orgObject;
    NSInteger level = [self.treeView levelForCellForItem:orgObject];
    OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:orgObject];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect moreFrame = [window convertRect:cell.additionButton.frame fromView:cell];
    NSDictionary * theCompany = _companyDict[orgObject.companyId];
    NSString * creatUserId = [NSString stringWithFormat:@"%@",theCompany[@"createUserId"]];
    BOOL permissions = [creatUserId isEqualToString:g_myself.userId] ? YES : NO;
    NSNumber * isCanOperate = [NSNumber numberWithBool:permissions];
    NSNumber * canOperate = [NSNumber numberWithBool:YES];
    TFJunYou__DownListView * downListView = [[TFJunYou__DownListView alloc] initWithFrame:self.view.bounds];
    downListView.textColor = HEXCOLOR(0x333333);
    downListView.color = [UIColor whiteColor];
    if (level == 0) {
        downListView.listContents = @[Localized(@"OrgaVC_CreateDepart"),Localized(@"OrgaVC_UpdateCompany"),Localized(@"OrgaVC_QuitCompany"),@"????????????"];
        downListView.listEnables = @[isCanOperate,isCanOperate,canOperate,isCanOperate];
        downListView.listImages = @[@"organize_add",@"organize_change",@"organize_exit",@"organize_delete"];
    } else {
        downListView.listContents = @[Localized(@"OrgaVC_CreateDepart"),Localized(@"OrgaVC_CreateEmployee"),Localized(@"OrgaVC_UpdaeDepart"),Localized(@"JX_Delete")];
        downListView.listEnables = @[isCanOperate,canOperate,isCanOperate,isCanOperate];
        downListView.listImages = @[@"organize_add",@"organize_change",@"organize_exit",@"organize_delete"];
    }
    __weak typeof(self) weakSelf = self;
    [downListView downlistPopOption:^(NSInteger index, NSString *content) {
        if (level == 0) {
            if (index == 0) {
                [weakSelf addDepartWithParent:orgObject];
            }else if (index == 1) {
                [weakSelf modifyCompanyNameWith:orgObject];
            }else if (index == 2) {
                [weakSelf quitCompanyWith:orgObject];
            }else if (index == 3) {
                [weakSelf deleteCompanyWith:orgObject];
            }
        }else{
            switch (index) {
                case 0:{
                    [weakSelf addDepartWithParent:orgObject];
                    break;
                }
                case 1:{
                    [weakSelf chooseEmployeeWithParent:orgObject];
                    break;
                }
                case 2:{
                    [weakSelf changeDepartNameWithParent:orgObject];
                    break;
                }
                case 3:{
                    [weakSelf deleteNodeWithItem:orgObject];
                    break;
                }
                default:
                    break;
            }
        }
    } whichFrame:moreFrame animate:YES];
    [downListView show];
}
#pragma mark - ????????????????????????
-(void)showEmployeeDownListView:(EmployeObject *)empObject{
    _currentOrgObj = empObject;
    EmployeeTableViewCell * cell = (EmployeeTableViewCell *)[self.treeView cellForItem:empObject];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    CGRect cellFrame = [window convertRect:cell.contentView.frame fromView:cell];
    CGRect listFrame = CGRectMake(cellFrame.size.width-20-22, cellFrame.origin.y +20, 22, 22);
    NSDictionary * theCompany = _companyDict[empObject.companyId];
    NSString * creatUserId = [NSString stringWithFormat:@"%@",theCompany[@"createUserId"]];
    BOOL permissions = [creatUserId isEqualToString:g_myself.userId] ? YES : NO;
    NSNumber * isCanOperate = [NSNumber numberWithBool:permissions];
    NSNumber * canOperate = [NSNumber numberWithBool:YES];
    BOOL employeeSelf = [empObject.userId isEqualToString:g_myself.userId] ? YES : NO;
    BOOL isCanModifyPosition = (permissions || employeeSelf);
    TFJunYou__DownListView * downListView = [[TFJunYou__DownListView alloc] initWithFrame:self.view.bounds];
    downListView.textColor = HEXCOLOR(0x333333);
    downListView.color = [UIColor whiteColor];
    downListView.listContents = @[Localized(@"OrgaVC_EmployeeDetail"),Localized(@"OrgaVC_EmployeeChangeDepart"),Localized(@"OrgaVC_ModifyEmployeePosition"),Localized(@"JX_Delete")];
    if ([empObject.userId isEqualToString:g_myself.userId]) {
        downListView.listEnables = @[canOperate,isCanOperate,[NSNumber numberWithBool:isCanModifyPosition],isCanOperate];
    }else {
        downListView.listEnables = @[canOperate,isCanOperate,[NSNumber numberWithBool:employeeSelf],isCanOperate];
    }
    downListView.listImages = @[@"organize_add",@"organize_change",@"organize_exit",@"organize_delete"];
    __weak typeof(self) weakSelf = self;
    [downListView downlistPopOption:^(NSInteger index, NSString *content) {
            switch (index) {
                case 0:{
                    [weakSelf employeeDetailWith:empObject];
                    break;
                }
                case 1:{
                    [weakSelf employChangeDepartWith:empObject];
                    break;
                }
                case 2:{
                    [weakSelf modifyEmployeePositionWith:empObject];
                    break;
                }
                case 3:{
                    [weakSelf deleteNodeWithItem:empObject];
                    break;
                }
                default:
                    break;
            }
    } whichFrame:listFrame animate:YES];
    [downListView show];
}
#pragma mark - Row??????????????????
-(void)addDepartWithParent:(DepartObject *)orgObject{
    OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:orgObject];
    if (!cell.arrowExpand) {
        cell.arrowExpand = YES;
        [self.treeView expandRowForItem:orgObject expandChildren:NO withRowAnimation:RATreeViewRowAnimationNone];
    }
    [self inputViewController:OrganizAddDepartment oldName:nil];
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSDictionary * departData = sender;
        DepartObject * childDepart = [DepartObject departmentObjectWith:departData allData:nil];
        [orgObject addChild:childDepart];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:orgObject withAnimation:RATreeViewRowAnimationLeft];
        [weakSelf.treeView reloadRowsForItems:@[orgObject] withRowAnimation:RATreeViewRowAnimationNone];
    };
}
-(void)changeDepartNameWithParent:(DepartObject *)orgObject{
    [self inputViewController:OrganizUpdateDepartmentName oldName:orgObject.departName];
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSDictionary * dataDict = sender;
        if (dataDict[@"departName"] != nil && [dataDict[@"departName"] length] >0) {
            orgObject.departName = dataDict[@"departName"];
            [weakSelf.treeView reloadRowsForItems:@[orgObject] withRowAnimation:RATreeViewRowAnimationNone];
        }
    };
}
-(void)chooseEmployeeWithParent:(DepartObject *)orgObject{
    OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:orgObject];
    if (!cell.arrowExpand) {
        cell.arrowExpand = YES;
        [self.treeView expandRowForItem:orgObject expandChildren:NO withRowAnimation:RATreeViewRowAnimationNone];
    }
    TFJunYou_SelectFriendsVC * addEmployeeVC = [[TFJunYou_SelectFriendsVC alloc] init];
    addEmployeeVC.delegate = self;
    addEmployeeVC.didSelect = @selector(addEmployeeDelegate:);
    NSMutableSet * existSet = _employeesDict[orgObject.companyId];
    addEmployeeVC.existSet = existSet;
    [g_navigation pushViewController:addEmployeeVC animated:YES];
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray * dataArray = sender;
            NSMutableArray * employeeObjArr = [NSMutableArray array];
            for (NSDictionary * child in dataArray) {
                if (child[@"userId"] != nil) {
                    EmployeObject * employ = [EmployeObject employWithDict:child];
                    [employeeObjArr addObject:employ];
                }
            }
            NSMutableSet * existSet = weakSelf.employeesDict[orgObject.companyId];
            NSMutableArray *addUserArr = [NSMutableArray array];
            NSMutableArray *haveUserArr = [NSMutableArray array];
            for (int i = 0; i<employeeObjArr.count; i++) {
                EmployeObject * allEmp = employeeObjArr[i];
                if (![existSet containsObject:allEmp.userId]) {
                    [addUserArr addObject:allEmp];
                }else {
                    [haveUserArr addObject:allEmp];
                }
            }
            if (addUserArr.count <= 0) {
                return;
            }
            NSMutableIndexSet * addRowIndex = [NSMutableIndexSet indexSet];
            for (int i = 0; i<addUserArr.count; i++) {
                [addRowIndex addIndex:i+orgObject.children.count];
            }
            for (EmployeObject * employ in addUserArr) {
                if (![existSet containsObject:employ.userId]) {
                    [existSet addObject:employ.userId];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray *arr = [orgObject.children mutableCopy];
                [arr addObjectsFromArray:addUserArr];
                orgObject.employees = addUserArr;
                orgObject.children = arr;
                [weakSelf.treeView insertItemsAtIndexes:addRowIndex inParent:orgObject withAnimation:RATreeViewRowAnimationRight];
                [weakSelf.treeView reloadRowsForItems:@[orgObject] withRowAnimation:RATreeViewRowAnimationRight];
            });
        });
    };
}
-(void)deleteNodeWithItem:(id)item{
    self.isNotDele = NO;
    self.item = item;
    DepartObject *parent = [self.treeView parentForItem:item];
    NSUInteger index = 0;
    if ([item isKindOfClass:[EmployeObject class]]) {
        for (id obj in parent.children) {
            EmployeObject *employe = (EmployeObject *)obj;
            EmployeObject *employeItem = (EmployeObject *)item;
            if ([employe isKindOfClass:[EmployeObject class]]) {
                if ([employe.userId intValue] == [employeItem.userId intValue]) {
                    index = [parent.children indexOfObject:employe];
                }
            }
        }
    }else {
        index = [parent.children indexOfObject:item];
    }
    if (index < parent.children.count) {
        if ([[parent.children objectAtIndex:index] isKindOfClass:[DepartObject class]]) {
            DepartObject *dPar = (DepartObject *)[parent.children objectAtIndex:index];
            if (dPar.children.count > 0) {
                [self deleteObject:dPar parent:parent];
                if (self.isNotDele) {
                    [TFJunYou_MyTools showTipView:Localized(@"JX_YouCannotDelete")];
                    return;
                }
            }
            if (dPar.empNum > 0) {
                [g_App showAlert:Localized(@"JX_ConfirmToBeDeleted") delegate:self tag:2001 onlyConfirm:NO];
            }else {
                [self deleNode];
            }
        }else {
            EmployeObject *emObj = (EmployeObject *)[parent.children objectAtIndex:index];
            if ([emObj.userId intValue] == [parent.createUserId intValue]) {
                [TFJunYou_MyTools showTipView:Localized(@"JX_Can'tDelete")];
                return;
            }
            [self deleNode];
        }
    }
}
- (void)deleteObject:(DepartObject *)dPar parent:(DepartObject *)parent {
    for (id obj in dPar.children) {
        if ([obj isKindOfClass:[EmployeObject class]]) {
            EmployeObject *employe = (EmployeObject *)obj;
            if ([employe.userId intValue] == [parent.createUserId intValue]) {
                self.isNotDele = YES;
            }
        }else if ([obj isKindOfClass:[DepartObject class]]){
            DepartObject *depart = (DepartObject *)obj;
            self.isNotDele = NO;
            [self deleteObject:depart parent:parent];
        }
    }
}
- (void)deleNode {
    DepartObject *parent = [self.treeView parentForItem:self.item];
    if ([self.item isMemberOfClass:[EmployeObject class]]) {
        EmployeObject * employee = self.item;
        [g_server deleteEmployee:employee.departmentId userId:employee.userId toView:self];
    }else if ([self.item isMemberOfClass:[DepartObject class]]) {
        DepartObject * depart = self.item;
        [g_server deleteDepartment:depart.departId toView:self];
    }
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSInteger index = 0;
        if (parent == nil) {
            index = [self.dataArray indexOfObject:self.item];
            NSMutableArray *children = [weakSelf.dataArray mutableCopy];
            [children removeObject:weakSelf.item];
            weakSelf.dataArray = [children copy];
        } else {
            if ([weakSelf.item isKindOfClass:[EmployeObject class]]) {
                for (id obj in parent.children) {
                    EmployeObject *employe = (EmployeObject *)obj;
                    EmployeObject *employeItem = (EmployeObject *)weakSelf.item;
                    if ([employe isKindOfClass:[EmployeObject class]]) {
                        if ([employe.userId intValue] == [employeItem.userId intValue]) {
                            index = [parent.children indexOfObject:employe];
                        }
                    }
                }
            }else {
                index = [parent.children indexOfObject:weakSelf.item];
            }
            if (index < parent.children.count) {
                [weakSelf.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:parent withAnimation:RATreeViewRowAnimationRight];
                if (parent) {
                    [weakSelf.treeView reloadRowsForItems:@[parent] withRowAnimation:RATreeViewRowAnimationNone];
                }
            }
            [parent removeChild:weakSelf.item];
            if ([weakSelf.item isMemberOfClass:[EmployeObject class]]) {
                EmployeObject * employee = weakSelf.item;
                NSMutableSet * emplySet = [weakSelf.employeesDict objectForKey:employee.companyId];
                [emplySet removeObject:employee.userId];
            }
        }
    };
}
-(void)employeeDetailWith:(EmployeObject *)employObj{
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = employObj.userId;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
}
-(void)employChangeDepartWith:(EmployeObject *)employObj{
    [self showChooseDepartCurrent:employObj];
}
-(void)modifyEmployeePositionWith:(EmployeObject *)employObj{
    [self inputViewController:OrganizModifyEmployeePosition oldName:employObj.position];
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSDictionary * dataDict = sender;
        if (dataDict[@"position"] != nil && [dataDict[@"position"] length] >0) {
            employObj.position = dataDict[@"position"];
            [weakSelf.treeView reloadRowsForItems:@[employObj] withRowAnimation:RATreeViewRowAnimationFade];
        }
    };
}
-(void)modifyCompanyNameWith:(DepartObject *)orgObject{
    [self inputViewController:OrganizUpdateCompanyName oldName:orgObject.departName];
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSDictionary * dataDict = sender;
        if (dataDict[@"companyName"] != nil && [dataDict[@"companyName"] length] >0) {
            orgObject.departName = dataDict[@"companyName"];
            [weakSelf.treeView reloadRowsForItems:@[orgObject] withRowAnimation:RATreeViewRowAnimationNone];
        }
    };
}
-(void)quitCompanyWith:(DepartObject *)orgObject{
    UIAlertView * alert = [g_App showAlert:Localized(@"OrgaVC_ConfirmQuit") delegate:self];
    alert.tag = 1001;
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
            NSMutableArray * mutaArray = [weakSelf.dataArray mutableCopy];
        for (int i=0; i<mutaArray.count; i++) {
            DepartObject * rootDep = mutaArray[i];
            if ([rootDep.companyId isEqualToString:orgObject.companyId])
                [mutaArray removeObject:rootDep];
        }
            weakSelf.dataArray = mutaArray;
            [weakSelf.treeView reloadData];
    };
}
-(void)deleteCompanyWith:(DepartObject *)orgObject{
    _currentOrgObj = orgObject;
    UIAlertView * alert = [g_App showAlert:@"?????????????????????" delegate:self];
    alert.tag = 1009;
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        NSMutableArray * mutaArray = [weakSelf.dataArray mutableCopy];
        for (int i=0; i<mutaArray.count; i++) {
            DepartObject * rootDep = mutaArray[i];
            if ([rootDep.companyId isEqualToString:orgObject.companyId])
                [mutaArray removeObject:rootDep];
        }
        weakSelf.dataArray = mutaArray;
        [weakSelf.treeView reloadData];
    };
}
#pragma mark ?????????VC
-(void)inputViewController:(OrganizAddType) type oldName:(NSString *)oldName{
    TFJunYou_AddDepartViewController * addDepartVC = [[TFJunYou_AddDepartViewController alloc] init];
    addDepartVC.delegate = self;
    addDepartVC.type = type;
    addDepartVC.oldName = oldName;
    [g_navigation pushViewController:addDepartVC animated:YES];
}
#pragma mark ???????????????
-(void)showChooseDepartCurrent:(EmployeObject *)employeeObj{
    NSString * parentId = employeeObj.departmentId;
    NSDictionary * rootDict = nil;
    while (parentId.length > 0) {
        NSDictionary * parObj = _allDataDict[parentId];
        if (parObj[@"parentId"])
            parentId = parObj[@"parentId"];
        else{
            rootDict = parObj;
            break;
            parentId = nil;
        }
    }
    NSString * rootId = rootDict[@"id"];
    DepartObject * rootDepart = nil;
    for (DepartObject * root in _dataArray) {
        if ([root.departId isEqualToString:rootId]){
            rootDepart = root;
            break;
        }
    }
    TFJunYou_SelDepartViewController * selDepartVC = [[TFJunYou_SelDepartViewController alloc] init];
    selDepartVC.delegate = self;
    selDepartVC.oldDepart = [self.treeView parentForItem:employeeObj];
    selDepartVC.dataArray = @[rootDepart];
    [g_navigation pushViewController:selDepartVC animated:YES];
}
#pragma mark alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            DepartObject * orgObject = _currentOrgObj;
            [g_server quitCompany:orgObject.companyId toView:self];
        }else{
            self.rowActionAfterRequestBlock = nil;
        }
    }else if (alertView.tag == 2001) {
        if (buttonIndex == 1) {
            [self deleNode];
        }else{
        }
    }else if (alertView.tag == 1009) {
        DepartObject * orgObject = _currentOrgObj;
        [g_server deleteCompany:orgObject.companyId userId:g_myself.userId toView:self];
    }
}
#pragma mark - input delegate
-(void)inputDelegateType:(OrganizAddType)organizType text:(NSString *)updateStr{
    switch (organizType) {
        case OrganizAddCompany:
        case OrganizSearchCompany:{
            [self addCompanyDelegate:updateStr];
            break;
        }
        case OrganizAddDepartment:{
            [self addDepartDelegate:updateStr];
            break;
        }
        case OrganizUpdateCompanyName:{
            [self updateCompanyNameDelegate:updateStr];
            break;
        }
        case OrganizUpdateDepartmentName:{
            [self updateDepartmentNameDelegate:updateStr];
            break;
        }
        case OrganizModifyEmployeePosition:{
            [self modifyEmployeePositionDelegate:updateStr];
        }
        default:
            break;
    }
}
#pragma mark ?????????
-(void)addDepartDelegate:(NSString *)departName{
    DepartObject * dataObject = _currentOrgObj;
    [g_server createDepartment:dataObject.companyId parentId:dataObject.departId departName:departName createUserId:nil toView:self];
}
#pragma mark ?????????
-(void)addCompanyDelegate:(NSString *)companyName{
    [g_server createCompany:companyName toView:self];
    if (_noCompanyView)
        _noCompanyView.hidden = YES;
}
#pragma mark ????????????
-(void)updateDepartmentNameDelegate:(NSString *)departNewName{
    DepartObject * departObj = _currentOrgObj;
    [g_server updataDepartmentName:departNewName departmentId:departObj.departId toView:self];
}
#pragma mark ???????????????
-(void)modifyEmployeePositionDelegate:(NSString *)positionStr{
    EmployeObject * employeeObj = _currentOrgObj;
    [g_server modifyPosition:positionStr companyId:employeeObj.companyId userId:employeeObj.userId toView:self];
}
#pragma mark ????????????
-(void)updateCompanyNameDelegate:(NSString *)companyName{
    DepartObject * departObj = _currentOrgObj;
    [g_server updataCompanyName:companyName noticeContent:nil companyId:departObj.companyId toView:self];
}
#pragma mark ?????????
-(void)addEmployeeDelegate:(TFJunYou_SelectFriendsVC*)vc{
    NSArray * allArr;
    if (vc.seekTextField.text.length > 0) {
        allArr = [vc.searchArray copy];
    }else{
        allArr = [vc.letterResultArr copy];
    }
    NSArray * indexArr = [vc.set allObjects];
    NSMutableArray * adduserArr = [NSMutableArray array];
    for (NSNumber * index in indexArr) {
        TFJunYou_UserObject *user;
        if (vc.seekTextField.text.length > 0) {
            user = allArr[[index intValue] % 100000 - 1];
        }else{
            user = [[allArr objectAtIndex:[index intValue] / 100000 - 1] objectAtIndex:[index intValue] % 100000 - 1];
        }
        [adduserArr addObject:user.userId];
    }
    if (adduserArr.count > 0) {
        DepartObject * dataObj = _currentOrgObj;
        [g_server addEmployee:adduserArr companyId:dataObj.companyId departmentId:dataObj.departId roleArray:nil toView:self];
    }
}
#pragma mark - selDepart Delegate
-(void)selNewDepartmentWith:(DepartObject *)newDepart{
    EmployeObject * employeeOBJ = _currentOrgObj;
    [g_server modifyDpart:employeeOBJ.userId companyId:employeeOBJ.companyId newDepartmentId:newDepart.departId toView:self];
    OrganizTableViewCell * cell = (OrganizTableViewCell *)[self.treeView cellForItem:newDepart];
    if (!cell.arrowExpand) {
        cell.arrowExpand = YES;
        [self.treeView expandRowForItem:newDepart expandChildren:NO withRowAnimation:RATreeViewRowAnimationNone];
    }
    __weak typeof(self) weakSelf = self;
    self.rowActionAfterRequestBlock = ^(id sender) {
        DepartObject * oldDepart = [weakSelf.treeView parentForItem:employeeOBJ];
        NSInteger index = [oldDepart.children indexOfObject:employeeOBJ];
        [newDepart addChild:employeeOBJ];
        [oldDepart removeChild:employeeOBJ];
        [weakSelf.treeView insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:0] inParent:newDepart withAnimation:RATreeViewRowAnimationNone];
        if (index < 0 || index > (oldDepart.children.count + 1)) {
            [weakSelf.treeView reloadData];
        }else {
            [weakSelf.treeView deleteItemsAtIndexes:[NSIndexSet indexSetWithIndex:index] inParent:oldDepart withAnimation:RATreeViewRowAnimationNone];
        }
    };
}
-(void)expandAllRows{
    for (DepartObject * depart in _dataArray) {
        if (!depart.parentId.length) {
            [_treeView expandRowForItem:depart expandChildren:NO withRowAnimation:RATreeViewRowAnimationAutomatic];
        }
    }
    [_treeView reloadRows];
}
#pragma mark ??????????????????????????????
-(void)autoConstructTreeView:(NSArray *)originalArray{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [self getRootArray:originalArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = [NSMutableArray arrayWithArray:array];
            if (_dataArray.count > 0){
                [_treeView reloadData];
                [self performSelector:@selector(expandAllRows) withObject:nil afterDelay:0.1f];
            }
        });
    });
}
-(void)addCompanyTreeView:(NSArray *)originalArray{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray * array = [self constructDepartObject:originalArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array.count > 0){
                [_dataArray addObjectsFromArray:array];
                [_treeView reloadData];
                for (DepartObject * depart in array) {
                    [_treeView expandRowForItem:depart expandChildren:YES withRowAnimation:RATreeViewRowAnimationRight];
                }
            }
        });
    });
}
#pragma mark ????????????
-(NSArray <DepartObject *>*) getRootArray:(NSArray *)originalArray{
    NSMutableArray * rootArr = [[NSMutableArray alloc] init];
    for (NSDictionary * companyDict in originalArray) {
        [_companyDict setObject:companyDict forKey:companyDict[@"id"]];
        NSArray * compRootDepartArr = [self constructCompanyObject:companyDict];
        [rootArr addObjectsFromArray:compRootDepartArr];
    }
    return rootArr;
}
-(NSArray <DepartObject *>*) constructCompanyObject:(NSDictionary *)companyDict{
    NSArray *departDictArr = companyDict[@"departments"];
    return [self constructDepartObject:departDictArr];
}
-(NSArray <DepartObject *>*) constructDepartObject:(NSArray *)departArray{
    NSMutableArray * rootArr = [[NSMutableArray alloc] init];
    NSMutableDictionary * allDataDict = [NSMutableDictionary new];
    NSMutableArray *allDataArr = [NSMutableArray array];
    for (NSDictionary * departData in departArray) {
        if (!departData[@"parentId"]) {
            [rootArr addObject:departData];
            if (![_employeesDict objectForKey:departData[@"companyId"]])
                [_employeesDict setObject:[NSMutableSet set] forKey:departData[@"companyId"]];
        }
        [allDataDict setObject:departData forKey:departData[@"id"]];
        [allDataArr addObject:departData];
    }
    for (NSDictionary *departData in departArray) {
        if (departData[@"employees"]) {
            NSMutableSet * emplySet = [_employeesDict objectForKey:departData[@"companyId"]];
            NSArray * emplArr = departData[@"employees"];
            for (NSDictionary * emp in emplArr) {
                if (emp[@"departmentId"] != nil && emp[@"userId"] != nil)
                    [emplySet addObject:[NSString stringWithFormat:@"%@",emp[@"userId"]]];
            }
        }
    }
    NSMutableArray * departArr = [[NSMutableArray alloc] init];
    for (NSDictionary * rootData in rootArr) {
        DepartObject * departObj  = [DepartObject departmentObjectWith:rootData allData:allDataArr];
        [departArr addObject:departObj];
    }
    [_allDataDict addEntriesFromDictionary:allDataDict];
    return departArr;
}
#pragma mark ????????????,????????????????????????
#pragma mark - **????????????**
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_getCompany]){
        if (!array1) {
            [self showNoCompanyView];
        }else{
            [self autoConstructTreeView:array1];
        }
    }else if ([aDownload.action isEqualToString:act_creatCompany]) {
        if (_noCompanyView)
            [_noCompanyView removeFromSuperview];
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_CreateCompanySuccess")];
        if ([dict[@"id"] length] > 0) {
            [_companyDict setObject:dict forKey:dict[@"id"]];
            [g_server departmentListPage:[NSNumber numberWithInt:0] companyId:dict[@"id"] toView:self];
        }
    }else if ([aDownload.action isEqualToString:act_departmentList]) {
        [self addCompanyTreeView:array1];
    }else if ([aDownload.action isEqualToString:act_addEmployee]) {
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_AddEmployeeSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(array1);
        }
    }else if([aDownload.action isEqualToString:act_deleteEmployee]) {
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_DelEmployeeSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(act_deleteEmployee);
        }
    }else if ([aDownload.action isEqualToString:act_modifyDpart]) {
        @try {
            [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_ModifyEmployeeSuccess")];
            if (self.rowActionAfterRequestBlock) {
                self.rowActionAfterRequestBlock(dict);
            }
        } @catch (NSException *exception) {
        } @finally {
        }
    }else if([aDownload.action isEqualToString:act_deleteDepartment]) {
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_DelDepartSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(act_deleteDepartment);
        }
        [g_server getCompanyAuto:self];
    }else if([aDownload.action isEqualToString:act_deleteCompany]) {
        [TFJunYou_MyTools showTipView:@"??????????????????"];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(nil);
        }
    }else if([aDownload.action isEqualToString:act_companyQuit]) {
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(nil);
        }
    }else if([aDownload.action isEqualToString:act_createDepartment]) {
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_CreateDepartSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(dict);
        }
    }else if([aDownload.action isEqualToString:act_updataDepartmentName]) {
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_UpdateDepartNameSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(dict);
        }
    }else if([aDownload.action isEqualToString:act_updataCompanyName]) {
        [TFJunYou_MyTools showTipView:Localized(@"JXAlert_UpdateOK")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(dict);
        }
    }else if([aDownload.action isEqualToString:act_dpartmentInfo]) {
    }else if([aDownload.action isEqualToString:act_UserGet]){
        TFJunYou_UserObject* user = [[TFJunYou_UserObject alloc]init];
        [user getDataFromDict:dict];
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = user;
        vc.fromAddType = 6;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
    }else if ([aDownload.action isEqualToString:act_modifyPosition]){
        [TFJunYou_MyTools showTipView:Localized(@"OrgaVC_ModifyEmployeePositionSuccess")];
        if (self.rowActionAfterRequestBlock) {
            self.rowActionAfterRequestBlock(dict);
        }
    }
}
#pragma mark -
-(int) didServerResultFailed:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict{
    [_wait stop];
    self.rowActionAfterRequestBlock = nil;
    return show_error;
}
-(int) didServerConnectError:(TFJunYou_Connection*)aDownload error:(NSError *)error{
    [_wait stop];
    self.rowActionAfterRequestBlock = nil;
    return show_error;
}
-(void) didServerConnectStart:(TFJunYou_Connection*)aDownload{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_wait start];
    });
}
@end
