//
//  JSLocalURLCache.m
//  cacheTest
//
//  Created by jason on 15/9/2.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "JSLocalURLCache.h"
#import "JSLocalURLCacheUtil.h"


#define JSLocalURLCacheLogSwitch 0 //开关，用于控制是否输出打印信息

#define JSLocalURLCacheNeedReachability 1 //开关，用于控制是否需要网络

#if JSLocalURLCacheLogSwitch
#define JSNSLog(s,...) NSLog(@"%s LINE:%d < %@ >",__FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define JSNSLog(s,...) nil
#endif

#if JSLocalURLCacheNeedReachability
#import <Reachability/Reachability.h>
#endif

@interface JSLocalURLCache()

/**
 *  硬盘缓存路径
 */
@property (nonatomic, retain) NSString *diskPath;

@end

@implementation JSLocalURLCache

+ (JSLocalURLCache *)sharedURLCache
{
    return (JSLocalURLCache *)[NSURLCache sharedURLCache];
}

#pragma mark - 自定义URLCache创建
/**
 *  自定义URLCache创建
 *
 *  @param memoryCapacity 内存缓存容量
 *  @param diskCapacity   硬盘缓存容量
 *  @param cacheTime      缓存过期时间
 *
 *  @return 自定义URLCache
 */
- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity
                          diskCapacity:(NSUInteger)diskCapacity
{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:nil];
    
    if (self) {
        
    }
    return self;
}


#pragma mark - 获取某个请求的缓存
/**
 *  获取某个请求的缓存
 *  重写
 *
 *  @param request 请求
 *
 *  @return 缓存
 */
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request
{
    //先判断是不是GET方法，因为其他方法不应该被缓存。
    if ([request.HTTPMethod compare:@"GET"] != NSOrderedSame) {
        return [super cachedResponseForRequest:request];
    }

    JSNSLog(@"cache: %@", [[request URL] absoluteString]);
    
#if JSLocalURLCacheNeedReachability
    Reachability *tmpReachability = [Reachability reachabilityForInternetConnection];
    if ([tmpReachability isReachable]) {
        JSNSLog(@"已经联网");
    }
    
    if ([tmpReachability isReachableViaWWAN]) {
        JSNSLog(@"已经联网，使用流量");
    }
    
    if ([tmpReachability isReachableViaWiFi]) {
        JSNSLog(@"已经联网，使用wifi，清理缓存，重新加载");
        [self removeCachedResponseForRequest:request];
        
        [self removeCachedResponseForRequest:request];
        
        return [super cachedResponseForRequest:request];
    }
#endif
    
    //获取请求对应的缓存路径，查看是否有本地硬盘缓存
    NSString *cacheFilePath = [JSLocalURLCacheUtil getCachedFilePathFromRequese:request];
    if (cacheFilePath) {
        JSNSLog(@"使用本地缓存: %@", [[request URL] absoluteString]);
        
        NSString *cacheFileName = [JSLocalURLCacheUtil getCachedFileNameFromRequest:request];
        NSString *MIMEType = [JSLocalURLCacheUtil getCachedURLResponseFromPlistFileWithCacheFileName:cacheFileName];
        if (!MIMEType) {
            return nil;
        }
        
        //从本地缓存取数据并返回...
        NSData *cachedData = [NSData dataWithContentsOfFile:cacheFilePath];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                            MIMEType:MIMEType
                                               expectedContentLength:cachedData.length
                                                    textEncodingName:nil];
        
        return [[NSCachedURLResponse alloc] initWithResponse:response data:cachedData];
    }
    
    return nil;
}

/**
 *  缓存响应到本地
 *
 *  @param cachedResponse 缓存响应
 *  @param request        请求
 */
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request
{
    JSNSLog(@"store: %@", [[request URL] absoluteString]);
    
    NSString *cacheFileName = [JSLocalURLCacheUtil getCachedFileNameFromRequest:request];
    if (cacheFileName) {
        NSString *cacheFilePath = [JSLocalURLCacheUtil getCachedFilePathWithFileName:cacheFileName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //如果文件不存在，则创建
        if (![fileManager fileExistsAtPath:cacheFilePath]) {
            JSNSLog(@"缓存中。。。");
            [cachedResponse.data writeToFile:cacheFilePath atomically:YES];
            [JSLocalURLCacheUtil saveCachedURLResponseIntoPlistFileWithMIMEType:cachedResponse.response.MIMEType CacheFileName:cacheFileName];
        }
    } else {
        JSNSLog(@"不需要缓存");
    }
    
}

#pragma mark - 清除所有缓存
/**
 *  清除所有缓存
 */
- (void)removeAllCachedResponses
{
    [super removeAllCachedResponses];
    
    [JSLocalURLCacheUtil removeWebCacheDir];
    [JSLocalURLCacheUtil clearCachedURLResponseFromPlistFile];
}

#pragma mark - 清除某个请求的缓存
/**
 *  清除某个请求的缓存
 *
 *  @param request 请求
 */
- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
    [super removeCachedResponseForRequest:request];
    [JSLocalURLCacheUtil removeCachedFileForRequese:request];
    [JSLocalURLCacheUtil deleteCachedURLResponseFromPlistFileFromRequese:request];
}

@end
