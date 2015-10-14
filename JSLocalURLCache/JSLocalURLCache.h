//
//  JSLocalURLCache.h
//  cacheTest
//
//  Created by jason on 15/9/2.
//  Copyright (c) 2015年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSLocalURLCache : NSURLCache

+ (JSLocalURLCache *)sharedURLCache;

- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity
                          diskCapacity:(NSUInteger)diskCapacity;

- (void)removeAllCachedResponses;

- (void)removeCachedResponseForRequest:(NSURLRequest *)request;

+ (float)getCachedResponsesSize;

+ (NSString *)getCachedResponsesSizeToShow;
@end