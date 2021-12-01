#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    SkinType_PeaGreen  =   0,  
    SkinType_ClearBlue,        
    SkinType_CoralRed,         
    SkinType_NephelinePowder,  
    SkinType_CobaltPaleGreen,  
    SkinType_DarkPurple,       
    SkinType_BusinessBlue,     
    SkinType_ComposedRed,      
} SkinType;
typedef NSString * SkinDictKey NS_STRING_ENUM;
extern SkinDictKey const SkinDictKeyName;
extern SkinDictKey const SkinDictKeyColor;
extern SkinDictKey const SkinDictKeyIndex;
@interface TFJunYou_SkinManage : NSObject
@property (readonly, nonatomic, strong) UIColor * themeColor;
@property (readonly, nonatomic, copy) NSString * themeName;
@property (readonly, nonatomic, assign) NSUInteger themeIndex;
@property (readonly, nonatomic, strong) NSArray<NSDictionary<SkinDictKey,id> *> * skinList;
@property (readonly, nonatomic, strong) NSArray<NSString *> * skinNameList;
+(instancetype)sharedInstance;
-(void)switchSkinIndex:(NSUInteger)index;
-(UIImage *)themeImage:(NSString *)imageName;
-(NSString *)themeImageName:(NSString *)imageName;
-(UIImage *)themeTintImage:(NSString *)imageName;
-(void)resetInstence;
@end
