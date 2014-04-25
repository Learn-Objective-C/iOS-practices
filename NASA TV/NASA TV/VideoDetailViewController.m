//
//  VideoDetailViewController.m
//  NASA TV
//
//  Created by Pietro Rea on 7/7/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "AppDelegate.h"
#import "VideoDetailViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>

@interface VideoDetailViewController()<NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSURL* videoURL;
@property (strong, nonatomic) MPMoviePlayerController* moviePlayerViewController;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *downloadButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSURLSession* urlSession;
@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;
@property (strong, nonatomic) NSString* videosDirectoryPath;


@end

@implementation VideoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackgroundTransfer:) name:@"BackgroundTransferNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.progressView.progress = 0.0f;
    self.progressView.hidden = YES;
    
    NSURL *playbackVideoURL;
    BOOL videoAvailableOffline = [self.video.availableOffline boolValue];
    if (videoAvailableOffline) {
        self.downloadButton.enabled = NO;
        self.downloadButton.title = @"Downloaded";
        
        // Play local content file if availabel
        NSString *fileName = self.videoURL.lastPathComponent;
        NSString *videoPath = [self.videosDirectoryPath stringByAppendingPathComponent:fileName];
        playbackVideoURL = [NSURL fileURLWithPath:videoPath];
    } else {
        self.downloadButton.enabled = YES;
        playbackVideoURL = self.videoURL;
    }
    
    
    self.moviePlayerViewController = [[MPMoviePlayerController alloc] initWithContentURL:playbackVideoURL];
    [self.moviePlayerViewController prepareToPlay];
    [self.moviePlayerViewController setControlStyle:MPMovieControlStyleDefault];
    [self.moviePlayerViewController.view setFrame:self.view.bounds];
    [self.view addSubview:self.moviePlayerViewController.view];
    [self.moviePlayerViewController play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.moviePlayerViewController stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getters and setters

- (void)setVideo:(Video *)video {
    
    if (_video != video) {
        _video = video;
        
        NSString* baseURLString = [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURLString"];
        NSString* urlString = [NSString stringWithFormat:@"%@%@", baseURLString, self.video.url];
        self.videoURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"video url %@", urlString);
    }
}

- (NSString *)videosDirectoryPath
{
    if (!_videosDirectoryPath) {
        NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        _videosDirectoryPath = [documentDirectory stringByAppendingPathComponent:@"com.longnv.videos"];
        
        NSError *error;
        if ([[NSFileManager defaultManager] createDirectoryAtPath:_videosDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            if (error) {
                NSLog(@"Error when creating video directory %@", error.localizedDescription);
            }
        }
    }
    
    return _videosDirectoryPath;
}

#pragma mark - Download Video
- (IBAction)downloadButtonTapped:(id)sender
{
    if ([self.video.availableOffline boolValue]) {
        return;
    }
    self.downloadButton.enabled = NO;
    self.progressView.hidden = NO;
    
    if (!self.urlSession) {
        NSString *sessionID = [NSString stringWithFormat:@"com.longnv.backgroundSession.%@", self.video.videoID];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:sessionID];
        self.urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.videoURL];
    self.downloadTask = [self.urlSession downloadTaskWithRequest:request];
    [self.downloadTask resume];
}

#pragma mark - Background handler
- (void)handleBackgroundTransfer:(NSNotification *)notification
{
    NSString *sessionIdentifier = notification.userInfo[@"sessionIdentifier"];
    NSArray *components = [sessionIdentifier componentsSeparatedByString:@"."];
    NSString *videoID = [components lastObject];
    
    if (self.video.videoID.integerValue == [videoID integerValue]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadButton.title = @"Downloaded";
            self.progressView.hidden = YES;
            
            void (^completionHandler)() = notification.userInfo[@"completionHandler"];
            if (completionHandler) {
                completionHandler();
            }
        });
    }
}

#pragma mark - NSURLSessionDownloadTask methods
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = (double)totalBytesWritten / totalBytesExpectedToWrite;
    });
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *lastPathComponent = [downloadTask.originalRequest.URL lastPathComponent];
    
    NSString *destinationPath = [self.videosDirectoryPath stringByAppendingPathComponent:lastPathComponent];
    NSURL *fileURL = [NSURL fileURLWithPath:destinationPath];
    NSLog(@"fileURL %@ %@ %@ %@", fileURL, destinationPath, self.videosDirectoryPath, location);
    
    NSError *error;
    BOOL copySuccessful = [[NSFileManager defaultManager] copyItemAtURL:location toURL:fileURL error:&error];
    if (!copySuccessful) {
        return;
    }
    
    self.video.availableOffline = @(YES);
    NSManagedObjectContext *moc = self.video.managedObjectContext;
    [moc save:&error];
    
    if (error) {
        NSLog(@"CoreData error");
    }
    
    self.progressView.hidden = YES;
    self.downloadButton.title = @"Downloaded";
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error) {
        NSString *lastPathComponent = [task.originalRequest.URL lastPathComponent];
        NSString *filePath = [self.videosDirectoryPath stringByAppendingPathComponent:lastPathComponent];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{

}






@end
