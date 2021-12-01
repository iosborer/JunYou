#import <Foundation/Foundation.h>
@interface TFJunYou_TransferNoticeModel : NSObject
@property (nonatomic, strong) NSString *userId;     
@property (nonatomic, strong) NSString *userName;   
@property (nonatomic, strong) NSString *toUserId;   
@property (nonatomic, strong) NSString *toUserName; 
@property (nonatomic, assign) double money;         
@property (nonatomic, assign) int type;             
@property (nonatomic, strong) NSString *createTime; 
- (void)getTransferNoticeWithDict:(NSDictionary *)dict;
@end
