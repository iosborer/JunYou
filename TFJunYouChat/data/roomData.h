#import <Foundation/Foundation.h>
@class memberData;
@interface roomData : NSObject{
    NSString* _tableName;
}
@property(nonatomic,assign) int countryId;
@property(nonatomic,assign) int provinceId;
@property(nonatomic,assign) int cityId;
@property(nonatomic,assign) int areaId;
@property(nonatomic,assign) int category;
@property(nonatomic,assign) int maxCount;
@property(nonatomic,assign) NSInteger curCount;
@property(nonatomic,assign) NSTimeInterval createTime;
@property(nonatomic,assign) NSTimeInterval updateTime;
@property(nonatomic,assign) long updateUserId;
@property(nonatomic,strong) NSString* roomJid;
@property(nonatomic,strong) NSString* roomId;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* desc;
@property(nonatomic,strong) NSString* subject;
@property(nonatomic,strong) NSString* note;
@property(nonatomic,assign) long userId;
@property(nonatomic,strong) NSString* userNickName;
@property (nonatomic, strong) NSString * lordRemarkName;  
@property(nonatomic,assign) BOOL showRead; 
@property (nonatomic, assign) BOOL isLook; 
@property (nonatomic, assign) BOOL isNeedVerify; 
@property (nonatomic, assign) BOOL showMember; 
@property (nonatomic, assign) BOOL allowSendCard; 
@property (nonatomic, assign) BOOL allowHostUpdate; 
@property (nonatomic, assign) BOOL allowInviteFriend; 
@property (nonatomic, assign) BOOL allowUploadFile; 
@property (nonatomic, assign) BOOL allowConference; 
@property (nonatomic, assign) BOOL allowSpeakCourse; 
@property (nonatomic, assign) BOOL isAttritionNotice; 
@property (nonatomic, assign) long long talkTime;   
@property (nonatomic,assign) BOOL   isOpenTopChat; 
@property (nonatomic,assign) BOOL offlineNoPushMsg;
@property (nonatomic,assign) BOOL isSecretGroup;
@property (nonatomic, copy) NSString *chatKeyGroup; 
@property (nonatomic,strong) NSString*   chatRecordTimeOut; 
@property(nonatomic,assign) double longitude;
@property(nonatomic,assign) double latitude;
@property(nonatomic,strong) NSMutableArray* members;

-(memberData *)owner;
-(NSArray<memberData *> *)admins;
-(void)getDataFromDict:(NSDictionary*)dict;
-(BOOL)isMember:(NSString*)theUserId;
-(NSString*)getNickNameInRoom;
-(memberData*)getMember:(NSString*)theUserId;
-(void)setNickNameForUser:(TFJunYou_UserObject*)user;
-(NSString *)roomDataToNSString;
-(void)roomHeadImageToView:(UIImageView *)toView;
+(void)roomHeadImageRoomId:(NSString *)roomId toView:(UIImageView *)toView;
@end

@interface memberData : NSObject{
}
@property(nonatomic,assign) NSTimeInterval createTime;
@property(nonatomic,assign) NSTimeInterval updateTime;
@property(nonatomic,assign) NSTimeInterval active;
@property(nonatomic,assign) NSTimeInterval talkTime;
@property (nonatomic, assign) int offlineNoPushMsg;
@property(nonatomic,assign) int sub;
@property(nonatomic,assign) long userId;
@property(nonatomic,strong) NSString* userNickName;
@property (nonatomic, strong) NSString * roomId;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * cardName;
@property (nonatomic, strong) NSString * lordRemarkName;  
@property (nonatomic, strong) NSNumber * role; 
@property (nonatomic, strong) NSString * idStr;
-(void)getDataFromDict:(NSDictionary*)dict;
-(BOOL)checkTableCreatedInDb:(NSString *)queryRoomId;
+(NSArray <memberData *>*)getSelfMember:(NSString *)queryRoomId;
-(BOOL)insert;
-(BOOL)remove;
-(BOOL)update;
-(BOOL)deleteRoomMemeber;
+(NSArray <memberData *>*)fetchAllMembers:(NSString *)queryRoomId;
+(NSArray <memberData *>*)fetchAllMembers:(NSString *)queryRoomId sortByName:(BOOL)sortByName;
+(NSArray <memberData *>*)fetchAllMembersAndHideMonitor:(NSString *)queryRoomId sortByName:(BOOL)sortByName;
-(memberData *)searchMemberByName:(NSString *)cardName;
+ (memberData *)searchGroupOwner:(NSString *)roomId;
- (memberData*)getCardNameById:(NSString*)aUserId;
- (BOOL)updateRole;
- (BOOL)updateRoleByUserId:(long)userId role:(NSNumber *)role;
- (BOOL)updateCardName;
- (BOOL)updateUserNickName;
+(NSMutableArray *)searchMemberByFilter:(NSString *)filter room:(NSString *)roomId;
+(memberData *)fetchMembersWithText:(NSString *)text withRoomId:(NSString *)roomId;
-(memberData *)doFetchOneMember:(NSString*)sql roomId:(NSString *)roomId;
@end
