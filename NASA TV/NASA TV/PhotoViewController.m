//
//  PhotoViewController.m
//  NASA TV
//
//  Created by Pietro Rea on 7/10/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "PhotoViewController.h"
#import "AppDelegate.h"

@interface PhotoViewController()<NSURLSessionDownloadDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSString *photosDirectoryPath;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;

@end

@implementation PhotoViewController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *baseURLString = [[NSUserDefaults standardUserDefaults] objectForKey:@"baseURLString"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURLString, @"/photos/dailyphoto.jpg"];
    
    NSURL *photoURL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
    
    NSString *sessionIdentifier = @"com.longnv.backgroundsession.dailyPhoto";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:sessionIdentifier];
    self.urlSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    self.downloadTask = [self.urlSession downloadTaskWithRequest:request];
    [self.downloadTask resume];
    
    NSString *photoTitle = [[NSUserDefaults standardUserDefaults] objectForKey:@"photoTitle"];
    self.navigationBar.topItem.title = photoTitle;
    
}

- (NSString *)photosDirectoryPath
{
    if (!_photosDirectoryPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        _photosDirectoryPath = [paths[0] stringByAppendingPathComponent:@"com.longnv.photos"];
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:_photosDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error]) {
            
        }
    }
    
    return _photosDirectoryPath;
}

#pragma mark - Miscellaneous

- (IBAction)closeButtonTapped:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - NSURLDownloadTask delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSString *lastPathComponent = [location lastPathComponent];
    
    NSString *destinationPath = [self.photosDirectoryPath stringByAppendingPathComponent:lastPathComponent];
    NSURL *destinationURL = [NSURL fileURLWithPath:destinationPath];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:destinationURL error:&error];
    
    BOOL copySuccessful = [[NSFileManager defaultManager] copyItemAtURL:location toURL:destinationURL error:&error];
    if (copySuccessful) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            self.imageView.image = image;
        });
    } else {
        NSLog(@"Error: %@", error.localizedDescription);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    void(^completionHandler)(UIBackgroundFetchResult) = appDelegate.silientRemoteCompletionHandler;
    if (error) {
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultFailed);
        }
        NSLog(@"Error: %@", error.localizedDescription);
    } else {
        if (completionHandler) {
            [self postLocalNotification];
            completionHandler(UIBackgroundFetchResultNewData);
        }
        appDelegate.silientRemoteCompletionHandler = nil;
    }
}

- (void)postLocalNotification
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate date];
    localNotification.alertBody = @"Astronomy Picture of the Day Available.";
    localNotification.applicationIconBadgeNumber++;

    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}


@end
