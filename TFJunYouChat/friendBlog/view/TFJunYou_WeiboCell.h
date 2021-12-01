#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"
#import "HBShowImageControl.h"
#import "WeiboData.h"
#import "TFJunYou_WeiboVC.h"
#import <QuickLook/QuickLook.h>
#import "ReplyCell.h"
#import "TFJunYou_AudioPlayer.h"
#import "TFJunYou_VideoPlayer.h"
#define REPLY_BACK_COLOR 0xd5d5d5
@class MPMoviePlayerController;
@class userInfoVC;
@class TFJunYou_WeiboCell;
@class TFJunYou_WeiboVC;
@protocol TFJunYou_WeiboCellDelegate <NSObject>
- (void)TFJunYou_WeiboCell:(TFJunYou_WeiboCell *)TFJunYou_WeiboCell shareUrlActionWithUrl:(NSString *)url title:(NSString *)title;
- (void)TFJunYou_WeiboCell:(TFJunYou_WeiboCell *)TFJunYou_WeiboCell clickVideoWithIndex:(NSInteger)index;
@end
@interface TFJunYou_WeiboCell : UITableViewCell<HBShowImageControlDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSArray * _replys;
    NSIndexPath * _indexPath;
    BOOL linesLimit;
    int replyCount;
    NSString* _oldInputText;
    NSMutableArray* _newGifts;
    int _heightPraise;
    NSMutableArray* _pool;
}
@property(nonatomic,retain) UILabel *  title;
@property(nonatomic,retain) HBCoreLabel * content;
@property(nonatomic,retain) UIView * imageContent;
@property(nonatomic,strong) UIView * fileView;
@property (strong, nonatomic) UIImageView * typeView;
@property (strong, nonatomic) UILabel * fileTitleLabel;
@property(nonatomic,retain) UILabel * time;
@property(nonatomic,strong) UIButton * delBtn;
@property(nonatomic,strong) UILabel * locLabel;
@property(nonatomic,retain) TFJunYou_ImageView * mLogo;
@property(nonatomic,retain) UIView * replyContent;
@property(nonatomic,retain) UIButton * btnReply;  
@property(nonatomic,retain) UIButton * btnLike;   
@property(nonatomic,retain) UIButton * btnCollection; 
@property(nonatomic,retain) UIButton * btnReport; 
@property (nonatomic, assign) BOOL isPraise; 
@property (nonatomic, assign) BOOL isCollect; 
@property(nonatomic,retain) UIImageView * back;
@property(nonatomic,retain) UITableView * tableReply;
@property(nonatomic,retain) UIView * lockView;
@property(nonatomic,retain) UIButton *btnDelete;
@property(nonatomic,retain) UIButton * btnShare;
@property(nonatomic,weak) TFJunYou_WeiboVC * controller;
@property(nonatomic,weak) UITableView* tableViewP;
@property(nonatomic,retain) WeiboData* weibo;
@property(nonatomic,retain) TFJunYou_ImageView* imagePlayer;
@property(nonatomic,retain) UIButton* pauseBtn;
@property(nonatomic,assign) int refreshCount;
@property(nonatomic,strong) TFJunYou_AudioPlayer* audioPlayer;
@property(nonatomic,retain) TFJunYou_VideoPlayer* videoPlayer;
@property (nonatomic, weak) id<TFJunYou_WeiboCellDelegate>delegate;
@property(nonatomic,retain) UILabel *moreLabel;
+(float)getHeightByContent:(WeiboData*)data;
+(float) heightForReply:(NSArray*)replys;
-(void)loadReply;
-(void)setReplys:(NSArray*)replys;
-(NSArray *)getReplys;
-(void)refresh;
- (void)setupData;
@end
