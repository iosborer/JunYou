#import "AESUtil.h"
@implementation AESUtil
static Byte iv[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
+(NSData *)encryptAESData:(NSData *)data key:(NSData *)keyData {
    
    size_t  dataInLength = [data length];
    const void * dataIn = (const void *)[data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutMoved = 0;
    size_t dataOutAvailable = (dataInLength + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCEncrypt,  
                       kCCAlgorithmAES128, 
                       kCCOptionPKCS7Padding,   
                       [keyData bytes],  
                       kCCKeySizeAES128,   
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
+(NSData *)decryptAESData:(NSData *)data key:(NSData *)keyData {
    const void *dataIn;
    size_t dataInLength;
    dataInLength = [data length];
    dataIn = [data bytes];
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; 
    size_t dataOutAvailable = 0; 
    size_t dataOutMoved = 0;
    dataOutAvailable = (dataInLength + kCCBlockSizeAES128) & ~(kCCBlockSizeAES128 - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithmAES128,
                       kCCOptionPKCS7Padding,
                       [keyData bytes],  
                       kCCKeySizeAES128,
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
@end
