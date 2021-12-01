#import <UIKit/UIKit.h>
#import "TFJunYou_PacketObject.h"
#import "TFJunYou_GetPacketList.h"
@interface TFJunYou_OpenRedPacketVC : TFJunYou_admobViewController{
    TFJunYou_OpenRedPacketVC *_pSelf;
}
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UILabel *fromUserLabel;
@property (strong, nonatomic) IBOutlet UILabel *greetLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UIView *centerRedPView;
@property (strong, nonatomic) NSDictionary * dataDict;
@property (strong, nonatomic) TFJunYou_PacketObject * packetObj;
@property (strong, nonatomic) NSArray * packetListArray;
@property (strong, nonatomic) IBOutlet UIView *blackBgView;
- (void)doRemove;
@end
