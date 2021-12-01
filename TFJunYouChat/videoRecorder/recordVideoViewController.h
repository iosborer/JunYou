#import <UIKit/UIKit.h>
#import "ImageSelectorViewController.h"
#import "TFJunYou_VideoPlayer.h"

@class TFJunYou_CaptureMedia;
@class TFJunYou_Label;
@class TFJunYou_ImageView;

@interface recordVideoViewController : UIViewController <ImageSelectorViewDelegate>{
    TFJunYou_CaptureMedia* _capture;

    UIView* preview;
    UIImageView *_timeBGView;
    UILabel *_timeLabel;
    TFJunYou_ImageView* _flash;
    TFJunYou_ImageView* _flashOn;
    TFJunYou_ImageView* _flashOff;
    TFJunYou_ImageView* _cammer;
    UIButton* _recrod;
    TFJunYou_ImageView* _close;
    TFJunYou_ImageView* _save;
//    UIImageView *_noticeView;
    UILabel *_noticeLabel;
    UILabel * _recordLabel;
    UIView *_bottomView;
    recordVideoViewController* _pSelf;
}

//- (IBAction)doFileConvert;

@property(nonatomic,assign) BOOL isReciprocal;//是否倒计时,为该参赋值一定也要给mixTime赋值
@property(nonatomic,assign) int maxTime;
@property(nonatomic,assign) int minTime;
@property(nonatomic,assign) BOOL isShowSaveImage;//是否显示选择保存截图界面
@property(nonatomic,assign) int timeLen;
@property(nonatomic,weak) id delegate;
@property(assign) SEL didRecord;
@property (nonatomic,strong) NSString* outputFileName;//返回的video
@property (nonatomic,strong) NSString* outputImage;//返回的截图
@property (nonatomic,strong) TFJunYou_CaptureMedia* recorder;


@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, strong) TFJunYou_VideoPlayer *player;

@end

