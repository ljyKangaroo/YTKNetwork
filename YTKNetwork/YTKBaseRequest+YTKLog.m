//
//  YTKBaseRequest+YTKLog.m
//  YTKNetwork iOS
//
//  Created by Kangaroo on 2019/1/17.
//  Copyright © 2019年 skyline. All rights reserved.
//

#import "YTKBaseRequest+YTKLog.h"

void (^YTK_Log)(NSString *logString);

@implementation YTKBaseRequest (YTKLog)

+ (void)ytk_log:(void (^)(NSString *_Nonnull))logBlock {
    if(!YTK_Log) {
        YTK_Log = [logBlock copy];
    }
}

- (void)ytk_logDebugInfoWithRequest:(id)deCodeData {
#ifdef DEBUG
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];

    [logString appendFormat:@"API Name:\t\t%@\n", [self requestUrl]];
    [logString appendFormat:@"Method:\t\t\t%@\n", [[self methonConvertToString:self.requestMethod] ytk_defaultValue:@"N/A"]];
    id logDeCodeData = deCodeData == nil ? self.requestArgument : deCodeData;
    if (logDeCodeData) {
        [logString appendFormat:@"Params:\n%@", [self dataTOjsonString:logDeCodeData]];
    }

    [self appendURLRequest:logString];

    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    if (YTK_Log) {
        YTK_Log(logString);
    }
#endif
}

- (void)ytk_logDebugInfoWithResponse:(id)deCodeData {
#ifdef DEBUG
    BOOL shouldLogError = self.error ? YES : NO;

    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];

    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long) self.response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:self.response.statusCode]];

    id logDeCodeData = deCodeData == nil ? self.responseObject : deCodeData;
    if (logDeCodeData) {
        [logString appendFormat:@"Content:\n\t%@\n\n", [self dataTOjsonString:logDeCodeData]];
    }
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", self.error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long) self.error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", self.error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", self.error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", self.error.localizedRecoverySuggestion];
    }
//    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];

    //    [logString appendURLRequest:request];
//    [self appendURLRequest:logString];

    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];

    if (YTK_Log) {
        YTK_Log(logString);
    }
#endif
}

- (NSString *)methonConvertToString:(YTKRequestMethod)whichMethon {
    NSString *result = nil;

    switch (whichMethon) {
        case YTKRequestMethodGET:
            result = @"GET";
            break;
        case YTKRequestMethodPOST:
            result = @"POST";
            break;
        case YTKRequestMethodHEAD:
            result = @"HEAD";
            break;
        case YTKRequestMethodPUT:
            result = @"PUT";
            break;
        case YTKRequestMethodDELETE:
            result = @"DELETE";
            break;
        case YTKRequestMethodPATCH:
            result = @"PATCH";
            break;
        default:
            result = @"unknown";
    }
    return result;
}

- (NSString *)dataTOjsonString:(id)object {
    if (object == nil) {
        return nil;
    }
    NSString *jsonString = nil;
    NSError * error;
    NSData *  jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData) {
        if (YTK_Log) {
            YTK_Log([NSString stringWithFormat:@"Got an error: %@", error]);
        }
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (void)appendURLRequest:(NSMutableString *)logString {
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", self.currentRequest.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", self.currentRequest.allHTTPHeaderFields ? self.currentRequest.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:self.currentRequest.HTTPBody encoding:NSUTF8StringEncoding] ytk_defaultValue:@"\t\t\t\tN/A"]];
}

@end

@implementation NSString (YTKLogEmptyObject)

- (id)ytk_defaultValue:(id)defaultData {
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }

    if ([self ytkIsEmptyObject]) {
        return defaultData;
    }

    return self;
}

- (BOOL)ytkIsEmptyObject {
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }

    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *) self length] == 0) {
            return YES;
        }
    }

    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *) self count] == 0) {
            return YES;
        }
    }

    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *) self count] == 0) {
            return YES;
        }
    }
    return NO;
}

@end
