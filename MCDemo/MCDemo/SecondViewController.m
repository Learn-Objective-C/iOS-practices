//
//  SecondViewController.m
//  MCDemo
//
//  Created by Long Vinh Nguyen on 5/7/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"

@interface SecondViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSString *documentDirectory;
@property (nonatomic, strong) NSMutableArray *arrFiles;

- (void)copySampleFilesToDocDirIfNeeded;

@end

@implementation SecondViewController
{
    NSUInteger _selectedRow;
    NSString *_selectedFile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self copySampleFilesToDocDirIfNeeded];
    _arrFiles = [NSMutableArray arrayWithArray:[self getAllDocDirFiles]];
    [_tblFiles reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didStartReceivingResourceNotification:)
                                                 name:@"didStartReceivingResourceNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceivingProgressWithNotification:)
                                                 name:@"MCReceivingProgressNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishReceivingResourceWithNotification:)
                                                 name:@"didFinishReceivingResourceNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Send Files
- (void)didStartReceivingResourceNotification:(NSNotification *)notification
{
    [_arrFiles addObject:[notification userInfo]];
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)updateReceivingProgressWithNotification:(NSNotification *)notification
{
    NSProgress *progress = notification.userInfo[@"progress"];
    NSDictionary *dict = _arrFiles.lastObject;
    NSDictionary *updatedDict = @{@"resourceName": dict[@"resourceName"],
                                  @"peerID": dict[@"peerID"],
                                  @"progress": progress};
    
    [_arrFiles replaceObjectAtIndex:(_arrFiles.count -1) withObject:updatedDict];
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)didFinishReceivingResourceWithNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    NSURL *localURL = dict[@"localURL"];
    NSString *resourceName = dict[@"resourceName"];
    
    NSString *filePath = [_documentDirectory stringByAppendingPathComponent:resourceName];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtURL:localURL toURL:fileURL error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
    
    [_arrFiles removeAllObjects];
    _arrFiles = nil;
    _arrFiles = [NSMutableArray arrayWithArray:[self getAllDocDirFiles]];
    
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSArray *)getAllDocDirFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:_documentDirectory error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    
    return allFiles;
}


- (void)copySampleFilesToDocDirIfNeeded
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentDirectory = [NSString stringWithString:paths[0]];
    
    NSString *filePath1 = [_documentDirectory stringByAppendingPathComponent:@"sample_file1.txt"];
    NSString *filePath2 = [_documentDirectory stringByAppendingPathComponent:@"sample_file2.txt"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath1] || ![[NSFileManager defaultManager] fileExistsAtPath:filePath2]) {
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample_file1" ofType:@"txt"] toPath:filePath1 error:&error];
        
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
            return;
        }
        
        [fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"sample_file2" ofType:@"txt"] toPath:filePath2 error:&error];
        
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
            return;
        }
        
    }
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([[_arrFiles objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = _arrFiles[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"newFileCellIdentifier"];
        
        NSDictionary *dict = [_arrFiles objectAtIndex:indexPath.row];
        NSString *receivedFilename = [dict objectForKey:@"resourceName"];
        NSString *peerDisplayName = [[dict objectForKey:@"peerID"] displayName];
        NSProgress *progress = [dict objectForKey:@"progress"];
        
        [(UILabel *)[cell viewWithTag:100] setText:receivedFilename];
        [(UILabel *)[cell viewWithTag:200] setText:[NSString stringWithFormat:@"from %@", peerDisplayName]];
        [(UIProgressView *)[cell viewWithTag:300] setProgress:progress.fractionCompleted];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedFile = _arrFiles[indexPath.row];
    UIActionSheet *confirmSending = [[UIActionSheet alloc] initWithTitle:selectedFile delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (MCPeerID *peer in _appDelegate.mcManager.session.connectedPeers) {
        [confirmSending addButtonWithTitle:peer.displayName];
    }
    
    confirmSending.cancelButtonIndex = [confirmSending addButtonWithTitle:@"Cancel"];
    [confirmSending showInView:self.view];
    
    _selectedRow = indexPath.row;
    _selectedFile = _arrFiles[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_arrFiles objectAtIndex:indexPath.row] isKindOfClass:[NSString class]]) {
        return 60.0f;
    }
    return 80.0f;
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != _appDelegate.mcManager.session.connectedPeers.count) {
        NSString *filePath = [_documentDirectory stringByAppendingPathComponent:_selectedFile];
        NSString *modifiedName = [NSString stringWithFormat:@"%@_%@", _appDelegate.mcManager.peerID.displayName, _selectedFile];
        NSURL *resourceURL = [NSURL fileURLWithPath:filePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSProgress *progress = [_appDelegate.mcManager.session sendResourceAtURL:resourceURL withName:modifiedName toPeer:_appDelegate.mcManager.session.connectedPeers[buttonIndex] withCompletionHandler:^(NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error.localizedDescription);
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MCDemo" message:@"File was successfuly sent." delegate:self cancelButtonTitle:@"Great!" otherButtonTitles:nil];
                    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
                    [_arrFiles replaceObjectAtIndex:_selectedRow withObject:_selectedFile];
                    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                    
                }
            }];
            
            [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        });
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *sendingMessage = [NSString stringWithFormat:@"%@ - Sending %.f%%", _selectedFile, ((NSProgress *)object).fractionCompleted * 100];
    NSLog(@"%@", sendingMessage);
    [_arrFiles replaceObjectAtIndex:_selectedRow withObject:sendingMessage];
    [_tblFiles performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}




@end
