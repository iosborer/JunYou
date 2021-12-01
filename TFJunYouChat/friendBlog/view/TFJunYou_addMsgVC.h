#import <UIKit/UIKit.h>
#import "TFJunYou_admobViewController.h"
#import "TFJunYou_VideoPlayer.h"
#import "TFJunYou_AudioPlayer.h"
#import "TFJunYou_AudioRecorderViewController.h"
@class TFJunYou_TextView;
@class StreamPlayerViewController;
@protocol TFJunYou_ServerResult;
@interface TFJunYou_addMsgVC : TFJunYou_admobViewController<TFJunYou_ServerResult,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,TFJunYou_AudioRecorderDelegate,LXActionSheetDelegate>{
    int _nSelMenu;
    UIScrollView* svImages;
    UIScrollView* svAudios;
    UIScrollView* svVideos;
    UIScrollView* svFiles;
    int  _recordCount;
    int  _refreshCount;
    int  _buildHeight;
    NSInteger  _photoIndex;
    UIButton* _sendBtn;
    UITextView*  _remark;
    TFJunYou_AudioPlayer* audioPlayer;
    TFJunYou_VideoPlayer* videoPlayer;
    NSMutableArray* _array;
    NSMutableArray* _images;
    NSString* tUrl;
    NSString* oUrl;
}
@property(assign)BOOL isChanged;
@property(nonatomic,assign)int  dataType;
@property(nonatomic,retain) NSString* audioFile;
@property(nonatomic,retain) NSString* videoFile;
@property(nonatomic,retain) NSString* fileFile;
@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic, assign) SEL		didSelect;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareIcon;
@property (nonatomic, copy) NSString *shareUr;
@property (nonatomic, strong) NSString *urlShare; 
@property (nonatomic, assign) BOOL isShortVideo;
@property (nonatomic,assign) int maxImageCount;
@property (nonatomic,copy) void(^block)(void);
-(void)showImages;
-(void)doRefresh;
@end
