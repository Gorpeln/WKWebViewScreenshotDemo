//
//  ViewController.m
//  WKWebViewScreenshotDemo
//
//  Created by chen on 2016/10/31.
//  Copyright © 2016年 Gorpeln. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebView+GPViewCapture.h"

#define KCapUrl @"https://github.com/Gorpeln?tab=repositories"


@interface ViewController ()<WKNavigationDelegate>
{
    WKWebView * wkWebView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * url = KCapUrl;
    
    wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    wkWebView.navigationDelegate = self;
    
    NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [wkWebView loadRequest:re];
    
    [self.view addSubview:wkWebView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(captureView:)];
    
    
}
-(void)captureView:(UIBarButtonItem*)item
{
    [wkWebView GPContentScrollCaptureCompletionHandler:^(UIImage *capturedImage) {
        [self saveImageToPhotos: capturedImage];
        
    }];
    
}

#pragma mark - 保存截图到相册

- (void)saveImageToPhotos:(UIImage*)savedImage
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    });
    
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL)
    {
        msg = @"保存图片失败" ;
    }else
    {
        msg = @"保存图片成功" ;
    }
    
    NSLog(@"%@",msg);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

