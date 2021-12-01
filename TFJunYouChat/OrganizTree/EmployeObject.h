@interface EmployeObject : NSObject
@property (copy, nonatomic) NSString * companyId;
@property (copy, nonatomic) NSString * departmentId;
@property (copy, nonatomic) NSString * employeeId;
@property (assign, nonatomic) NSInteger role;
@property (copy, nonatomic) NSString * userId;
@property (copy, nonatomic) NSString * nickName;
@property (copy, nonatomic) NSString * position;
+(instancetype)employWithDict:(NSDictionary *)dataDict;
@end
