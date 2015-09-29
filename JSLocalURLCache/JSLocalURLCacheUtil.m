//
//  JSLocalURLCacheUtil.m
//  cacheTest
//
//  Created by jason on 15/9/28.
//  Copyright © 2015年 jason. All rights reserved.
//

#import "JSLocalURLCacheUtil.h"
#import "JSFileManager.h"
#import <CommonCrypto/CommonDigest.h>

#define WebCacheDirName @"JSWebCache" //缓存在本地存储的目录

#define CachedURLResponseFileName @"JSLocalURLCache" //缓存响应存储在本地的文件名称
#define CachedURLResponseFileExtension @"plist" //缓存响应存储在本地的文件后缀


@implementation JSLocalURLCacheUtil

#pragma mark - 获取请求对应的缓存文件的路径
+ (NSString *)getCachedFilePathFromRequese:(NSURLRequest *)request
{
    NSString *fileName = [self getCachedFileNameFromRequest:request];
    if (fileName) {
        NSString *filePath = [self getCachedFilePathWithFileName:fileName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //如果文件存在，则返回路径
        if ([fileManager fileExistsAtPath:filePath]) {
            return filePath;
        }
    }
    
    return nil;
}

#pragma mark - 获取请求对应的缓存文件的名称
+ (NSString *)getCachedFileNameFromRequest:(NSURLRequest *)request
{
    NSString *urlString = [[request URL] absoluteString];
    if (urlString) {
        return [JSLocalURLCacheUtil md5Hash:urlString];
    }
    return nil;
}

#pragma mark - 根据文件名称获取缓存的路径
+ (NSString *)getCachedFilePathWithFileName:(NSString *)fileName
{
    NSString *webCacheDirPath = [self getWebCacheDirPathWithNeedToCreate:YES];
    
    return [webCacheDirPath stringByAppendingPathComponent:fileName];
}

#pragma mark - 删除某个请求对应的缓存文件
+ (BOOL)removeCachedFileForRequese:(NSURLRequest *)request
{
    NSString *fileName = [self getCachedFileNameFromRequest:request];
    if (fileName) {
        NSString *filePath = [self getCachedFilePathWithFileName:fileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return NO;
}

#pragma mark - 获取缓存目录路径
+ (NSString *)getWebCacheDirPathWithNeedToCreate:(BOOL)needCreate
{
    NSString *tmpCacheDirPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                                     NSUserDomainMask,
                                                                     YES)
                                 objectAtIndex:0];
    
    NSString *webCacheDirPath = [tmpCacheDirPath stringByAppendingPathComponent:WebCacheDirName];
    
    if (needCreate) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager createDirectoryAtPath:webCacheDirPath withIntermediateDirectories:YES attributes:nil error:nil]) {
            return nil;
        }
        
        BOOL isDirectory = YES;
        if (![fileManager fileExistsAtPath:webCacheDirPath isDirectory:&isDirectory] && !isDirectory) {
            return nil;
        }
    }
    return webCacheDirPath;
}

#pragma mark - 删除缓存目录
+ (BOOL)removeWebCacheDir
{
    NSString *webCacheDirPath = [self getWebCacheDirPathWithNeedToCreate:NO];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:webCacheDirPath error:nil];
}

#pragma mark - 保存缓存响应信息
+ (BOOL)saveCachedURLResponseIntoPlistFileWithMIMEType:(NSString *)MIMEType
                                         CacheFileName:(NSString *)cacheFileName
{
    NSString *cachedPlistFilePath = [JSFileManager getDestFilePathWithSrcFileName:CachedURLResponseFileName
                                                                     SrcExtension:CachedURLResponseFileExtension
                                                                          DestDir:NSCachesDirectory];
    
    return [JSFileManager saveIntoPlistFileWithFilePath:cachedPlistFilePath
                                                    Key:cacheFileName
                                                  Obect:MIMEType];
}

#pragma mark - 获取缓存响应信息
+ (id)getCachedURLResponseFromPlistFileWithCacheFileName:(NSString *)cacheFileName
{
    NSString *cachedPlistFilePath = [JSFileManager getDestFilePathWithSrcFileName:CachedURLResponseFileName
                                                                     SrcExtension:CachedURLResponseFileExtension
                                                                          DestDir:NSCachesDirectory];
    return [JSFileManager getObjectFromPlistFileWithFilePath:cachedPlistFilePath Key:cacheFileName];
}

#pragma mark - 删除某个请求对应的响应信息
+ (BOOL)deleteCachedURLResponseFromPlistFileFromRequese:(NSURLRequest *)request
{
    NSString *cacheFileName = [self getCachedFileNameFromRequest:request];
    if (!cacheFileName) {
        return NO;
    }
    NSString *cachedPlistFilePath = [JSFileManager getDestFilePathWithSrcFileName:CachedURLResponseFileName
                                                                     SrcExtension:CachedURLResponseFileExtension
                                                                          DestDir:NSCachesDirectory];
    return [JSFileManager deleteObjectFromPlistFileWithFilePath:cachedPlistFilePath Key:cacheFileName];
}

#pragma mark - 清空响应信息
+ (BOOL)clearCachedURLResponseFromPlistFile
{
    NSString *cachedPlistFilePath = [JSFileManager getDestFilePathWithSrcFileName:CachedURLResponseFileName
                                                                     SrcExtension:CachedURLResponseFileExtension
                                                                          DestDir:NSCachesDirectory];
    return [JSFileManager clearPlistFileWithFilePath:cachedPlistFilePath];
}


#pragma mark - md5加密
#define CC_MD5_DIGEST_LENGTH 16
+ (NSString *)md5Hash:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String ];
    
    unsigned char digest[ CC_MD5_DIGEST_LENGTH ];
    
    CC_MD5 ( cStr, (CC_LONG) strlen (cStr), digest );
    
    NSMutableString *result = [ NSMutableString stringWithCapacity : CC_MD5_DIGEST_LENGTH * 2 ];
    
    for ( int i = 0 ; i < CC_MD5_DIGEST_LENGTH ; i++)
        
        [result appendFormat : @"%02x" , digest[i]];
    
    return result;
}

@end
