//
//  ffWebViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffWebViewController.h"
#import <WebKit/WebKit.h>

@interface ffWebViewController () <WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ffWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];

    NSURL *urlForLoading = [NSURL URLWithString:self.url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlForLoading cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30];
    [self.webView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - lazy load
- (WKWebView *)webView {
    if (NOT _webView) {
        WKWebViewConfiguration *cfg = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:cfg];
        _webView.UIDelegate = self;
    }
    return _webView;
}

@end
