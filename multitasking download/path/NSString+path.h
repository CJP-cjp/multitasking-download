
#import <Foundation/Foundation.h>

@interface NSString (path)

/// 获取Documents目录
- (NSString *)appendDocumentsPath;

/// 获取Cache目录
- (NSString *)appendCachePath;

/// 获取Tmp目录
- (NSString *)appendTempPath;

@end
