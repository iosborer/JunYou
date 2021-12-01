#import "TFJunYou_admobViewController.h"
@protocol SendRedPacketVCDelegate <NSObject>
-(void)sendRedPacketDelegate:(NSDictionary *)redpacketDict;
@end
@interface TFJunYou_SendRedPacketViewController : TFJunYou_admobViewController
@property (nonatomic, assign) BOOL isRoom;
@property (nonatomic,strong) NSString* roomJid;
@property (nonatomic, strong) NSString *toUserId;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, weak) id<SendRedPacketVCDelegate> delegate;
@property (nonatomic,strong) roomData* room;
@end
