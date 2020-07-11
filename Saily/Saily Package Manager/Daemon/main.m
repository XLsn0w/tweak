//
//  main.m
//  Daemon
//
//  Created by Lakr Aream on 2019/4/19.
//  Copyright (c) 2019 Lakr233. All rights reserved.
//

// http://walfield.org/pub/people/neal/papers/hurd-misc/ipc-hello.c

@import Foundation;

#include <spawn.h>
#include <mach/mach.h>

// DONT USE MACH MSG BECAUSE I DONT WANT ANY KERNEL PANIC

NSString *saily_root    = @"";
NSString *saily_root_c  = @"/var/mobile/Containers/Data/Application/";
NSString *saily_root_p  = @"/Documents";

extern char **environ;
void run_cmd(char *cmd)
{
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL, NULL};
    int status;
    
    status = posix_spawn(&pid, "/bin/sh", NULL, NULL, argv, environ);
    if (status == 0) {
        if (waitpid(pid, &status, 0) == -1) {
            perror("waitpid");
        }
    }
}
static void fix_permission()
{
    NSString *com = [[NSString alloc] initWithFormat:@"chmod -R 0777 %@/daemon.call", saily_root];
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"chown -R 501:501 %@/daemon.call", saily_root];
    run_cmd([com UTF8String]);
}

NSString *read_data_with_url(NSString *url) { // making a GET request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block NSString *read_data;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
          NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSLog(@"Data received: %@", myString);
          read_data = myString;
          dispatch_semaphore_signal(sema);
      }] resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return read_data;
}

static void begin_root_path(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = @"";
}
static void add_A(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"A"];
}
static void add_B(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"B"];
}
static void add_C(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"C"];
}
static void add_D(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"D"];
}
static void add_E(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"E"];
}
static void add_F(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"F"];
}
static void add__(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"-"];
}
static void end_root_path(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [[saily_root_c stringByAppendingString:saily_root] stringByAppendingString:saily_root_p];
    NSLog(@"[*] Got root path at: %@", saily_root);
}

static void respring(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"Saily: respring");
    run_cmd("killall SpringBoard");
}
static void add_1(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"1"];
}
static void add_2(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"2"];
}
static void add_3(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"3"];
}
static void add_4(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"4"];
}
static void add_5(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"5"];
}
static void add_6(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"6"];
}
static void add_7(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"7"];
}
static void add_8(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"8"];
}
static void add_9(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"9"];
}
static void add_0(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    saily_root = [saily_root stringByAppendingString:@"0"];
}
static void run_command(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithContentsOfFile:[[NSString alloc]initWithFormat:@"%@/queue.submit/command", saily_root] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] End reading command with result %@", com);
    NSLog(@"[E] Run command notify is deprecated.");
    //    run_cmd([com UTF8String]);
}
static void list_dpkg(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"dpkg -l &> %@/daemon.call/dpkgl.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_install_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSLog(@"[*] APT is not working. use dpkg instead.");
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSArray *dirContents = [fm contentsOfDirectoryAtPath:[[NSString alloc] initWithFormat: @"%@/queue.submit/install.submit/", saily_root] error:nil];
//    NSString *cmd_files = @"";
//    for (int i = 0; i < [dirContents count]; i ++) {
//        cmd_files = [cmd_files stringByAppendingString:@" "];
//        cmd_files = [cmd_files stringByAppendingString:saily_root];
//        cmd_files = [cmd_files stringByAppendingString:@"/"];
//        cmd_files = [cmd_files stringByAppendingString: dirContents[i]];
//    }
//    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print install %@ &> %@/daemon.call/install.list", cmd_files, saily_root];
//    NSLog(@"[*] End reading command with result %@", com);
//    run_cmd([com UTF8String]);
//    fix_permission();
}
static void dpkg_install_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:[[NSString alloc] initWithFormat: @"%@/queue.submit/install.submit/", saily_root] error:nil];
    NSString *cmd_files = @"";
    for (int i = 0; i < [dirContents count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString:saily_root];
        cmd_files = [cmd_files stringByAppendingString:@"/queue.submit/install.submit/"];
        cmd_files = [cmd_files stringByAppendingString: dirContents[i]];
    }
    NSString *com = [[NSString alloc] initWithFormat:@"dpkg -i %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_remove_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // 获取文件地址
    NSString *path = [[NSString alloc] initWithFormat:@"%@/queue.submit/removes.submit", saily_root];
    NSLog(@"[*] Read from: %@", path);
    // 将文件用cp拷贝到我们能读取的地方
    NSString *cpcmd = [[NSString alloc] initWithFormat:@"cp %@/queue.submit/removes.submit /var/root/", saily_root];
    run_cmd([cpcmd UTF8String]);
    NSString *list_str = [NSString stringWithContentsOfFile:@"/var/root/removes.submit" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] Read with result: %@", list_str);
    NSArray *packages = [list_str componentsSeparatedByString:@"\n"];
    NSString *cmd_files = @"";
    for (int i = 0; i < [packages count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString: packages[i]];
        NSLog(@"[*] Add a package: %@", packages[i]);
    }
    NSLog(@"[*] Package Array STR: %@", cmd_files);
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print remove %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
        run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_remove_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    // 获取文件地址
    NSString *path = [[NSString alloc] initWithFormat:@"%@/queue.submit/removes.submit", saily_root];
    NSLog(@"[*] Read from: %@", path);
    // 将文件用cp拷贝到我们能读取的地方
    NSString *cpcmd = [[NSString alloc] initWithFormat:@"cp %@/queue.submit/removes.submit /var/root/", saily_root];
    run_cmd([cpcmd UTF8String]);
    NSString *list_str = [NSString stringWithContentsOfFile:@"/var/root/removes.submit" encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"[*] Read with result: %@", list_str);
    NSArray *packages = [list_str componentsSeparatedByString:@"\n"];
    NSString *cmd_files = @"";
    for (int i = 0; i < [packages count]; i ++) {
        cmd_files = [cmd_files stringByAppendingString:@" "];
        cmd_files = [cmd_files stringByAppendingString: packages[i]];
        NSLog(@"[*] Add a package: %@", packages[i]);
    }
    NSLog(@"[*] Package Array STR: %@", cmd_files);
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated -y remove %@ &>> %@/daemon.call/cmd.out", cmd_files, saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_autoremove_list(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated --just-print  auto-remove &>> %@/daemon.call/cmd.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}
static void apt_autoremove_perform(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString *com = [[NSString alloc] initWithFormat:@"apt-get --allow-unauthenticated -y auto-remove &>> %@/daemon.call/cmd.out", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    com = [[NSString alloc] initWithFormat:@"echo \"SAILY_DONE\" &>> %@/daemon.call/status", saily_root];
    NSLog(@"[*] End reading command with result %@", com);
    run_cmd([com UTF8String]);
    fix_permission();
}

int main(int argc, char **argv, char **envp)
{
    NSLog(@"Saily: rootdaemond is launched!");
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, respring, CFSTR("com.Saily.respring"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, begin_root_path, CFSTR("com.Saily.path_begin"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_A, CFSTR("com.Saily.path_A"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_B, CFSTR("com.Saily.path_B"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_C, CFSTR("com.Saily.path_C"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_D, CFSTR("com.Saily.path_D"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_E, CFSTR("com.Saily.path_E"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_F, CFSTR("com.Saily.path_F"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add__, CFSTR("com.Saily.path__"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_1, CFSTR("com.Saily.path_1"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_2, CFSTR("com.Saily.path_2"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_3, CFSTR("com.Saily.path_3"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_4, CFSTR("com.Saily.path_4"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_5, CFSTR("com.Saily.path_5"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_6, CFSTR("com.Saily.path_6"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_7, CFSTR("com.Saily.path_7"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_8, CFSTR("com.Saily.path_8"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_9, CFSTR("com.Saily.path_9"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, add_0, CFSTR("com.Saily.path_0"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, end_root_path, CFSTR("com.Saily.end_root_path"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, run_command, CFSTR("com.Saily.run_command"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, list_dpkg, CFSTR("com.Saily.list_dpkg"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, dpkg_install_perform, CFSTR("com.Saily.dpkg.install.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_remove_list, CFSTR("com.Saily.apt.remove.list"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_remove_perform, CFSTR("com.Saily.apt.remove.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_autoremove_list, CFSTR("com.Saily.apt.autoremove.list"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, apt_autoremove_perform, CFSTR("com.Saily.apt.autoremove.perform"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    
    CFRunLoopRun(); // keep it running in background
    return 0;
}
