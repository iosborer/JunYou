#import <Foundation/Foundation.h>
@interface resumeBaseData : NSObject 
@property(nonatomic,assign) int countryId;
@property(nonatomic,assign) int provinceId;
@property(nonatomic,assign) int cityId;
@property(nonatomic,assign) int areaId;
@property(nonatomic,assign) int homeCityId;
@property(nonatomic,assign) int workexpId;
@property(nonatomic,assign) int diplomaId;
@property(nonatomic,assign) int worktypeId;
@property(nonatomic,assign) int jobStatus;
@property(nonatomic,assign) int salaryId;
@property(nonatomic,assign) NSTimeInterval birthday;
@property(nonatomic,strong) NSString* idNumber;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* evaluate;
@property(nonatomic,strong) NSString* telephone;
@property(nonatomic,strong) NSString* location;
@property(nonatomic,strong) NSString * name;
@property(nonatomic,assign) BOOL sex;
@property(nonatomic,assign) BOOL marital;
-(void)getDataFromDict:(NSDictionary*)dict;
-(NSMutableDictionary*)setDataToDict;
-(void)copyFromUser:(TFJunYou_UserObject*)user;
@end
