//
//  BridgerObjC.m
//  Saily Package Manager
//
//  Created by Lakr Aream on 2019/4/14.
//  Copyright © 2019 Lakr Aream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <notify.h>

#import "BridgerObjC.h"
#import "MobileGestalt.h"
#import "mach/mach.h"
#import "SFWebServer.h"
#import "../../Pods/GZIP/GZIP/GZIP.h"
#import "../../Pods/BZipCompression/Code/BZipCompression.h"


@implementation SailyCommonObject
    
- (void)testCall {
    NSLog(@"Saily Obj-C bridged successfully.");
}

- (void)callToDaemonWith:(NSString *)Str {
    NSLog(@"[*] Call to daemon with notify str: %@", Str);
    notify_post([Str UTF8String]);
}

// https://stackoverflow.com/questions/3184235/how-to-redirect-the-nslog-output-to-file-instead-of-console
- (void) redirectConsoleLogToDocumentFolder {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"/console.txt"];
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

// https://github.com/shaojiankui/iOS-UDID-Safari
- (void)doUDID:(NSString *)UDIDSavePath {
    SFWebServer *server = [SFWebServer startWithPort:6699];
    [server router:@"GET" path:@"/udid.do" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        NSString *config = [[NSBundle mainBundle] pathForResource:@"udid" ofType:@"mobileconfig"];
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithFile:config];
        response.contentType =  @"application/x-apple-aspen-config";
        return response;
    }];
    [server router:@"POST" path:@"/receive.do" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        
        NSString *raw = [[NSString  alloc]initWithData:request.rawData encoding:NSISOLatin1StringEncoding];
        NSString *plistString = [raw substringWithRange:NSMakeRange([raw rangeOfString:@"<?xml"].location, [raw rangeOfString:@"</plist>"].location + [raw rangeOfString:@"</plist>"].length)];
        
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[plistString dataUsingEncoding:NSISOLatin1StringEncoding] options:NSPropertyListImmutable format:nil error:nil];
        
        NSLog(@"%@", [plist description]);
        
        NSLog(@"device info%@",plist);
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:@"success"];
      //值得注意的是重定向一定要使用301重定向,有些重定向默认是302重定向,这样就会导致安装失败,设备安装会提示"无效的描述文件
        response.statusCode = 301;
        response.location = [NSString stringWithFormat:@"Saily://?udid=%@",[plist objectForKey:@"UDID"]];
        [[plist objectForKey:@"UDID"] writeToFile:UDIDSavePath atomically:true encoding:NSUTF8StringEncoding error:nil];
        return response;
    }];
    [server router:@"GET" path:@"/show.do" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:@"success"];
        return response;
    }];
}

- (void)ensureDaemonSocketAt:(NSInteger)port :(NSString *)client_session_token :(NSString *)app_sandboxed_root {
//    SFWebServer *daemonServer = [SFWebServer startWithPort:port];
//    [daemonServer router:@"POST" path:@"/daemoncallback" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
//        NSString *raw = [[NSString  alloc]initWithData:request.rawData encoding:NSUTF8StringEncoding];
//        NSLog(@"[*] Reading daemon call back: %@", raw);
//        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:@"Success."];
//        response.statusCode = 200;
//        return response;
//    }];
//    [daemonServer router:@"GET" path:@"/session_token_query" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
//        NSLog(@"[*] Sending Session Token: %@", client_session_token);
//        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:client_session_token];
//        return response;
//    }];
//    [daemonServer router:@"GET" path:@"/sandbox_location_query" handler:^SFWebServerRespone *(SFWebServerRequest *request) {
//        NSLog(@"[*] Sending sandbox locaion: %@", app_sandboxed_root);
//        SFWebServerRespone *response = [[SFWebServerRespone alloc]initWithHTML:app_sandboxed_root];
//        return response;
//    }];
}

- (NSData *)unGzip:(NSData *)data {
    return [data gunzippedData];
}
    
- (NSData *)unBzip:(NSData *)data{
    NSError *error = nil;
    return [BZipCompression decompressedDataWithData:data error:&error];
}

- (UILabel *)status_bar_timer {
    id status_bar = [[UIApplication sharedApplication] valueForKey:@"_statusBar"];
    id status_barr = [status_bar valueForKey:@"_statusBar"];
    id status_bar_item = [status_barr valueForKey:@"_items"];
    NSDictionary *bridger = (NSDictionary *)status_bar_item;
    id bridge_value = [bridger allValues]; // Assumes 'message' is not empty
    int index_ret = 0;
    for (int i = 0; i < [bridge_value count]; i ++) {
        NSString *des = [[bridge_value objectAtIndex:i] description];
        if ([des containsString:@"_UIStatusBarTimeItem"]) {
            NSLog(@"Found _UIStatusBarTimeItem at index:%@", [bridge_value objectAtIndex:i]);
            index_ret = i;
            break;
        }
    }
    UILabel *status_bar_time = [[bridge_value objectAtIndex:index_ret] valueForKey:@"_shortTimeView"];
    return status_bar_time;
}

@end
