#import <Foundation/Foundation.h>
@interface TFJunYou_TransferModel : NSObject
@property (nonatomic, assign) long userId;     
@property (nonatomic, assign) long toUserId;   
@property (nonatomic, strong) NSString *userName;   
@property (nonatomic, strong) NSString *reamrk;     
@property (nonatomic, strong) NSString *createTime; 
@property (nonatomic, assign) double money;         
@property (nonatomic, strong) NSString *outTime;    
@property (nonatomic, assign) int status; 
@property (nonatomic, strong) NSString *receiptTime; 
- (void)getTransferDataWithDict:(NSDictionary *)dict;
@end
