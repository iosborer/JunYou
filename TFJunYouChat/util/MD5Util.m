#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>
#import "md5.h"
@implementation MD5Util
+(NSString*)getMD5StringWithString:(NSString*)s{
    if(s==nil)
        return nil;
    const char *buf = [s cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    unsigned long n = strlen(buf);
    CC_MD5(buf, (CC_LONG)(n), md);
    printf("%s md5: ", buf);
    char t[50]="",p[50]="";
    int i;
    for(i = 0; i< CC_MD5_DIGEST_LENGTH; i++){
        sprintf(t, "%02x", md[i]);
        strcat(p, t);
        printf("%02x", md[i]);
    }
    s = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
    printf("/n");
    return s;
}
+(NSData*)getMD5DataWithData:(NSData*)data{
    if(data==nil)
        return nil;
    const char *buf = [data bytes];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    unsigned long n = strlen(buf);
    CC_MD5(buf, (CC_LONG)(n), md);
    printf("%s md5: ", buf);
    char t[50]="",p[50]="";
    int i;
    for(i = 0; i< CC_MD5_DIGEST_LENGTH; i++){
        sprintf(t, "%02x", md[i]);
        strcat(p, t);
        printf("%02x", md[i]);
    }
    Byte * byteData = malloc(sizeof(p)*16);
    NSData *content=[NSData dataWithBytes:byteData length:16];
    printf("/n");
    return content;
}
+(NSData*)getMD5DataWithString:(NSString*)str{ //aaa
    if(str==nil)
        return nil;
    const char *buf = [str cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    unsigned long n = strlen(buf);
    CC_MD5(buf, (CC_LONG)(n), md);
    printf("%s md5: ", buf);
    char t[50]="",p[50]="";
    int i;
    for(i = 0; i< CC_MD5_DIGEST_LENGTH; i++){
        sprintf(t, "%02x", md[i]);
        strcat(p, t);
        printf("%02x", md[i]);
    }
    Byte * byteData = malloc(sizeof(p));
    NSData *content=[NSData dataWithBytes:md length:sizeof(md)];
    printf("/n");
    return content;
}
+(NSString*)getMD5StringWithData:(NSData*)data { //aaaaa
    if(data==nil)
        return nil;
    const char *buf = [data bytes];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    unsigned long n = [data length];
    CC_MD5(buf, (CC_LONG)(n), md);
    printf("%s md5: ", buf);
    char t[50]="",p[50]="";
    int i;
    for(i = 0; i< CC_MD5_DIGEST_LENGTH; i++){
        sprintf(t, "%02x", md[i]);
        strcat(p, t);
        printf("%02x", md[i]);
    }
    NSString *s = [NSString stringWithCString:p encoding:NSUTF8StringEncoding];
    printf("/n");
    return s;
}
@end
