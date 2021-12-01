#import "TFJunYou_KeyChainStore.h"
#import <AdSupport/AdSupport.h>
@implementation TFJunYou_KeyChainStore
+ (NSMutableDictionary*)getKeychainQuery:(NSString*)service {
    return[NSMutableDictionary dictionaryWithObjectsAndKeys:
           (id)kSecClassGenericPassword,(id)kSecClass,
           service,(id)kSecAttrService,
           service,(id)kSecAttrAccount,
           (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
           nil];
}
+ (void)save:(NSString*)service data:(id)data{
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data]forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery,NULL);
}
+ (id)load:(NSString*)service {
    id ret =nil;
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData =NULL;
    if(SecItemCopyMatching((CFDictionaryRef)keychainQuery,(CFTypeRef*)&keyData) ==noErr){
        @try{
            ret =[NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData*)keyData];
        }@catch(NSException *e) {
            NSLog(@"Unarchiveof %@ failed: %@",service, e);
        }@finally{
        }
    }
    if(keyData)
        CFRelease(keyData);
    return ret;
}
+ (void)deleteKeyData:(NSString*)service {
    NSMutableDictionary*keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
+ (NSString *)getUUIDByKeyChain{
    NSString*strUUID = (NSString*)[TFJunYou_KeyChainStore load:@"com.shiku.im.push.usernamepassword"];
    if([strUUID isEqualToString:@""]|| !strUUID)
    {
        strUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        if(strUUID.length ==0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"])
        {
            CFUUIDRef uuidRef= CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuidRef));
            CFRelease(uuidRef);
            CFUUIDRef puuid = CFUUIDCreate(nil);
            CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
            NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
            NSMutableString *strUUID = result.mutableCopy;
            NSRange range = [strUUID rangeOfString:@"-"];
            while (range.location != NSNotFound) {
                [strUUID deleteCharactersInRange:range];
                range = [strUUID rangeOfString:@"-"];
            }
            NSLog(@"uuid%@",strUUID);
        }
        [TFJunYou_KeyChainStore save:@"com.shiku.im.push.usernamepassword" data:strUUID];
    }
    return strUUID;
}
@end
