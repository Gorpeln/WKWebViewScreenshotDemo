//
//  WKWebView+GPViewCapture.h
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (GPViewCapture)

- (void)GPContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

- (void)GPContentScrollCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

@end
