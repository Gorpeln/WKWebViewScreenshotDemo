//
//  UIView+GPCapture.m
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import "UIView+GPCapture.h"
#import <objc/runtime.h>
#import <WebKit/WebKit.h>

@implementation UIView (GPCapture)

- (void)GPSetFrame:(CGRect)frame{
    // Do nothing, use for swizzling
}

- (BOOL)GPContainsWKWebView{
    if([self isKindOfClass:[WKWebView class]]){
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if([subView GPContainsWKWebView]){
            return YES;
        }
    }
    return NO;
}

- (void)GPCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler{
    
    CGRect bounds = self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, false,[UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, - self.frame.origin.x, - self.frame.origin.y);

    if([self GPContainsWKWebView]){
        [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
    }else{
        [self.layer renderInContext:context];
    }
    
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    
    completionHandler(capturedImage);
}

@end
