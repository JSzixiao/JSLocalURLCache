//
//  JSFileManager.h
//  cacheTest
//
//  Created by jason on 15/9/4.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSFileManager : NSObject

/**
 *  获取目标文件路径
 *
 *  @param srcFileName  源文件名称，该文件位于项目中
 *  @param srcExtension 源文件的扩展名
 *  @param destDir      目标文件
 *  @param bundleName   bundle文件名称
 *
 *  @return 目标的文件路径
 */
+ (NSString *)getDestFilePathWithSrcFileName:(NSString *)srcFileName
                               SrcExtension:(NSString *)srcExtension
                                    DestDir:(NSSearchPathDirectory)destDir
                                  BundleName:(NSString *)bundleName;

/**
 *  保存键值对到plist文件内
 *
 *  @param filePath 目标文件路径
 *  @param key      键
 *  @param object   值
 *
 *  @return 保存成功返回YES，失败返回NO
 */
+ (BOOL)saveIntoPlistFileWithFilePath:(NSString *)filePath
                                 Key:(NSString *)key
                               Obect:(id)object;

/**
 *  根据键值从plist文件内取对应的值
 *
 *  @param filePath 目标文件路径
 *  @param key      键
 *
 *  @return 值
 */
+ (id)getObjectFromPlistFileWithFilePath:(NSString *)filePath Key:(NSString *)key;

/**
 *  从plist文件内删除某个键值对应的值
 *
 *  @param filePath 目标文件路径
 *  @param key      键
 *
 *  @return 返回删除是否成功
 */
+ (BOOL)deleteObjectFromPlistFileWithFilePath:(NSString *)filePath Key:(NSString *)key;

/**
 *  清空plist文件
 *
 *  @param filePath 目标文件路径
 *
 *  @return 返回清空是否成功
 */
+ (BOOL)clearPlistFileWithFilePath:(NSString *)filePath;

@end
