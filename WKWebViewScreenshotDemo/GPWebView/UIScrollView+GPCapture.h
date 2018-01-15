//
//  UIScrollView+GPCapture.h
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (GPCapture)

- (void)GPContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

- (void)GPRenderImageViewCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

- (void)GPContentScrollCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler;

@end
