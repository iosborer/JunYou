#import <Foundation/Foundation.h>
@interface OrganizObject : NSObject
@property (copy, nonatomic) NSString *nodeName;
@property (copy, nonatomic) NSString *nodeId;
@property (copy, nonatomic) NSString * parentId;
@property (assign, nonatomic) int type;
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSArray *children;
- (id)initWithDict:(NSDictionary *)nodeDict;
+ (id)organizObjectWithDict:(NSDictionary *)nodeDict;
- (void)addChild:(id)child;
- (void)removeChild:(id)child;
@end
