//
//  UIView+GPCapture.h
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GPCapture)

- (BOOL)GPContainsWKWebView;

- (void)GPCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

- (void)GPSetFrame:(CGRect)frame;

@end
