#import "DESUtil.h"
@interface DESUtil()
+(NSString *)encryptDESStr:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes;
+(NSString *)decryptDESStr:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes;
@end
@implementation DESUtil
static Byte iv[] = {1,2,3,4,5,6,7,8};
+(NSString *)encryptDESStr:(NSString *)sText key:(NSString *)key{
    return [self encryptDESStr:sText key:key andDesiv:nil];
}
+(NSString *)decryptDESStr:(NSString *)sText key:(NSString *)key{
    return [self decryptDESStr:sText key:key andDesiv:nil];
}
+(NSString *)encryptDESStr:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes
{
    sText = [NSString stringWithFormat:@"%@",sText];
    if ((sText == nil || sText.length == 0) || (key == nil || key.length == 0))
    {
        return @"";
    }
    NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
    size_t  dataInLength = [encryptData length];
    const void * dataIn = (const void *)[encryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutMoved = 0;
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCEncrypt,  
                       kCCAlgorithm3DES, 
                       kCCOptionPKCS7Padding,   
                       [key UTF8String],  
                       kCCKeySize3DES,   
                       iv,  
                       dataIn,  
                       dataInLength,    
                       (void *)dataOut, 
                       dataOutAvailable,    
                       &dataOutMoved);  
    NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    NSString *cipherStr = [data base64EncodedStringWithOptions:0];
    free(dataOut);
    return cipherStr;
}
+(NSString *)decryptDESStr:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes
{
    if ((sText == nil || sText.length == 0) || (key == nil || key.length == 0))
    {
        return @"";
    }
    const void *dataIn;
    size_t dataInLength;
    NSData *decryptData = [[NSData alloc] initWithBase64EncodedString:sText options:NSDataBase64DecodingIgnoreUnknownCharacters];
    dataInLength = [decryptData length];
    dataIn = [decryptData bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; 
    size_t dataOutAvailable = 0; 
    size_t dataOutMoved = 0;
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       [key UTF8String],  
                       kCCKeySize3DES,
                       iv, 
                       dataIn, 
                       dataInLength,
                       (void *)dataOut,
                       dataOutAvailable,
                       &dataOutMoved);
    NSString * plaintStr  = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    free(dataOut);
    return plaintStr;
}
+ (NSString*)stringWithHexBytes2:(NSData *)sender {
    static const char hexdigits[] = "0123456789ABCDEF";
    const size_t numBytes = [sender length];
    const unsigned char* bytes = [sender bytes];
    char *strbuf = (char *)malloc(numBytes * 2 + 1);
    char *hex = strbuf;
    NSString *hexBytes = nil;
    for (int i = 0; i<numBytes; ++i) {
        const unsigned char c = *bytes++;
        *hex++ = hexdigits[(c >> 4) & 0xF];
        *hex++ = hexdigits[(c ) & 0xF];
    }
    *hex = 0;
    hexBytes = [NSString stringWithUTF8String:strbuf];
    return hexBytes;
}
+(NSData*) parseHexToByteArray:(NSString*) hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  
        unichar hex_char1 = [hexString characterAtIndex:i]; 
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; 
        else
            int_ch1 = (hex_char1-87)*16; 
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; 
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); 
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; 
        else
            int_ch2 = hex_char2-87; 
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    return newData;
}
+(NSData *)encryptDESData:(NSData *)data key:(NSData *)keyData {
    NSString *key = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    size_t  dataInLength = [data length];
    const void * dataIn = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutMoved = 0;
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCEncrypt,  
                       kCCAlgorithm3DES, 
                       kCCOptionPKCS7Padding,   
                       [key UTF8String],  
                       kCCKeySize3DES,   
                       iv,  
                       dataIn,  
                       dataInLength,    
                       (void *)dataOut, 
                       dataOutAvailable,    
                       &dataOutMoved);  
    NSData *data1 = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
    free(dataOut);
    return data1;
}
+(NSData *)decryptDESData:(NSData *)data key:(NSData *)keyData {
    NSString *key = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    const void *dataIn;
    size_t dataInLength;
    dataInLength = [data length];
    dataIn = [data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; 
    size_t dataOutAvailable = 0; 
    size_t dataOutMoved = 0;
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       [key UTF8String],  
                       kCCKeySize3DES,
                       iv, 
                       dataIn, 
                       dataInLength,
                       (void *)dataOut,
                       dataOutAvailable,
                       &dataOutMoved);
    free(dataOut);
    return [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
}
@end
