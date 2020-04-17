//
//  YTKBaseRequest+YTKLog.h
//  YTKNetwork iOS
//
//  Created by Kangaroo on 2019/1/17.
//  Copyright © 2019年 skyline. All rights reserved.
//

#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTKBaseRequest (YTKLog)

+ (void)ytk_log:(void(^)(NSString *logString))logBlock;

- (void)ytk_logDebugInfoWithRequest:(id)deCodeData;
- (void)ytk_logDebugInfoWithResponse:(id)deCodeData;

@end

@interface NSString (YTKLogEmptyObject)

- (id)ytk_defaultValue:(id)defaultData;

@end

NS_ASSUME_NONNULL_END
