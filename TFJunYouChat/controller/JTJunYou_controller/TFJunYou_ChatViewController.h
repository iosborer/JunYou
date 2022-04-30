//
//  TFJunYou_ChatViewController.h
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "TFJunYou_TableViewController.h"
#import "TFJunYou_LocationVC.h"


@class TFJunYou_Emoji;
@class TFJunYou_SelectImageView;
@class TFJunYou_VolumeView;
@class TFJunYou_RoomObject;
@class TFJunYou_BaseChatCell;
@class TFJunYou_VideoPlayer;
@interface TFJunYou_ChatViewController : TFJunYou_TableViewController <UIImagePickerControllerDelegate,UITextViewDelegate,AVAudioPlayerDelegate,UIImagePickerControllerDelegate,AVAudioRecorderDelegate,UINavigationControllerDelegate,LXActionSheetDelegate>
{
    
    NSMutableArray *_pool;
    UITextView *_messageText;
    UIImageView *inputBar;
    UIButton* _recordBtn;
    UIButton* _recordBtnLeft;
    UIImage *_myHeadImage,*_userHeadImage;
    TFJunYou_SelectImageView *_moreView;
    UIButton* _btnFace;
    TFJunYou_emojiViewController* _faceView;
    TFJunYou_Emoji* _messageConent;

    BOOL recording;
    NSTimer *peakTimer;
    
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
	NSURL *pathURL;
    UIView* talkView;
    NSString* _lastRecordFile;
    NSString* _lastPlayerFile;
    NSTimeInterval _lastPlayerTime;
    long _lastIndex;

    double lowPassResults;
    NSTimeInterval _timeLen;
    int _refreshCount;
    
    TFJunYou_VolumeView* _voice;
    NSTimeInterval _disableSay;
    NSString * _audioMeetingNo;
    NSString * _videoMeetingNo;
    NSMutableArray * _orderRedPacketArray ;
}
- (IBAction)sendIt:(id)sender;
- (IBAction)shareMore:(id)sender;
//- (void)refresh;

@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;
@property (nonatomic,strong) roomData * room;
@property (nonatomic,strong) TFJunYou_UserObject *chatPerson;//必须要赋值
@property (nonatomic, strong) TFJunYou_MessageObject *lastMsg;
@property (nonatomic,strong) NSString* roomJid;//相当于RoomJid
@property (nonatomic,strong) NSString* roomId;
@property (nonatomic,strong) TFJunYou_BaseChatCell* selCell;
@property (nonatomic,strong) TFJunYou_LocationVC * locationVC;
@property (nonatomic, strong) NSMutableArray *array;

//@property (nonatomic, strong) TFJunYou_MessageObject *relayMsg;
@property (nonatomic, strong) NSMutableArray *relayMsgArray;
@property (nonatomic, assign) int scrollLine;

@property (nonatomic, strong) NSMutableArray *courseArray;
@property (nonatomic, copy) NSString *courseId;

@property (nonatomic, strong) NSNumber *groupStatus;

@property (nonatomic, assign) BOOL isCYMSGgroupANDFriendy;
@property (nonatomic, strong) NSMutableArray *userNamesWithGroup;
@property (nonatomic, strong) NSMutableArray *userNmaesWithFriend;

@property (nonatomic, assign) BOOL isGroupMessages;
@property (nonatomic, strong) NSMutableArray *userIds;
@property (nonatomic, strong) NSMutableArray *userNames;

@property (nonatomic, assign) BOOL isHiddenFooter;
@property (nonatomic, strong) NSMutableArray *chatLogArray;

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) int newMsgCount;

@property (nonatomic, strong) TFJunYou_VideoPlayer *player;
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) BOOL isShare;
@property (nonatomic, copy) NSString *shareSchemes;


-(void)sendRedPacket:(NSDictionary*)redPacketDict withGreet:(NSString *)greet;
//-(void)onPlay;
//-(void)recordPlay:(long)index;
-(void)resend:(TFJunYou_MessageObject*)p;
-(void)deleteMsg:(TFJunYou_MessageObject*)p;
-(void)showOneMsg:(TFJunYou_MessageObject*)msg;
@end
