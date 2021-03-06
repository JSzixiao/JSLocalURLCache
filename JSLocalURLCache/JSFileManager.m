//
//  JSFileManager.m
//  cacheTest
//
//  Created by jason on 15/9/4.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import "JSFileManager.h"

@implementation JSFileManager

#pragma mark - 获取目标文件路径
+ (NSString *)getDestFilePathWithSrcFileName:(NSString *)srcFileName
                                     SrcExtension:(NSString *)srcExtension
                                    DestDir:(NSSearchPathDirectory)destDir
                                  BundleName:(NSString *)bundleName
{
    NSBundle *resourceBundle = [NSBundle mainBundle];
    //plist文件在项目中的路径
    NSString *plistInProjectDirPath = nil;
    
    if (bundleName != nil) {
        NSString * bundlePath = [resourceBundle pathForResource:bundleName ofType:@"Bundle"];
        plistInProjectDirPath = [bundlePath stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"%@.%@", srcFileName, srcExtension]];
    } else {
        plistInProjectDirPath = [resourceBundle
                                 pathForResource:srcFileName ofType:srcExtension];
    }
    
    //缓存目录的路径
    NSString *plistInCacheDirPath = [NSSearchPathForDirectoriesInDomains(destDir,
                                                                         NSUserDomainMask,
                                                                         YES)
                                     objectAtIndex:0];
    //得到完整的文件名
    NSString *filePath = [plistInCacheDirPath stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%@.%@", srcFileName, srcExtension]];
    
    //创建文本管理器对象，辅助做文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //判断该文件是否存在，若文件不存在就复制文件到指定目录
    if (![fileManager fileExistsAtPath:filePath]) {
        //复制文件到指定目录
        [fileManager copyItemAtPath:plistInProjectDirPath toPath:filePath error:nil];
    }
    return filePath;
}

#pragma mark - 保存键值对到plist文件内
+ (BOOL)saveIntoPlistFileWithFilePath:(NSString *)filePath
                                 Key:(NSString *)key
                               Obect:(id)value
{
    //创建文本管理器对象，辅助做文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return NO;
    }
    
    NSMutableDictionary *plistDic =  [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDic setObject:value forKey:key];
    [plistDic writeToFile:filePath atomically:YES];
    
    return YES;
}

#pragma mark - 根据键值从plist文件内取对应的值
+ (id)getObjectFromPlistFileWithFilePath:(NSString *)filePath Key:(NSString *)key
{
    //创建文本管理器对象，辅助做文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return nil;
    }
    
    NSMutableDictionary *plistDic =  [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    return [plistDic objectForKey:key];
}

#pragma mark - 从plist文件内删除某个键值对应的值
+ (BOOL)deleteObjectFromPlistFileWithFilePath:(NSString *)filePath Key:(NSString *)key
{
    //创建文本管理器对象，辅助做文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return NO;
    }
    
    NSMutableDictionary *plistDic =  [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDic removeObjectForKey:key];
    [plistDic writeToFile:filePath atomically:YES];
    return YES;
}

#pragma mark - 清空plist文件
+ (BOOL)clearPlistFileWithFilePath:(NSString *)filePath
{
    //创建文本管理器对象，辅助做文件管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:filePath]) {
        return NO;
    }
    
    NSMutableDictionary *plistDic =  [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [plistDic removeAllObjects];
    [plistDic writeToFile:filePath atomically:YES];
    return YES;
}

//单个文件的大小
+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小
+ (float)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}

@end
