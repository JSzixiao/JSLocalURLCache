//
//  JSLocalURLCacheUtil.h
//  cacheTest
//
//  Created by jason on 15/9/28.
//  Copyright © 2015年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSLocalURLCacheUtil : NSObject

/**
 *  获取请求对应的缓存文件的路径
 *
 *  @param request 请求
 *
 *  @return 缓存文件路径
 */
+ (NSString *)getCachedFilePathFromRequese:(NSURLRequest *)request;

/**
 *  获取请求对应的缓存文件的名称
 *
 *  @param request 请求
 *
 *  @return 缓存文件名称
 */
+ (NSString *)getCachedFileNameFromRequest:(NSURLRequest *)request;

/**
 *  根据文件名称获取缓存的路径
 *
 *  @param fileName 缓存文件名称
 *
 *  @return 缓存文件路径
 */
+ (NSString *)getCachedFilePathWithFileName:(NSString *)fileName;

/**
 *  删除某个请求对应的缓存文件
 *
 *  @param request 请求
 *
 *  @return 返回删除是否成功
 */
+ (BOOL)removeCachedFileForRequese:(NSURLRequest *)request;

/**
 *  获取缓存目录路径
 *
 *  @param needCreate 是否需要创建
 *
 *  @return 返回缓存目录路径
 */
+ (NSString *)getWebCacheDirPathWithNeedToCreate:(BOOL)needCreate;

/**
 *  删除缓存目录
 *
 *  @return 返回删除是否成功
 */
+ (BOOL)removeWebCacheDir;

/**
 *  保存缓存响应信息
 *
 *  @param MIMEType      缓存响应的MIMEType
 *  @param cacheFileName 缓存文件名称
 *
 *  @return 保存成功或者失败
 */
+ (BOOL)saveCachedURLResponseIntoPlistFileWithMIMEType:(NSString *)MIMEType
                                         CacheFileName:(NSString *)cacheFileName;

/**
 *  获取缓存响应信息
 *
 *  @param cacheFileName 缓存文件名称
 *
 *  @return 返回缓存响应信息
 */
+ (id)getCachedURLResponseFromPlistFileWithCacheFileName:(NSString *)cacheFileName;

/**
 *  删除某个请求对应的响应信息
 *
 *  @param request 请求
 *
 *  @return 返回删除是否成功
 */
+ (BOOL)deleteCachedURLResponseFromPlistFileFromRequese:(NSURLRequest *)request;

/**
 *  清空响应信息
 *
 *  @return 返回清空是否成功
 */
+ (BOOL)clearCachedURLResponseFromPlistFile;

/**
 *  md5加密
 *
 *  @param srcString 目标字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)md5Hash:(NSString *)srcString;
@end
