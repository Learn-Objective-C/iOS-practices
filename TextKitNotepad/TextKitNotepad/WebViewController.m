//
//  WebViewController.m
//  TextKitNotepad
//
//  Created by Long Vinh Nguyen on 4/12/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        _url= url;
        if ([url isKindOfClass:[NSString class]]) {
            _url = [NSURL URLWithString:(NSString *)url];
        }
    }
    
    return self;
}

- (void)setUrl:(NSURL *)url
{
    if ([url isKindOfClass:[NSString class]]) {
        _url = [NSURL URLWithString:(NSString *)url];
    } else {
        _url = url;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebView:)];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:_url]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshWebView:(id)sender
{
    [_webView reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finish load webpage");
}

@end
