//
//  ViewController.m
//  TouchIDTest
//
//  Created by shenzhenshihua on 2018/3/2.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        NSLog(@"不支持指纹识别");
        return;
    }
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"通過home鍵驗證已有手機指紋";
    context.localizedFallbackTitle = @"密码登录";
    if (@available(iOS 10.0, *)) {
        context.localizedCancelTitle = @"取消";
    }
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持指纹识别");
        /*
         LAPolicyDeviceOwnerAuthenticationWithBiometrics  > ios 8.0只能通过指纹验证才能成功
         LAPolicyDeviceOwnerAuthentication >ios 9.0 这种方式用户可以指纹验证或者输入密码。
         */
      [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
          if (success) {
              NSLog(@"验证成功");
          } else {
              switch (error.code) {
                  case LAErrorUserCancel:
                  {
                        NSLog(@"用户取消了验证");
                  }
                      break;
                  case LAErrorAuthenticationFailed:
                  {
                      NSLog(@"验证失败，指纹不对");
                  }
                      break;
                  case LAErrorUserFallback:
                  {
                      NSLog(@"身份验证被取消，因为用户点击了后退按钮(输入密码)。");
                  }
                      break;
                  case LAErrorTouchIDLockout:
                  {//如果多次输入错误的指纹，验证授权会被锁定，这个时候需要用户锁定手机屏幕后，再次进入手机输入密码才能解锁。
                     NSLog(@"多次输入touchid 失败");
                    }
                      break;
                      
                      
                  default:
                      break;
              }
          }
      }];
    } else {
        NSLog(@"%@",error);
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                    NSLog(@"用户未录入指纹");
            }
                break;
            case LAErrorTouchIDNotAvailable:
            {//LAPolicyDeviceOwnerAuthenticationWithBiometrics
                NSLog(@"设备不支持touchId");
            }
                break;
            case LAErrorPasscodeNotSet:
            {//LAPolicyDeviceOwnerAuthentication
                NSLog(@"设备不支持touchId");
            }
                break;
                
            default:
                break;
        }
    }
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
