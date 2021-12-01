#import <UIKit/UIKit.h>
#import "PageLoadFootView.h"
#import "WeiboData.h"
#import "HBCoreLabel.h"
#import "TFJunYou_TableViewController.h"
#import "TFJunYou__SelectMenuView.h"
@class TFJunYou_Server;
@class TFJunYou_WeiboReplyData;
@class TFJunYou_TextView;
@class TFJunYou_WeiboCell;
@class userInfoVC;
@class TFJunYou_MenuView;
#define WeiboUpdateNotification  @"WeiboUpdateNotification"
@class TFJunYou_WeiboVC;
@protocol weiboVCDelegate <NSObject>
- (void) weiboVC:(TFJunYou_WeiboVC *)weiboVC didSelectWithData:(WeiboData *)data;
@end
@interface TFJunYou_WeiboVC : TFJunYou_TableViewController<HBCoreLabelDelegate,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate>
{
    UITextView* _input;
    UIView* _inputParent;
    void(^_block)(NSString*string);
    NSIndexPath *_deletePath;
    BOOL  animationEnd;
    NSMutableArray* _pool;
    UIView * _bgBlackAlpha;
    TFJunYou__SelectMenuView * _selectView;
}
@property(nonatomic,strong) TFJunYou_UserObject* user;
@property(nonatomic,strong)NSMutableArray* datas;
@property(nonatomic,strong)WeiboData * selectWeiboData;
@property(nonatomic,strong)TFJunYou_WeiboCell* selectTFJunYou_WeiboCell;
@property(nonatomic,strong)TFJunYou_WeiboReplyData * replyDataTemp;
@property(nonatomic,strong)WeiboData * deleteWeibo;
@property(nonatomic,assign) int refreshCount;
@property(nonatomic,assign) NSInteger refreshCellIndex;
@property(nonatomic,assign) int deleteReply;
@property (nonatomic, assign) BOOL isDetail;
@property (nonatomic, copy) NSString *detailMsgId;
@property (nonatomic, assign) BOOL isNotShowRemind;
@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, weak) id<weiboVCDelegate>delegate;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, assign) NSInteger videoIndex;
@property(nonatomic,retain) TFJunYou_VideoPlayer* videoPlayer;
@property(nonatomic,strong) TFJunYou_MenuView *menuView;
@property (nonatomic,retain) UIView * clearBackGround;
-(void)doShowAddComment:(NSString*)s;
-(NSString*)getLastMessageId:(NSArray*)objects;
-(void)delBtnAction:(WeiboData *)cellData;
-(void)btnReplyAction:(UIButton *)sender WithCell:(TFJunYou_WeiboCell *)cell;
-(void)fileAction:(WeiboData *)cellData;
-(void)setupTableViewHeight:(CGFloat)height tag:(NSInteger)tag;
-(instancetype)initCollection;
@end
