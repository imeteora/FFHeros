//
//  ffWebViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffWebViewController.h"
#import <WebKit/WebKit.h>
#import "ffToasteView.h"

@interface ffWebViewController () <WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ffWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:@"loading" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadRequest:self.url];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"loading"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - private helpers
- (void)loadRequest:(NSString * _Nonnull)url {
    NSURL *urlForLoading = [NSURL URLWithString:url];
    if (urlForLoading) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlForLoading cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:30];
        [self.webView loadRequest:request];
    }
}

#pragma mark - ffRouterableProtocol
- (BOOL)setUpWith:(NSDictionary<NSString *,NSString *> *)param userInfo:(id)userInfo {
    if ([param.allKeys containsObject:@"url"]) {
        self.url = param[@"url"];
    }
    return YES;
}

#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        if (self.webView.loading) {
            [ffToasteView showLoadingInView:self.view];
        } else {
            [ffToasteView stopLoading];
        }
    }
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
