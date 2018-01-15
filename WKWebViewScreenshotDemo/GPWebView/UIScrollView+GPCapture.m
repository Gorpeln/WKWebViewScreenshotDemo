//
//  UIScrollView+GPCapture.m
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import "UIScrollView+GPCapture.h"
#import <objc/runtime.h>
#import "UIView+GPCapture.h"

@implementation UIScrollView (GPCapture)

- (void)GPContentCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler{
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [self.superview addSubview:snapShotView];
    
    CGRect bakFrame = self.frame;
    CGPoint bakOffset = self.contentOffset;
    UIView *bakSuperView = self.superview;
    NSInteger bakIndex = [self.superview.subviews indexOfObject:self];
    
    if(self.frame.size.height < self.contentSize.height){
        self.contentOffset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
    }
    
    [self GPRenderImageViewCompletionHandler:^(UIImage *capturedImage) {
        [self removeFromSuperview];
        self.frame = bakFrame;
        self.contentOffset = bakOffset;
        [bakSuperView insertSubview:self atIndex:bakIndex];
        
        [snapShotView removeFromSuperview];
        completionHandler(capturedImage);
    }];
}

- (void)GPRenderImageViewCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler{
    UIView *swTempRenderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    
    [self removeFromSuperview];
    
    self.contentOffset = CGPointZero;
    self.frame = swTempRenderView.bounds;
    
    Method method = class_getInstanceMethod(object_getClass(self), @selector(setFrame:));
    Method swizzledMethod = class_getInstanceMethod(object_getClass(self), @selector(GPSetFrame:));
    method_exchangeImplementations(method, swizzledMethod);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect bounds = self.bounds;
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, [UIScreen mainScreen].scale);
        
        if([self GPContainsWKWebView]){
            [self drawViewHierarchyInRect:bounds afterScreenUpdates:YES];
        }else{
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
        
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        method_exchangeImplementations(swizzledMethod, method);
        
        completionHandler(capturedImage);
    });

}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)GPContentScrollCaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler{
    UIView *snapShotView = [self snapshotViewAfterScreenUpdates:YES];
    snapShotView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
    [self.superview addSubview:snapShotView];
    
    CGPoint bakOffset = self.contentOffset;
    
    float page = floorf(self.contentSize.height/self.bounds.size.height);
    
    UIGraphicsBeginImageContextWithOptions(self.contentSize, false, [UIScreen mainScreen].scale);
    
    [self GPContentScrollPageDraw:0 maxIndex:(int)page drawCallback:^{
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Recover
        [self setContentOffset:bakOffset animated:false];
        [snapShotView removeFromSuperview];
        
        completionHandler(capturedImage);
    }];
    
}

- (void)GPContentScrollPageDraw:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)(void))drawCallback{
    [self setContentOffset:CGPointMake(0, (float)index * self.frame.size.height)];
    
    CGRect splitFrame = CGRectMake(0, (float)index * self.frame.size.height, self.bounds.size.width, self.bounds.size.height);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        
        if(index<maxIndex){
            [self GPContentScrollPageDraw:index + 1 maxIndex:maxIndex drawCallback:drawCallback];
        }else{
            drawCallback();
        }
    });
}


@end
