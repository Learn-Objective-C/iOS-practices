//
//  AFTableViewController.m
//  AFNetworkingTest
//
//  Created by VisiKard MacBook Pro on 5/2/13.
//  Copyright (c) 2013 VisiKard MacBook Pro. All rights reserved.
//

#import "AFTableViewController.h"

#define BASE_URL1 @"http://free.worldweatheronline.com/feed/"
#define BASE_URL2 @"https://dl.dropboxusercontent.com/sh"
#define BASE_URL3 @"https://dev1.visikard.com:8443/vk4v2/"
#define BASE_URL4 @"http://localhost:8888/"
#define _AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_

@interface AFTableViewController ()

@end

@implementation AFTableViewController
{
    AFHTTPClient *client;
    double downloadPercentage;
    double uploadPercentage;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"View Did Load");
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    client.stringEncoding = NSUTF8StringEncoding;
//    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    [client setDefaultHeader:@"Accept" value:@"application/vnd.apple.pkpass"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%d",10] forKey:@"num_of_days"];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f",10.7917914,106.655261] forKey:@"q"];
    [parameters setObject:@"json" forKey:@"format"];
    [parameters setObject:@"jrzm7tjeuc93zb3wqfzp42gv" forKey:@"key"];
    
//    NSString *path = @"weather.ashx";
//    NSString *path = @"0utra8fysg1bow8/5i9EXG_0G5/bayroast.pkpass";
    NSString *path = @"https://dev1.visikard.com:8443/vk4v2/backkard/media/save";
//    NSString *path = @"upload.php";
    NSURLRequest *request1 = [client requestWithMethod:@"GET" path:path parameters:parameters];
    NSURLRequest *request2 = [client requestWithMethod:@"GET" path:path parameters:parameters];
    NSURLRequest *request3 = [client requestWithMethod:@"GET" path:path parameters:parameters];
    
    NSArray *requests = @[request1,request2,request3];
    

    
    
    // 1 - Single request
//    NSLog(@"***********************Single Request*************************");
//    [client2 getPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//    }];
    NSLog(@"***********************End*************************");
    
    // 2 - Multiple requests
//    NSLog(@"****************Starting Mutitple Requests ...***************");
//    [client2 enqueueBatchOfHTTPRequestOperationsWithRequests:requests progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations){
//        NSLog(@"Number of finished operations:%d/%d",numberOfFinishedOperations,totalNumberOfOperations);
//    }completionBlock:^(NSArray *operations){
//        for (AFJSONRequestOperation *operation in operations) {
//            NSDictionary *info = [operation responseJSON];
//            NSLog(@"%@",info);
//        }
//    }];
    NSLog(@"***********************End*******************************");
    
    // 3 - HTTPS
    NSLog(@"****************HTTPS***************");
//    parameters = [NSMutableDictionary new];
//    [parameters setObject:@"AAFkd8Ce0luWbepJvIVGBfZum-xQSrLz336xz-aXUSARpQ" forKey:@"token_hash"];
//    [parameters setObject:@"1" forKey:@"dl"];
//    [client postPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Get passbook from server");
//        NSError *error = nil;
//        PKPass *pass = [[PKPass alloc] initWithData:[operation responseData] error:&error];
//        PKAddPassesViewController *pvc = [[PKAddPassesViewController alloc] initWithPass:pass];
//        [pvc setModalTransitionStyle:UIModalTransitionStylePartialCurl];
//        [self presentViewController:pvc animated:YES completion:nil];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
    NSLog(@"***********************End*******************************");
    
    // 4 - progress
//    NSString *savePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *passPath = [savePath stringByAppendingPathComponent:@"test.pkpass"];
//    
//    NSURLRequest *request = [client requestWithMethod:@"POST" path:path parameters:parameters];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:passPath append:YES]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"bytesRead: %d", bytesRead);
//        NSLog(@"totalBytesRead: %llu", totalBytesRead);
//        NSLog(@"totalBytesExpectedToRead: %llu", totalBytesExpectedToRead);
//        downloadPercentage = (double)totalBytesRead/(double)totalBytesExpectedToRead;
//        NSLog(@"Progress bar: %.2f",(double)totalBytesRead/(double)totalBytesExpectedToRead);
//        [self.tableView reloadData];
//    }];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Done");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",[error localizedDescription]);
//    }];
//    [client enqueueHTTPRequestOperation:operation];
    
    // 5 - Upload photos
    UIImage *image = [UIImage imageNamed:@"test.png"];
    NSData *data;
    if (image) {
        NSLog(@"Image JPEG");
        data = UIImageJPEGRepresentation(image, 1.0);
    }
//    NSArray *keyArray = [NSArray arrayWithObjects:@"userId",@"kardId",@"mediaName",@"fileName",@"mediaDescription",@"mediaType",@"postType",@"rotate",nil];
//
//    NSArray *valueArray = [NSArray arrayWithObjects:
//                           @"20"
//                           ,@"2178"
//                           ,@" "
//                           ,@"test.png"
//                           ,@"Gfh"
//                           ,@"3"
//                           ,@"0"
//                           ,@"0"
//                           ,nil];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"20" forKey:@"userId"];
    [dictionary setObject:@"2178" forKey:@"kardId"];
    [dictionary setObject:@"name" forKey:@"mediaName"];
    [dictionary setObject:@"test.png" forKey:@"fileName"];
    [dictionary setObject:@"Long upload" forKey:@"mediaDescription"];
    [dictionary setObject:@"3" forKey:@"mediaType"];
    [dictionary setObject:@"0" forKey:@"postType"];
    [dictionary setObject:@"0" forKey:@"rotate"];
    
    NSArray *keys = [NSArray arrayWithObjects:@"userId",@"kardId",@"mediaName",@"fileName",@"mediaDescription",@"mediaType",@"postType",@"rotate",@"media",nil];
    NSArray *values = [NSArray arrayWithObjects:@"20",@"2178",@"Villager",@"test.png",@"Long upload",@"3",@"0",@"0",data, nil];
    
    NSMutableURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (values) {
            for (int i = 0; i < values.count; i++) {
                id object = [values objectAtIndex:i];
                if ([object isKindOfClass:[NSData class]]) {                    
                    [formData appendPartWithFileData:object name:@"media" fileName:@"uploadPhoto.jpg" mimeType:@"image/jpeg"];
                }
                else {
                    [formData appendPartWithFormData:[object dataUsingEncoding:client.stringEncoding] name:[keys objectAtIndex:i]];
                }
            }
        }
//

        NSLog(@"Done %@",formData);
    }];
    
    AFHTTPRequestOperation *uploadPhoto = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [uploadPhoto setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        uploadPercentage = (double)totalBytesWritten/(double)totalBytesExpectedToWrite;
        [self.tableView reloadData];
    }];
    
    [uploadPhoto setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"URL: %@", [operation request].URL);
        NSLog(@"Upload successfully: %@",[operation responseString]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
    [client enqueueHTTPRequestOperation:uploadPhoto];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"Downloading: %.2f",downloadPercentage];
    } else cell.textLabel.text = [NSString stringWithFormat:@"Uploading: %.2f",uploadPercentage];

    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - AFTableViewController actions
- (IBAction)stopDownload:(id)sender
{
    for (AFHTTPRequestOperation *operation in client.operationQueue.operations) {
        [operation pause];
    }
}

- (IBAction)resumeDownload:(id)sender
{
    for (AFHTTPRequestOperation *operation in client.operationQueue.operations) {
        [operation.userInfo objectForKey:[AFTableViewController class]];
        [operation resume];
    }
}

@end
