#import <UIKit/UIKit.h>
#import "TFJunYou_PacketObject.h"
#import "TFJunYou_GetPacketList.h"
@interface TFJunYou_redPacketDetailVC : TFJunYou_TableViewController
@property (nonatomic,strong) NSString * redPacketId;
@property (nonatomic,strong) NSDictionary * dataDict;
@property (nonatomic,strong) NSArray * OpenMember;
@property (nonatomic,strong) TFJunYou_PacketObject * packetObj;
@property (nonatomic, assign) BOOL isGroup;  
@property (nonatomic, assign) int code; 
@property (strong, nonatomic) UIImageView * headImgV;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *totalMoneyLabel;
@property (strong, nonatomic) UILabel *fromUserLabel;
@property (strong, nonatomic) UILabel *greetLabel;
@property (strong, nonatomic) IBOutlet UILabel *showNumLabel;
@property (strong, nonatomic) UILabel * returnMoneyLabel;
@end
