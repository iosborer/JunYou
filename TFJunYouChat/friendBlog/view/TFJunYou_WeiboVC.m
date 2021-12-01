#import "TFJunYou_WeiboVC.h"
#import "TFJunYou_WeiboCell.h"
#import "TFJunYou_ObjUrlData.h"
#import "JSONKit.h"
#import "LXActionSheet.h"
#import "TFJunYou_addMsgVC.h"
#import "TFJunYou_TextView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "photosViewController.h"
#import "TFJunYou_UserInfoVC.h"
#import "webpageVC.h"
#import "TFJunYou_BlogRemind.h"
#import "TFJunYou_TabMenuView.h"
#import "TFJunYou_BlogRemindVC.h"
#import "TFJunYou__DownListView.h"
#import "TFJunYou_ReportUserVC.h"
#import "TFJunYou_ActionSheetVC.h"
#import "TFJunYou_MenuView.h"
#import "ImageResize.h"
#import "TFJunYou_CameraVC.h"
#import "HBHttpRequestCache.h"
#import <WebKit/WebKit.h>
#define TopHeight 7
#define CellHeight 45
#define TopImageInset TFJunYou__SCREEN_WIDTH/5*1.8
@interface TFJunYou_WeiboVC ()<UIAlertViewDelegate,TFJunYou_ActionSheetVCDelegate,TFJunYou_SelectMenuViewDelegate,TFJunYou_MenuViewDelegate,TFJunYou_WeiboCellDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TFJunYou_CameraVCDelegate>
{
    BOOL _first;
    NSString * phoneNumber;
     WKWebView* webView;
    NSMutableArray * _images;  
    NSMutableArray * _contents;
    UIImageView *_topBackImageView;
}
@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic, strong) TFJunYou_MessageObject *remindMsg;
@property (nonatomic, strong) NSMutableArray *remindArray;
@property (nonatomic, strong) WeiboData *currentData;
@property (nonatomic, strong) TFJunYou_ActionSheetVC *actionVC;
@property (nonatomic, strong) TFJunYou_WeiboCell *lastCell;   
@property (nonatomic, assign) BOOL isFirstGoin;
@property (nonatomic, strong) NSString *topImageUrl;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat deltaY;
@end
@implementation TFJunYou_WeiboVC 
- (id)init
{
    self = [super init];
    if (self) {
        _pool = [[NSMutableArray alloc]init];
        _refreshCellIndex = -1;
        self.title = Localized(@"JX_LifeCircle");
        self.heightFooter = 0;
        self.heightHeader = 0;
        if (self.isDetail) {
            self.heightHeader = TFJunYou__SCREEN_TOP;
            self.isGotoBack   = YES;
            self.title = Localized(@"JX_Detail");
        }
#ifdef IS_SHOW_MENU
        self.isGotoBack = YES;
#endif
        [self createHeadAndFoot];
        if (!self.isDetail) {
#ifdef IS_SHOW_MENU
            [self setupHeadView];
#endif
        }else {
            self.isShowFooterPull = NO;
        }
        [self buildInput];
        _first = YES;
        self.isGotoBack=NO;
         _replyDataTemp = [[TFJunYou_WeiboReplyData alloc]init];
        _datas=[[NSMutableArray alloc]init];
        [g_notify addObserver:self selector:@selector(doRefresh:) name:kUpdateUserNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(urlTouch:) name:kCellTouchUrlNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(phoneTouch:) name:kCellTouchPhoneNotifaction object:nil];
        [g_notify addObserver:self selector:@selector(remindNotif:) name:kXMPPMessageWeiboRemind object:nil];
        [g_notify addObserver:self selector:@selector(didEnterBackground:) name:kApplicationDidEnterBackground object:nil];
        _remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
        if (_remindArray.count > 0 && !self.isNotShowRemind) {
            [self createTableHeadShowRemind];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                int number = 0;
                       if (g_App.linkArray.count == 0) {
                           number = 2;
                        }else if(g_App.linkArray.count == 1){
                          number = 3;
                        }else if(g_App.linkArray.count == 2){
                          number = 100;
                       }
                [g_mainVC.tb setBadge:number title:[NSString stringWithFormat:@"%ld",_remindArray.count]];
            });
        }else {
            [self createTableHeadShowRemind];
        }
        [self getWeiboBackImage];
    }
    return self;
}
- (void)setupHeadView {
    self.tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_TOP)];
    self.tableHeader.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableHeader];
    TFJunYou_Label* p = [[TFJunYou_Label alloc]initWithFrame:CGRectMake(40, TFJunYou__SCREEN_TOP - 32, self_width-40*2, 20)];
    p.backgroundColor = [UIColor clearColor];
    p.textAlignment   = NSTextAlignmentCenter;
    p.textColor       = [UIColor blackColor];
    p.text = self.title;
    p.font = [UIFont systemFontOfSize:18.0];
    p.userInteractionEnabled = YES;
    [self.tableHeader addSubview:p];
    if (self.isGotoBack) {
        self.gotoBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, TFJunYou__SCREEN_TOP - 46, 46, 46)];
        [self.gotoBackBtn setBackgroundImage:[UIImage imageNamed:@"title_back_black_big"] forState:UIControlStateNormal];
        [self.gotoBackBtn addTarget:self action:@selector(actionQuit) forControlEvents:UIControlEventTouchUpInside];
        [self.gotoBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.gotoBackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.tableHeader addSubview:self.gotoBackBtn];
    }
    if (!self.isDetail && [self.user.userId isEqualToString:MY_USER_ID]) {
        UIButton* btn = [UIFactory createButtonWithImage:@"im_003_more_button_black"
                                               highlight:nil
                                                  target:self
                                                selector:@selector(onAddMsg:)];
        btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH - 18-15*2, TFJunYou__SCREEN_TOP - 18-15*2, 18+15*2, 18+15*2);
        [self.tableHeader addSubview:btn];
    }
}
-(instancetype)initCollection{
    if (self = [super init]) {
        self.isCollection = YES;
        self.title = Localized(@"JX_MyCollection");
        self.isGotoBack = YES;
        self.heightHeader = TFJunYou__SCREEN_TOP;
        self.heightFooter = 0;
        self.datas = [NSMutableArray array];
        self.user = g_myself;
        [self createHeadAndFoot];
        [self createTableHeadShowRemind];
        self.footer.hidden = YES;
        [self getWeiboBackImage];
    }
    return self;
}
-(void)dealloc{
    [_pool removeAllObjects];
    [g_notify removeObserver:self name:kUpdateUserNotifaction object:nil];
    [g_notify removeObserver:self name:kCellTouchUrlNotifaction object:nil];
    [g_notify removeObserver:self name:kXMPPMessageWeiboRemind object:nil];
    [g_notify removeObserver:self name:kApplicationDidEnterBackground object:nil];
}
- (void)getWeiboBackImage {
    [g_server getUser:_user.userId toView:self];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [g_notify  addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [g_notify  removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[HBHttpRequestCache shareCache] clearMemoryCache];
}
- (void)actionQuit {
    [self didEnterBackground:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [super actionQuit];
}
- (void) remindNotif:(NSNotification *)notif {
    TFJunYou_MessageObject *msg = notif.object;
    self.remindMsg = msg;
    _remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
    if (!self.isNotShowRemind) {
        [self createTableHeadShowRemind];
    }else {
        [self showTopImage];
    }
    [self getServerData];
}
- (void)didEnterBackground:(NSNotification *)notif {
    for (NSInteger i = 0; i < _datas.count; i ++) {
        TFJunYou_WeiboCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell) {
            if (cell.audioPlayer != nil) {
                [cell.audioPlayer stop];
            }
        }
    }
}
-(void)getServerData{
    if (self.isCollection) {
        [g_server userCollectionListWithType:0 pageIndex:0 toView:self];
    }else if (self.isDetail) {
        [g_server getMessage:self.detailMsgId toView:self];
    }else{
        [g_App.jxServer listMessage:0 messageId:[self getLastMessageId:_datas] toView:self];
    }
}
-(void)scrollToPageUp{
    [_wait start];
    [super scrollToPageUp];
}
#pragma mark ------------------数据成功返回----------------------
-(void) didServerResultSucces:(TFJunYou_Connection*)aDownload dict:(NSDictionary*)dict array:(NSArray*)array1{
    [_wait stop];
    if([aDownload.action isEqualToString:act_UploadFile]){
        TFJunYou_UserObject *user = [[TFJunYou_UserObject alloc] init];
        user.msgBackGroundUrl = [(NSDictionary *)[dict[@"images"] firstObject] objectForKey:@"oUrl"];
        [g_server updateUser:user toView:self];
    }
    if ([aDownload.action isEqualToString:act_UserUpdate]) {
        NSString *urlStr = [NSString stringWithFormat:@"%@",dict[@"msgBackGroundUrl"]];
        if (IsStringNull(urlStr)) {
            [g_server getHeadImageLarge:_user.userId userName:_user.userNickname imageView:_topBackImageView];
        }else {
            [g_server getImage:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] imageView:_topBackImageView];
        }
    }
    if([aDownload.action isEqualToString:act_CommentAdd]){
        [_replyDataTemp setMatch];
        for (NSInteger i = 0; i < _datas.count; i ++) {
            WeiboData *data = _datas[i];
            if ([data.messageId isEqualToString:_selectWeiboData.messageId]) {
                _selectWeiboData = data;
                self.selectTFJunYou_WeiboCell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                break;
            }
        }
        if ( _selectWeiboData.replys.count >= 20) {
             _selectWeiboData.replys = [NSMutableArray arrayWithArray:[ _selectWeiboData.replys subarrayWithRange:NSMakeRange(0, 19)]];
        }
         _replyDataTemp.replyId = [dict objectForKey:@"resultObject"];
        [ _selectWeiboData.replys insertObject: _replyDataTemp atIndex:0];
         _selectWeiboData.page = 0;
         _selectWeiboData.commentCount += 1;
         _selectWeiboData.replyHeight=[_selectWeiboData heightForReply];
        if ([_selectWeiboData.replys count] != 0) {
            [self.selectTFJunYou_WeiboCell refresh];
        }
        _replyDataTemp = [[TFJunYou_WeiboReplyData alloc]init];
    }
    if ([aDownload.action isEqualToString:act_CommentDel]){
        [_replyDataTemp setMatch];
        [_selectWeiboData.replys removeObjectAtIndex:self.deleteReply];
        _selectWeiboData.page = 0;
        _selectWeiboData.commentCount -= 1;
        _selectWeiboData.replyHeight=[_selectWeiboData heightForReply];
        [self.selectTFJunYou_WeiboCell refresh];
        _replyDataTemp = [[TFJunYou_WeiboReplyData alloc]init];
    }
    if([aDownload.action isEqualToString:act_PraiseAdd]){
        [self doAddPraiseOK];
    }
    if([aDownload.action isEqualToString:act_PraiseDel]){
        [self doDelPraiseOK];
    }
    if([aDownload.action isEqualToString:act_GiftAdd]){
    }
    if([aDownload.action isEqualToString:act_userEmojiAdd]){
        WeiboData *data = _datas[self.lastCell.tag];
        data.isCollect = YES;
        [_datas replaceObjectAtIndex:self.lastCell.tag withObject:data];
        [_table reloadRow:(int)self.lastCell.tag section:0];
        [g_server showMsg:Localized(@"JX_CollectionSuccess") delay:1.3f];
    }
    if([aDownload.action isEqualToString:act_CommentList]){
        for(int i=0;i<[array1 count];i++){
            TFJunYou_WeiboReplyData * reply=[[TFJunYou_WeiboReplyData alloc]init];
            NSDictionary* dict = [array1 objectAtIndex:i];
            reply.type=1;
            reply.addHeight = 60;
            [reply getDataFromDict:dict];
            [reply setMatch];
            [self.selectWeiboData.replys addObject:reply];
        }
        [self.selectTFJunYou_WeiboCell refresh];
    }
    if([aDownload.action isEqualToString:act_MsgDel]){
        [_datas removeObject:_selectWeiboData];
        _refreshCount++;
        [_table reloadData];
    }
    if([aDownload.action isEqualToString:act_MsgList] || [aDownload.action isEqualToString:act_MsgListUser] || [aDownload.action isEqualToString:act_MsgGet]){
        self.isShowFooterPull = [array1 count] >= TFJunYou__page_size;
        if(_page==0)
            [_datas removeAllObjects];
        if(_datas != nil){
            NSMutableArray * tempData = [[NSMutableArray alloc] init];
            NSInteger displayNum = 12;
            if (array1.count > displayNum) {
                for (int i=0; i< displayNum; i++) {
                    NSDictionary* row = [array1 objectAtIndex:i];
                    WeiboData * weibo=[[WeiboData alloc]init];
                    [weibo getDataFromDict:row];
                    [tempData addObject:weibo];
                }
                if (tempData.count > 0){
                    [_datas addObjectsFromArray:tempData];
                    [self loadWeboData:_datas complete:nil formDb:NO];
                }else {
                    if (dict) {
                        WeiboData *data = [[WeiboData alloc] init];
                        [data getDataFromDict:dict];
                        [tempData addObject:data];
                        [_datas addObjectsFromArray:tempData];
                        [self loadWeboData:_datas complete:nil formDb:NO];
                    }
                }
                [_table reloadData];
                [tempData removeAllObjects];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (NSInteger i=displayNum; i<[array1 count]; i++) {
                        NSDictionary* row = [array1 objectAtIndex:i];
                        WeiboData * weibo=[[WeiboData alloc]init];
                        [weibo getDataFromDict:row];
                        [tempData addObject:weibo];
                    }
                    if (tempData.count > 0){
                        [_datas addObjectsFromArray:tempData];
                        [self loadWeboData:_datas complete:nil formDb:NO];
                    }else {
                        if (dict) {
                            WeiboData *data = [[WeiboData alloc] init];
                            [data getDataFromDict:dict];
                            [tempData addObject:data];
                            [_datas addObjectsFromArray:tempData];
                            [self loadWeboData:_datas complete:nil formDb:NO];
                        }
                    }
                });
            }else{
                for (NSInteger i=0; i<[array1 count]; i++) {
                    NSDictionary* row = [array1 objectAtIndex:i];
                    WeiboData * weibo=[[WeiboData alloc]init];
                    [weibo getDataFromDict:row];
                    [tempData addObject:weibo];
                }
                if (tempData.count > 0){
                    [_datas addObjectsFromArray:tempData];
                    [self loadWeboData:_datas complete:nil formDb:NO];
                }else {
                    if (dict) {
                        WeiboData *data = [[WeiboData alloc] init];
                        [data getDataFromDict:dict];
                        [tempData addObject:data];
                        [_datas addObjectsFromArray:tempData];
                        [self loadWeboData:_datas complete:nil formDb:NO];
                    }
                }
                [_table reloadData];
            }
        }
    }
    if ([aDownload.action isEqualToString:act_userCollectionList]) {
        if (_page ==0) {
            [_datas removeAllObjects];
        }
        NSMutableArray * tempData = [[NSMutableArray alloc] init];
        for (int i=0; i<[array1 count]; i++) {
            NSDictionary* row = [array1 objectAtIndex:i];
            NSString * msgStr = row[@"msg"];
            int collectType = [row[@"type"] intValue];
            NSTimeInterval createTime = [row[@"createTime"] doubleValue];
            NSString * emojiId = row[@"emojiId"];
            NSString *url = row[@"url"];
            NSString *fileLength = row[@"fileLength"];
            NSString *fileName = row[@"fileName"];
            NSString *fileSize = row[@"fileSize"];
            NSString *collectContent = row[@"collectContent"];
            WeiboData * weibo=[[WeiboData alloc]init];
            weibo.createTime = createTime;
            weibo.objectId = emojiId;
            if (collectContent.length > 0) {
                weibo.content = collectContent;
            }
            [self weiboData:weibo WithUrl:url msg:msgStr collectType:collectType fileLength:fileLength fileName:fileName fileSize:fileSize];
            [tempData addObject:weibo];
        }
        if (tempData.count > 0){
            [_datas addObjectsFromArray:tempData];
            [self loadWeboData:_datas complete:nil formDb:NO];
        }
        [_table reloadData];
    }
    if ([aDownload.action isEqualToString:act_WeiboDeleteCollect]) {
        [g_server showMsg:Localized(@"JX_weiboCancelCollect") delay:1.3f];
        WeiboData *data = _datas[self.lastCell.tag];
        data.isCollect = NO;
        [_datas replaceObjectAtIndex:self.lastCell.tag withObject:data];
        [_table reloadRow:(int)self.lastCell.tag section:0];
    }
    if ([aDownload.action isEqualToString:act_userEmojiDelete]) {
        [g_server showMsg:Localized(@"JXAlert_DeleteOK") delay:1.3f];
        NSIndexPath * indexPath = [_table indexPathForCell:_selectTFJunYou_WeiboCell];
        [_datas removeObject:_selectWeiboData];
        [_table reloadData];
    }
    if([aDownload.action isEqualToString:act_PhotoList]){
        if([array1 count]>0){
            [photosViewController showPhotos:array1];
        }else{
        }
    }
    if( [aDownload.action isEqualToString:act_UserGet] ){
        TFJunYou_UserObject* p = [[TFJunYou_UserObject alloc]init];
        [p getDataFromDict:dict];
        if (!self.isFirstGoin) {
            self.isFirstGoin = YES;
            _topImageUrl = p.msgBackGroundUrl;
            [self showTopImage];
            return;
        }
        TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
        vc.user       = p;
        vc.fromAddType = 6;
        vc = [vc init];
        [g_navigation pushViewController:vc animated:YES];
        [_pool addObject:vc];
    }
    if([aDownload.action isEqualToString:act_Report]){
        [_wait stop];
        [g_App showAlert:Localized(@"JXUserInfoVC_ReportSuccess")];
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
}
-(void)weiboData:(WeiboData *)weiboData WithUrl:(NSString *)dataUrl msg:(NSString *)msg collectType:(int)collectType fileLength:(NSString *)fileLength fileName:(NSString *)fileName fileSize:(NSString *)fileSize{
    weiboData.userId = MY_USER_ID;
    weiboData.userNickName = MY_USER_NAME;
    if (collectType == 1) {
        weiboData.type = weibo_dataType_image;
        NSArray *urlArr = [dataUrl componentsSeparatedByString:@","];
        for (int i = 0; i < urlArr.count; i++) {
            TFJunYou_ObjUrlData * url=[[TFJunYou_ObjUrlData alloc] init];
            url.url= urlArr[i];
            url.mime=@"image/pic";
            [weiboData.smalls addObject:url];
            [weiboData.larges addObject:url];
            [weiboData.images addObject:url];
        }
    }else if (collectType == 2) {
        weiboData.type = weibo_dataType_video;
        TFJunYou_ObjUrlData * url=[[TFJunYou_ObjUrlData alloc] init];
        url.url= dataUrl;
        url.fileSize = fileSize;
        url.timeLen = @([fileLength intValue]);
        [weiboData.videos addObject:url];
    }else if (collectType == 3) {
        weiboData.type = weibo_dataType_file;
        TFJunYou_ObjUrlData * url=[[TFJunYou_ObjUrlData alloc] init];
        url.url= msg;
        url.fileSize = fileSize;
        url.type = @"4";
        if (fileName.length > 0) {
            url.name = [fileName lastPathComponent];
        }else {
            url.name = [msg lastPathComponent];
        }
        [weiboData.files addObject:url];
    }else if (collectType == 4) {
        weiboData.type = weibo_dataType_audio;
        TFJunYou_ObjUrlData * url=[[TFJunYou_ObjUrlData alloc] init];
        url.url= dataUrl;
        url.fileSize =fileSize;
        url.timeLen = @([fileLength intValue]);
        [weiboData.audios addObject:url];
    }else if (collectType == 5) {
        weiboData.type = weibo_dataType_text;
        weiboData.content= msg;
    }else if (collectType == 6) {
    }
    if( ([weiboData.audios count]>0 || [weiboData.videos count]>0) && [weiboData.images count]<=0){
        TFJunYou_ObjUrlData * url=[[TFJunYou_ObjUrlData alloc]init];
        url.url= [g_server getHeadImageOUrl:MY_USER_ID];
        url.mime=@"image/pic";
        [weiboData.smalls addObject:url];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isDetail && !self.isCollection) {
        _table.contentInset = UIEdgeInsetsMake(-TopImageInset + (THE_DEVICE_HAVE_HEAD ? -44 : -20), 0, 49, 0);
    }
    [UIApplication sharedApplication].statusBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (self.isCollection || self.isDetail) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self scrollToPageUp];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidHide:(NSNotification *)notification
{
    [self doHideKeyboard];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_datas count];
}
#pragma mark - Table view     --------代理--------     data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = nil;
    if (self.isCollection)
        CellIdentifier = [NSString stringWithFormat:@"collectionCell"];
    else
        CellIdentifier = [NSString stringWithFormat:@"TFJunYou_WeiboCell"];
    TFJunYou_WeiboCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil){
        cell = [TFJunYou_WeiboCell alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } 
    if (self.isSend) {
        cell.contentView.userInteractionEnabled = NO;
    }else {
        cell.contentView.userInteractionEnabled = YES;
    }
    WeiboData * weibo;
    if ([_datas count] > indexPath.row) {
        weibo=[_datas objectAtIndex:indexPath.row];
    }
    cell.delegate = self;
    cell.controller=self;
    cell.tableViewP = tableView;
    cell.tag   = indexPath.row;
    cell.isPraise = weibo.isPraise;
    cell.isCollect = weibo.isCollect;
    cell.weibo = weibo;
    [cell setupData];
    float height=[self tableView:tableView heightForRowAtIndexPath:indexPath];
    UIView * view=[cell.contentView viewWithTag:1200];
    if(view==nil){
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = THE_LINE_COLOR;
        line.frame=CGRectMake(0, height-LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH);
        [cell.contentView addSubview:line];
        line.tag=1200;
    }else{
        view.frame=CGRectMake(0, height-LINE_WH, TFJunYou__SCREEN_WIDTH, LINE_WH);
    }
    if (self.isCollection) {
        cell.btnReply.hidden = YES;
        cell.btnLike.hidden = YES;
        cell.btnReport.hidden = YES;
        cell.btnCollection.hidden = YES;
    }
    if (self.isCollection || [weibo.userId isEqualToString:MY_USER_ID]) {
        cell.delBtn.hidden = NO;
    }else {
        cell.delBtn.hidden = YES;
    }
    if (self.isSend) {
        cell.delBtn.hidden = YES;
    }
    [self doAutoScroll:indexPath];
    return cell;
}
- (void)videoStartPlayer {
    [_videoPlayer switch];
}
- (void)TFJunYou_WeiboCell:(TFJunYou_WeiboCell *)TFJunYou_WeiboCell clickVideoWithIndex:(NSInteger)index {
    self.videoIndex = index;
    _videoPlayer = [TFJunYou_VideoPlayer alloc];
    _videoPlayer.videoFile = [[_datas objectAtIndex:index] getMediaURL];
    _videoPlayer.type = TFJunYou_VideoTypeWeibo;
    _videoPlayer.didVideoPlayEnd = @selector(didVideoPlayEnd);
    _videoPlayer.isShowHide = YES;
    _videoPlayer.delegate = self;
    _videoPlayer = [_videoPlayer initWithParent:self.view];
    [self performSelector:@selector(videoStartPlayer) withObject:self afterDelay:0.2];
}
- (void)TFJunYou_WeiboCell:(TFJunYou_WeiboCell *)TFJunYou_WeiboCell shareUrlActionWithUrl:(NSString *)url title:(NSString *)title {
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    webVC.title = title;
    webVC.url = url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
#pragma mark - Table view delegate
-(void)doHideMenu{
    [self resignFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.menuView) {
        [self.menuView dismissBaseView];
        self.lastCell = nil;
    }
    [self doHideMenu];
    [self doHideKeyboard];
    if (self.isCollection) {
        if ([self.delegate respondsToSelector:@selector(weiboVC:didSelectWithData:)]) {
            WeiboData *data = _datas[indexPath.row];
            _currentData = data;
            [g_App showAlert:Localized(@"JXWantSendCollectionMessage") delegate:self tag:2457 onlyConfirm:NO];
        }
    }
    return;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_datas count] != 0 && [_datas count] > indexPath.row) {
        WeiboData * data=[_datas objectAtIndex:indexPath.row];
        data.replyHeight = [data heightForReply];
        float n = [TFJunYou_WeiboCell getHeightByContent:data];
        if (self.isCollection) {
            n -= 20;
            if (data.type == weibo_dataType_text) {
                n -= 10;
            }
        }
        return n+20;
    }
    return 0;
}
#pragma -mark 回调方法
- (void)urlTouch:(NSNotification *)notification{
    self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JXEmoji_OpenUrl")]];
    self.actionVC.delegate = self;
    self.actionVC.tag = 105;
    NSMutableString *str = notification.object;
    if ([str rangeOfString:@"http"].location == NSNotFound) {
        self.urlStr = [NSString stringWithFormat:@"http://%@",str];
    }else {
        self.urlStr = [str copy];
    }
    [g_App.window addSubview:self.actionVC.view];
}
- (void)phoneTouch:(NSNotification *)notification{
    self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JXEmoji_CallPhone")]];
    self.actionVC.delegate = self;
    self.actionVC.tag = 102;
    phoneNumber=notification.object;
    [g_App.window addSubview:self.actionVC.view];
}
- (void)actionSheet:(TFJunYou_ActionSheetVC *)actionSheet didButtonWithIndex:(NSInteger)index {
    if (actionSheet.tag==105){
        if(0==index){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                webpageVC *webVC = [webpageVC alloc];
                webVC.isGotoBack= YES;
                webVC.isSend = YES;
                webVC.title = Localized(@"JXEmoji_OpenUrl");
                webVC.url = self.urlStr;
                webVC = [webVC init];
                [g_navigation.navigationView addSubview:webVC.view];
            });
        }
    }else if (actionSheet.tag==102){
        if(0==index){
            NSString * string=[NSString stringWithFormat:@"tel:%@",phoneNumber];
            if(webView==nil)
                webView=[[WKWebView alloc]initWithFrame:self.view.bounds];
            [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
            webView.hidden=YES;
            [self.view addSubview:webView];
        }
    }else if (actionSheet.tag == 111){
        if (index == 0) {
            UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
            ipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            ipc.delegate = self;
            ipc.allowsEditing = YES;
            ipc.modalPresentationStyle = UIModalPresentationCurrentContext;
            if (IS_PAD) {
                UIPopoverController *pop =  [[UIPopoverController alloc] initWithContentViewController:ipc];
                [pop presentPopoverFromRect:CGRectMake((self.view.frame.size.width - 320) / 2, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }else {
                [self presentViewController:ipc animated:YES completion:nil];
            }
        }else {
            TFJunYou_CameraVC *vc = [TFJunYou_CameraVC alloc];
            vc.cameraDelegate = self;
            vc.isPhoto = YES;
            vc = [vc init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}
-(void)coreLabel:(HBCoreLabel*)coreLabel linkClick:(NSString*)linkStr
{
}
-(void)coreLabel:(HBCoreLabel *)coreLabel phoneClick:(NSString *)linkStr
{
    self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JXEmoji_CallPhone")]];
    self.actionVC.delegate = self;
    self.actionVC.tag = 102;
    phoneNumber=linkStr;
    [g_App.window addSubview:self.actionVC.view];
}
-(void)coreLabel:(HBCoreLabel *)coreLabel mobieClick:(NSString *)linkStr
{
    self.actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JXEmoji_CallPhone"),Localized(@"JX_SendMessage")]];
    self.actionVC.delegate = self;
    self.actionVC.tag = 103;
    phoneNumber=linkStr;
    [g_App.window addSubview:self.actionVC.view];
}
-(void)loadWeboData:(NSArray*)webos complete:(void(^)())complete formDb:(BOOL)fromDb
{
    for(int i = 0 ; i < [webos count];i++){
        WeiboData * weibo = [webos objectAtIndex:i];
        weibo.match=nil;
        [weibo setMatch];
        weibo.uploadFailed=NO;
        weibo.linesLimit=YES;
        weibo.replyHeight=[weibo heightForReply];
        if (weibo.type == weibo_dataType_video) {
            TFJunYou_ObjUrlData * obj =[weibo.smalls firstObject];
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj.url]]];
            if (img.size.height > img.size.width) {
                weibo.videoHeight = 200;
            }else {
                weibo.videoHeight = 150;
            }
        }else {
            weibo.imageHeight=[HBShowImageControl heightForFileStr:weibo.smalls];
            if (weibo.type == weibo_dataType_audio) {
                weibo.imageHeight = 30;
            }
        }
        if(weibo.type == weibo_dataType_file) weibo.fileHeight = 100;
        if (weibo.type == weibo_dataType_share) {
            weibo.shareHeight = 70;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _refreshCount++;
        [self.tableView reloadData];
        if(complete){
            complete();
        }
    });
}
- (void)loadWeboData:(NSArray *) webos {
    [self loadWeboData:webos complete:nil formDb:NO];
}
#pragma mark   ---------------发说说------------
- (void)onAddMsg:(UIButton *)btn{
    if (self.menuView) {
        [self.menuView dismissBaseView];
        self.menuView = nil;
    }
    TFJunYou__SelectMenuView *menuView = [[TFJunYou__SelectMenuView alloc] initWithTitle:@[
        //                                                                             Localized(@"JX_SendWord"),
                                                                                     Localized(@"JX_SendImage"),
                                                                                     Localized(@"JX_SendVoice"),
                                                                                     Localized(@"JX_SendVideo"),
                                                                                     Localized(@"JX_SendFile"),
                                                                                     Localized(@"JX_NewCommentAndPraise")]
                                                                             image:@[@"menu_add_msg",@"menu_add_voice",@"menu_add_video",@"menu_add_file",@"menu_add_reply"]
                                                                        cellHeight:45];
    menuView.delegate = self;
    [g_App.window addSubview:menuView];
}
- (void)didMenuView:(TFJunYou__SelectMenuView *)MenuView WithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        case 1:
        case 2:
        case 3:{
            TFJunYou_addMsgVC* vc = [[TFJunYou_addMsgVC alloc] init];
            vc.block = ^{
                [self scrollToPageUp];
            };
            vc.dataType = (int)index + 2;
            vc.delegate = self;
            vc.didSelect = @selector(hideKeyShowAlert);
            [g_navigation pushViewController:vc animated:YES];
            vc.view.hidden = NO;
        }
            break;
        case 4:{
            TFJunYou_BlogRemindVC *vc = [[TFJunYou_BlogRemindVC alloc] init];
            vc.remindArray = self.remindArray;
            vc.isShowAll = YES;
            [g_navigation pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void) moreListActionWithIndex:(NSInteger)index {
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = touches.anyObject;
    if (_selectView == nil) {
        return;
    }
    CGPoint location = [touch locationInView:_selectView];
    if (location.x < 0 || location.x > TFJunYou__SCREEN_WIDTH/2 || location.y < 7) {
        [self viewDisMissAction];
        return;
    }
    int num = (location.y - TopHeight)/CellHeight;
    if (num >= 0 && num < 4) {
        TFJunYou_addMsgVC* vc = [[TFJunYou_addMsgVC alloc] init];
        vc.block = ^{
            [self scrollToPageUp];
        };
        vc.dataType = num+1;
        vc.delegate = self;
        vc.didSelect = @selector(hideKeyShowAlert);
        [g_navigation pushViewController:vc animated:YES];
        vc.view.hidden = NO;
    }
    if (num == 4) {
        TFJunYou_BlogRemindVC *vc = [[TFJunYou_BlogRemindVC alloc] init];
        vc.remindArray = self.remindArray;
        vc.isShowAll = YES;
        [g_navigation pushViewController:vc animated:YES];
    }
    [self viewDisMissAction];
}
- (void)viewDisMissAction{
    [UIView animateWithDuration:0.4 animations:^{
        _bgBlackAlpha.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_selectView removeFromSuperview];
        _selectView = nil;
        [_bgBlackAlpha removeFromSuperview];
    }];
}
- (void) hideKeyShowAlert
{
    [self doHideKeyboard];
}
- (void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self doHideMenu];
    [self doHideKeyboard];
}
- (void)tapHide:(UITapGestureRecognizer *)tap{
    [self doHideMenu];
    [self doHideKeyboard];
}
-(void)buildInput{
    self.clearBackGround = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TFJunYou__SCREEN_WIDTH, TFJunYou__SCREEN_HEIGHT)];
    UITapGestureRecognizer * tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHide:)];
    [self.clearBackGround addGestureRecognizer:tapG];
    _inputParent = [[UIView alloc]initWithFrame:CGRectMake(0, 200, TFJunYou__SCREEN_WIDTH, 49)];
    _inputParent.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.clearBackGround];
    [self.clearBackGround addSubview:_inputParent];
    _inputParent.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.clearBackGround.hidden = YES;
    _inputParent.opaque = YES;
    _inputParent.hidden = YES;
    _input=[[UITextView alloc]initWithFrame:CGRectMake(15, 8, TFJunYou__SCREEN_WIDTH -30 , 33)];
    _input.delegate = self;
    _input.backgroundColor = [UIColor whiteColor];
    _input.layer.cornerRadius = 3.f;
    _input.layer.masksToBounds = YES;
    _input.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _input.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    _input.contentInset = UIEdgeInsetsZero;
    _input.scrollEnabled = YES;
    _input.scrollsToTop = NO;
    _input.userInteractionEnabled = YES;
    _input.font = [UIFont systemFontOfSize:16.0f];
    _input.textColor = [UIColor blackColor];
    _input.backgroundColor = [UIColor whiteColor];
    _input.keyboardAppearance = UIKeyboardAppearanceDefault;
    _input.keyboardType = UIKeyboardTypeDefault;
    _input.textAlignment = NSTextAlignmentLeft;
    _input.backgroundColor = [UIColor clearColor];
    _input.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _input.layer.borderWidth = 0.65f;
    _input.layer.cornerRadius = 6.0f;
    _input.returnKeyType = UIReturnKeySend;
    [_inputParent addSubview:_input];
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString* s = textView.text;
    unichar c = [s characterAtIndex:s.length-1];
    if (c == '\n'){
        s = [s substringToIndex:s.length-1];
        [self onInputText:s];
    }
    static CGFloat maxHeight =66.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
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
    if (textView.hidden) {
        size.height = 32 + 5.5;
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    _inputParent.frame = CGRectMake(_inputParent.frame.origin.x, TFJunYou__SCREEN_HEIGHT + self.deltaY - (size.height + 16), _inputParent.frame.size.width, size.height + 16);
}
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyboardEndBounds CGRectValue];
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    deltaY=-endRect.size.height;
    self.deltaY = deltaY;
    [_table setFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT+deltaY-_table.frame.size.height, _table.frame.size.width, _table.frame.size.height)];
    [_inputParent setFrame:CGRectMake(0, TFJunYou__SCREEN_HEIGHT+deltaY-_inputParent.frame.size.height, _inputParent.frame.size.width, _inputParent.frame.size.height)];
}
-(void)doHideKeyboard{
    [_input resignFirstResponder];
    _table.frame =CGRectMake(0,self.heightHeader,self_width,TFJunYou__SCREEN_HEIGHT-self.heightHeader-self.heightFooter);
    _inputParent.frame = CGRectMake(0,TFJunYou__SCREEN_HEIGHT-_inputParent.frame.size.height,_inputParent.frame.size.width,_inputParent.frame.size.height);
    _inputParent.hidden = YES;
    self.clearBackGround.hidden = YES;
    _input.frame = CGRectMake(_input.frame.origin.x, 8, _input.frame.size.width, _input.frame.size.height);
}
-(void)setupTableViewHeight:(CGFloat)height tag:(NSInteger)tag{
    _table.contentSize = CGSizeMake(_table.contentSize.width, _table.contentSize.height+height);
    [_table reloadRow:(int)tag section:0];
}
-(IBAction)deleteAction:(id)sender
{
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:Localized(@"JX_DeleteShare")
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:Localized(@"JX_Cencal")
                                        otherButtonTitles:Localized(@"JX_Confirm"), nil];
    alert.tag=222;
    [alert show];
}
-(void)onInputText:(NSString*)s{
    _input.text = nil;
    [self doHideKeyboard];
    _replyDataTemp.messageId =_selectWeiboData.messageId;
    _replyDataTemp.body      = s;
    _replyDataTemp.userId    = MY_USER_ID;
    _replyDataTemp.userNickName    = g_server.myself.userNickname;
    [g_App.jxServer addComment:_replyDataTemp toView:self];
}
-(void)delBtnAction:(WeiboData *)cellData{
    _selectWeiboData = cellData;
    NSUInteger index = [_datas indexOfObject:cellData];
    if (index != NSNotFound) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        _selectTFJunYou_WeiboCell = [_table cellForRowAtIndexPath:indexPath];
    }
 
}
- (void)fileAction:(WeiboData *)cellData {
    TFJunYou_ObjUrlData * obj= [cellData.files firstObject];
    webpageVC *webVC = [webpageVC alloc];
    webVC.isGotoBack= YES;
    webVC.isSend = YES;
    if (obj.name.length > 0) {
        webVC.titleString = obj.name;
    }else {
        webVC.titleString = [obj.url lastPathComponent];
    }
    webVC.url = obj.url;
    webVC = [webVC init];
    [g_navigation.navigationView addSubview:webVC.view];
}
#pragma mark - 点赞、评论控件创建
-(void)btnReplyAction:(UIButton *)sender WithCell:(TFJunYou_WeiboCell *)cell {
    self.lastCell = cell;
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    _selectTFJunYou_WeiboCell = [_table cellForRowAtIndexPath:indexPath];
    _selectWeiboData = [_datas objectAtIndex:cell.tag];
    NSInteger btnTag = sender.tag % 1000;
    if (btnTag == 1) {  
        if (!_selectWeiboData.isPraise) {
            [self praiseAddAction];
        } else {
            [self praiseDelAction];
        }
    }else if(btnTag == 2) { 
        if (cell.weibo.isAllowComment == 0) {
            [self commentAction];
        }else {
            [g_server showMsg:Localized(@"JX_NotComments") delay:.5];
        }
    }else  if(btnTag == 3) { 
        [self collectionWeibo];
    }else{  
        [self reportUserView];
    }
}
- (void)collectionWeibo {
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
    WeiboData * weibo = [_datas objectAtIndex:self.lastCell.tag];
    if (weibo.isCollect) { 
        [g_server userWeiboEmojiDeleteWithId:weibo.messageId toView:self];
    }else {
        TFJunYou_ObjUrlData *data;
        NSString *msg;
        if (weibo.images.count > 0 || weibo.videos.count > 0) { 
            if (weibo.videos.count > 0) { 
                data = [weibo.videos firstObject];
                msg = data.url;
                weibo.type = 2;
            }else {  
                NSMutableArray *imgArr = [NSMutableArray array];
                for (NSDictionary *dict in weibo.images) {
                    NSString *imgUrl = [dict objectForKey:@"oUrl"];
                    [imgArr addObject:imgUrl];
                }
                if (imgArr.count > 1) {
                    msg = [imgArr componentsJoinedByString:@","];
                }else {
                    msg = [imgArr firstObject];
                }
                weibo.type = 1;
            }
        }else if (weibo.audios.count > 0) {
            data = [weibo.audios firstObject];
            msg = data.url;
            weibo.type = 4;
        }else if (weibo.files.count > 0){
            data = [weibo.files firstObject];
            msg = data.url;
            weibo.type = 3;
        }else if (weibo.videos.count > 0){
        }else { 
            weibo.type = 5;
            msg = weibo.content;
        }
        [dataDict setValue:msg forKey:@"msg"];
        [dataDict setValue:@(weibo.type) forKey:@"type"];
        [dataDict setValue:data.name forKey:@"fileName"];
        [dataDict setValue:data.fileSize forKey:@"fileSize"];
        [dataDict setValue:data.timeLen forKey:@"fileLength"];
        [dataDict setValue:weibo.content forKey:@"collectContent"];
        [dataDict setValue:weibo.messageId forKey:@"collectMsgId"];
        [dataDict setValue:@1 forKey:@"collectType"];
        NSMutableArray * emoji = [NSMutableArray array];
        [emoji addObject:dataDict];
        [g_server addFavoriteWithEmoji:emoji toView:self];
    }
}
-(void)reportUserView{
    TFJunYou_ReportUserVC * reportVC = [[TFJunYou_ReportUserVC alloc] init];
    reportVC.user = self.user;
    reportVC.delegate = self;
    [g_navigation pushViewController:reportVC animated:YES];
}
- (void)report:(TFJunYou_UserObject *)reportUser reasonId:(NSNumber *)reasonId {
    [g_server reportUser:_selectWeiboData.userId roomId:nil webUrl:nil reasonId:reasonId toView:self];
}
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
        if (action == @selector(allCommentAction) ||
            action == @selector(commentAction) ||
            action == @selector(giftAction) ||
            action == @selector(forwardAction) ||
            action == @selector(deleteAction) ||
            (action == @selector(praiseAddAction) && !_selectWeiboData.isPraise) ||
            (action == @selector(praiseDelAction) &&  _selectWeiboData.isPraise) || action == @selector(reportUserView))
            return YES;
        else
            return NO;
}
-(void)delAndReplyAction
{
}
-(void)allCommentAction{
}
-(void)doShowAddComment:(NSString*)s{
    self.clearBackGround.hidden = NO;
    _inputParent.hidden = NO;
    [_input becomeFirstResponder];
}
-(void)commentAction{
    _replyDataTemp.toUserId  = nil;
    _replyDataTemp.toNickName  = nil;
    [self doShowAddComment:nil];
}
-(void)praiseAddAction{
    if(!_selectWeiboData.isPraise)
        [g_App.jxServer addPraise:_selectWeiboData.messageId toView:self];
}
-(void)praiseDelAction{
    if(_selectWeiboData.isPraise)
        [g_App.jxServer delPraise:_selectWeiboData.messageId toView:self];
}
-(void)giftAction{
    return;
}
-(void)forwardAction{
}
-(void)deleteAction{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localized(@"JX_IsDeletionConfirmed") message:nil delegate:self cancelButtonTitle:Localized(@"JX_Cencal") otherButtonTitles:Localized(@"JX_Confirm"), nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 2457) {
            [self actionQuit];
            [UIView animateWithDuration:0.3 animations:^{
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
            } completion:^(BOOL finished) {
                [self.delegate weiboVC:self didSelectWithData:_currentData];
            }];
        }else {
            NSInteger i = [_datas indexOfObject:_selectWeiboData];
            TFJunYou_WeiboCell *cell = [_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.audioPlayer != nil) {
                [cell.audioPlayer stop];
                cell.audioPlayer = nil;
            }
            if (cell.videoPlayer != nil) {
                [cell.videoPlayer stop];
                cell.videoPlayer = nil;
            }
            if (self.isCollection) {
                [g_server userEmojiDeleteWithId:_selectWeiboData.objectId toView:self];
            }else {
                [g_server delMessage:_selectWeiboData.messageId toView:self];
            }
        }
    }
}
-(void)createTableHeadShowRemind{
    if (self.isDetail || self.isCollection) {
        _table.tableHeaderView = nil;
        return;
    }
    int number = 0;
    if (g_App.linkArray.count == 0) {
        number = 2;
     }else if(g_App.linkArray.count == 1){
       number = 3;
     }else if(g_App.linkArray.count == 2){
       number = 100;
    }
     [g_mainVC.tb setBadge:number title:[NSString stringWithFormat:@"%ld",_remindArray.count]];
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0,0, TFJunYou__SCREEN_WIDTH,250+TFJunYou__SCREEN_TOP+TopImageInset + (THE_DEVICE_HAVE_HEAD ? 44 : 20))];
    head.backgroundColor = [UIColor whiteColor];
    TFJunYou_ImageView* iv = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake(0,0, TFJunYou__SCREEN_WIDTH,head.frame.size.height)];
    iv.delegate = self;
    iv.didTouch = @selector(actionPhotos);
    iv.changeAlpha = NO;
    iv.backgroundColor = [UIColor lightGrayColor];
    iv.clipsToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    _topBackImageView = iv;
    [self showTopImage];
    [head addSubview:iv];
    UIButton* backBtn = [UIFactory createButtonWithImage:@"blog_back"
                                           highlight:nil
                                              target:self
                                            selector:@selector(actionQuit)];
    backBtn.frame = CGRectMake(15, TFJunYou__SCREEN_TOP-7-30+TopImageInset, 30, 30);
    [head addSubview:backBtn];
    if (!self.isDetail && [self.user.userId isEqualToString:MY_USER_ID]) {
        UIButton* btn = [UIFactory createButtonWithImage:@"blog_add_msg"
                                               highlight:nil
                                                  target:self
                                                selector:@selector(onAddMsg:)];
        btn.frame = CGRectMake(TFJunYou__SCREEN_WIDTH-15-30, TFJunYou__SCREEN_TOP-7-30+TopImageInset, 30, 30);
        [head addSubview:btn];
    }
    UIView *radianView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(head.frame)-47, TFJunYou__SCREEN_WIDTH, 47)];
    radianView.backgroundColor = [UIColor whiteColor];
//    [head addSubview:radianView];
//    [self setPartRoundWithView:radianView corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:27];
    CGFloat btnWH = 38;
    CGFloat btnX = (TFJunYou__SCREEN_WIDTH-38*5)/6;
    CGFloat btnY = iv.frame.size.height-btnWH-15- radianView.frame.size.height;
    if (!self.isDetail && [self.user.userId isEqualToString:MY_USER_ID] && !self.isCollection) {
        UIButton *btn;
        btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnWH, btnWH)];
//        btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX+btnWH/2, btnY, btnWH, btnWH)];
        [btn setTag:1];
        [btn setImage:[UIImage imageNamed:@"weibo_menu_btn_voice"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+btnX, btnY, btnWH, btnWH)];
        [btn setTag:0];
        [btn setImage:[UIImage imageNamed:@"weibo_menu_btn_image"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+btnX, btnY, btnWH, btnWH)];
        [btn setTag:2];
        [btn setImage:[UIImage imageNamed:@"weibo_menu_btn_video"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+btnX, btnY, btnWH, btnWH)];
        [btn setTag:3];
        [btn setImage:[UIImage imageNamed:@"weibo_menu_btn_file"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame)+btnX, btnY, btnWH, btnWH)];
        [btn setTag:4];
        [btn setImage:[UIImage imageNamed:@"weibo_menu_btn_like"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
    }
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, btnY-20-20, TFJunYou__SCREEN_WIDTH, 20)];
    name.textColor = [UIColor whiteColor];
    name.font = SYSFONT(20);
    name.text = self.user.userNickname;
    name.textAlignment = NSTextAlignmentCenter;
    [head addSubview:name];
    name.layer.shadowColor = [UIColor blackColor].CGColor;
    name.layer.shadowOpacity = 0.6;
    name.layer.shadowRadius = 1.0;
    name.clipsToBounds = NO;
    iv = [[TFJunYou_ImageView alloc]initWithFrame:CGRectMake((TFJunYou__SCREEN_WIDTH-79)/2,CGRectGetMinY(name.frame)-10-79, 79,79)];
    iv.layer.masksToBounds = YES;
    iv.layer.cornerRadius = iv.frame.size.width/2;
    iv.layer.borderWidth = 3.f;
    iv.layer.borderColor = [UIColor whiteColor].CGColor;
    iv.delegate = self;
    iv.didTouch = @selector(actionUser);
    [g_server getHeadImageSmall:_user.userId userName:nil imageView:iv];
    [head addSubview:iv];
    if (self.remindArray.count) {
        head.frame = CGRectMake(head.frame.origin.x, head.frame.origin.y, head.frame.size.width, head.frame.size.height + 40-17+15);
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(radianView.frame)-17, 180, 40)];
        btn.backgroundColor = [UIColor colorWithWhite:.2 alpha:1];
        btn.center = CGPointMake(head.frame.size.width / 2, btn.center.y);
        btn.layer.cornerRadius = btn.frame.size.height/2;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(remindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [head addSubview:btn];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        TFJunYou_BlogRemind *br = _remindArray.firstObject;
        [g_server getHeadImageLarge:br.fromUserId userName:br.fromUserName imageView:imageView];
        imageView.layer.cornerRadius = imageView.frame.size.height/2;
        imageView.layer.masksToBounds = YES;
        [btn addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
        label.font = SYSFONT(14.0);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld%@",self.remindArray.count, Localized(@"JX_PieceNewMessage")];
        [btn addSubview:label];
        UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width - 15-7, (40-13)/2, 7, 13)];
        arrowImage.image = [[UIImage imageNamed:@"new_icon_>"] imageWithTintColor:[UIColor blackColor]];
        [btn addSubview:arrowImage];
    }
    _table.tableHeaderView = head;
}
- (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    view.layer.mask = shapeLayer;
}
- (void)didMenuBtn:(UIButton *)button {
    NSInteger index = button.tag;
    switch (index) {
        case 0:
        case 1:
        case 2:
        case 3: {
            TFJunYou_addMsgVC* vc = [[TFJunYou_addMsgVC alloc] init];
            vc.block = ^{
                [self scrollToPageUp];
            };
            vc.dataType = (int)index + 2;
            vc.delegate = self;
            vc.didSelect = @selector(hideKeyShowAlert);
            [g_navigation pushViewController:vc animated:YES];
            vc.view.hidden = NO;
        }
            break;
        case 4:{
            TFJunYou_BlogRemindVC *vc = [[TFJunYou_BlogRemindVC alloc] init];
            vc.remindArray = self.remindArray;
            vc.isShowAll = YES;
            [g_navigation pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)remindBtnAction:(UIButton *)btn {
    TFJunYou_BlogRemindVC *vc = [[TFJunYou_BlogRemindVC alloc] init];
    vc.remindArray = self.remindArray;
    [g_navigation pushViewController:vc animated:YES];
    [[TFJunYou_BlogRemind sharedInstance] updateUnread];
    _remindArray = [[TFJunYou_BlogRemind sharedInstance] doFetchUnread];
    [self createTableHeadShowRemind];
}
-(void)doRefresh:(NSNotification *)notifacation{
    [self createTableHeadShowRemind];
    [self getServerData];
}
-(void)actionUser{
    TFJunYou_UserInfoVC* vc = [TFJunYou_UserInfoVC alloc];
    vc.userId       = self.user.userId;
    vc.fromAddType = 6;
    vc = [vc init];
    [g_navigation pushViewController:vc animated:YES];
    [_pool addObject:vc];
}
-(NSString*)getLastMessageId:(NSArray*)objects{
    NSString* lastId = @"";
    if(_page > 0){
        NSInteger n = [objects count]-1;
        if(n>=0){
            WeiboData* p = [objects objectAtIndex:n];
            lastId = p.messageId;
            p = nil;
        }
    }
    return lastId;
}
-(void)doAddPraiseOK{
    BOOL b=YES;
    for(int i=0;i<[_selectWeiboData.praises count];i++){
        TFJunYou_WeiboReplyData* praise = [_selectWeiboData.praises objectAtIndex:i];
        if([praise.userId intValue] == [g_server.myself.userId intValue]){
            b = NO;
            break;
        }
    }
    if(b){
        TFJunYou_WeiboReplyData* praise = [[TFJunYou_WeiboReplyData alloc]init];
        praise.userId = g_server.myself.userId;
        praise.userNickName = g_server.myself.userNickname;
        praise.type = reply_data_praise;
        [self.selectWeiboData.praises insertObject:praise atIndex:0];
        _selectWeiboData.replyHeight=[_selectWeiboData heightForReply];
    }
    _selectWeiboData.praiseCount++;
    _selectWeiboData.isPraise = YES;
    [self.selectTFJunYou_WeiboCell refresh];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isCollection || self.isDetail) {
        return;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"------------------y = %f",offsetY);
    if (offsetY > 200) {
            [UIView animateWithDuration:.3f animations:^{
                self.tableHeader.transform = CGAffineTransformIdentity; 
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            }];
    }else {
        [UIView animateWithDuration:.3f animations:^{
            self.tableHeader.transform = CGAffineTransformMakeTranslation(0, -TFJunYou__SCREEN_TOP);
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    _lastOffsetY = offsetY;
}
-(void)doDelPraiseOK{
    for(int i=0;i<[_selectWeiboData.praises count];i++){
        TFJunYou_WeiboReplyData* praise = [_selectWeiboData.praises objectAtIndex:i];
        if([praise.userId intValue] == [g_server.myself.userId intValue]){
            [_selectWeiboData.praises removeObjectAtIndex:i];
            break;
        }
    }
    _selectWeiboData.praiseCount--;
    if(_selectWeiboData.praiseCount<0)
        _selectWeiboData.praiseCount=0;
    _selectWeiboData.isPraise = NO;
    _selectWeiboData.replyHeight=[_selectWeiboData heightForReply];
    [self.selectTFJunYou_WeiboCell refresh];
}
-(void)actionPhotos{
    if (![_user.userId isEqualToString:MY_USER_ID]) {
        return;
    }
    TFJunYou_ActionSheetVC *actionVC = [[TFJunYou_ActionSheetVC alloc] initWithImages:@[] names:@[Localized(@"JX_ChoosePhoto"),Localized(@"JX_TakePhoto")]];
    actionVC.delegate = self;
    actionVC.tag = 111;
    [self presentViewController:actionVC animated:NO completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [ImageResize image:[info objectForKey:@"UIImagePickerControllerEditedImage"] fillSize:CGSizeMake(640, 640)];
    NSString* filePath = [TFJunYou_FileInfo getUUIDFileName:@"jpg"];
    [g_server saveImageToFile:image file:filePath isOriginal:NO];
    [g_server uploadFile:filePath validTime:@"-1" messageId:nil toView:self];
    _topBackImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)cameraVC:(TFJunYou_CameraVC *)vc didFinishWithImage:(UIImage *)image {
    UIImage *camImage = [ImageResize image:image fillSize:CGSizeMake(640, 640)];
    NSString* filePath = [TFJunYou_FileInfo getUUIDFileName:@"jpg"];
    [g_server saveImageToFile:camImage file:filePath isOriginal:NO];
    [g_server uploadFile:filePath validTime:@"-1" messageId:nil toView:self];
    _topBackImageView.image = camImage;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.menuView dismissBaseView];
    self.lastCell = nil;
}
- (void)showTopImage {
    if (IsStringNull(_topImageUrl)) {
        [g_server getHeadImageLarge:_user.userId userName:_user.userNickname imageView:_topBackImageView];
    }else {
        [g_server getImage:_topImageUrl imageView:_topBackImageView];
    }
}
@end
