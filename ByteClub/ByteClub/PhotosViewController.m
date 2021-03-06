//
//  PhotosViewController.m
//  ByteClub
//
//  Created by Charlie Fulton on 7/28/13.
//  Copyright (c) 2013 Razeware. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "Dropbox.h"
#import "DBFile.h"
#import "DownloadViewController.h"

@interface PhotosViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, NSURLSessionTaskDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIView *uploadView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@property (nonatomic, strong) NSArray *photoThumbnails;


@property (nonatomic, strong) NSURLSession *session;



@end

@implementation PhotosViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // 1
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        
        // 2
        [config setHTTPAdditionalHeaders:@{@"Authorization": [Dropbox apiAuthorizationHeader]}];
        
        // 3
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self refreshPhotos];
}

- (void)refreshPhotos
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSString *photoDir = [NSString stringWithFormat:@"https://api.dropbox.com/1/search/dropbox/%@/photos?query=.jpg", appFolder];
    NSURL *url = [NSURL URLWithString:photoDir];
    
    [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError;
                NSArray *fileJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSMutableArray *dbFiles = [NSMutableArray new];
                if (!jsonError) {
                    for (NSDictionary *fileMetadata in fileJSON) {
                        DBFile *file = [[DBFile alloc] initWithJSONData:fileMetadata];
                        [dbFiles addObject:file];
                    }
                }
                
                [dbFiles sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                
                self.photoThumbnails = dbFiles;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                
            }
        } else {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }] resume];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"downloadPhoto"]) {
        DownloadViewController *viewController = (DownloadViewController *)segue.destinationViewController;
        int selectedRow = [self.tableView indexPathForSelectedRow].row;
        DBFile *file = _photoThumbnails[selectedRow];
        viewController.path = file.path;
    }
}

#pragma mark - UITableViewDatasource and UITableViewDelegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_photoThumbnails count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DBFile *photo = _photoThumbnails[indexPath.row];
    
    if (!photo.thumbNail) {
        // only download if we are moving
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
        {
            if(photo.thumbExists) {
                NSString *urlString = [NSString stringWithFormat:@"https://api-content.dropbox.com/1/thumbnails/dropbox%@?size=xl",photo.path];
                NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:encodedUrl];
                NSLog(@"logging this url so no warning in starter project %@",url);
                
                // GO GET THUMBNAILS //
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        photo.thumbNail = image;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.thumbnailImage.image = photo.thumbNail;
                        });
                    } else {
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    });
                }] resume];
                
                
            }
        }
    }
    
    // Configure the cell...
    return cell;
}

- (IBAction)choosePhoto:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate methods
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:image];
}

// stop upload
- (IBAction)cancelUpload:(id)sender
{
    if (_uploadTask.state == NSURLSessionTaskStateRunning) {
        [_uploadTask cancel];
    }
}

- (void)uploadImage:(UIImage*)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.6);
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    config.HTTPAdditionalHeaders = @{@"Authorization": [Dropbox apiAuthorizationHeader]};
    
    NSURLSession *uploadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURL *url = [Dropbox createPhotoUploadURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"PUT"];
    
    self.uploadTask = [uploadSession uploadTaskWithRequest:request fromData:imageData];
    
    self.uploadView.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.uploadTask resume];
    
}

#pragma mark - NSURLSessionTask Delegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_progress setProgress:(double)totalBytesSent/totalBytesExpectedToSend animated:YES];
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    // 1
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        _uploadView.hidden = YES;
        [_progress setProgress:0.5];
    });
    
    if(!error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshPhotos];
        });
    } else {
        
    }
        
}


@end
