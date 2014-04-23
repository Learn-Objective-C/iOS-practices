//
//  DownloadViewController.m
//  ByteClub
//
//  Created by Long Vinh Nguyen on 4/22/14.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

#import "DownloadViewController.h"
#import "Dropbox.h"

@interface DownloadViewController ()<NSURLSessionDownloadDelegate>

@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIImageView *photoView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation DownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPAdditionalHeaders = @{@"Authorization": [Dropbox apiAuthorizationHeader]};
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _titleLabel.text = [NSString stringWithFormat:@"Loading %@", [self.path lastPathComponent]];
    [self downloadPhoto];
}

- (void)dealloc
{
    [_session invalidateAndCancel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_downloadTask.state == NSURLSessionTaskStateRunning) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_downloadTask cancelByProducingResumeData:nil];
    }
}

- (void)downloadPhoto
{
    //
    NSURL *url = [Dropbox createPhotoDownloadURL:self.path];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _downloadTask = [_session downloadTaskWithURL:url];
    [self.downloadTask resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    if (location && downloadTask.state == NSURLSessionTaskStateRunning) {
        // load image from temp
        NSLog(@"location %@", location);
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoView.image = image;
            self.progressView.hidden = YES;
            _titleLabel.text = [NSString stringWithFormat:@"Download full size photo\n %@", self.path];
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSLog(@"Error %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

- (IBAction)cancel:(id)sender
{
    if (_downloadTask.state == (NSURLSessionTaskStateRunning | NSURLSessionTaskStateSuspended)) {
        NSLog(@"Cancel tapped");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [_downloadTask cancelByProducingResumeData:nil];
    }
}
//
- (IBAction)pause:(id)sender
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (_downloadTask.state == NSURLSessionTaskStateRunning) {
        [sender setTitle:@"Resume"];
        [_downloadTask cancelByProducingResumeData:^(NSData *data) {
            _resumeData = data;
        }];
    } else {
        [sender setTitle:@"Pause"];
        _downloadTask = [_session downloadTaskWithResumeData:_resumeData];
        [_downloadTask resume];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
