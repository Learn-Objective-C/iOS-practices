//
//  MCSettingsViewController.m
//  MCDemo
//
//  Created by LongNV on 7/11/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "MCSettingsViewController.h"
#import "MCUserDataManager.h"
#import "AppDelegate.h"

@interface MCSettingsViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imvAvatar;
@property (nonatomic, weak) IBOutlet UITextField *tfName;

@end

@implementation MCSettingsViewController
{
    UIImagePickerController *_imagePicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.title = @"Settings";
    self.imvAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar:)];
    [self.imvAvatar addGestureRecognizer:tapGesture];
    self.tfName.text = [MCUserDataManager shared].userName;
    self.imvAvatar.image = [MCUserDataManager shared].avatarImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeAvatar:(UIGestureRecognizer *)gesture
{
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

- (IBAction)doneButtonTapped:(id)sender
{
    [MCUserDataManager shared].avatarImage = self.imvAvatar.image;
    if (self.tfName.text.length > 0) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        if (!([[MCUserDataManager shared].userName isEqualToString:self.tfName.text] && appDelegate.mcManager.session.myPeerID)) {
            [MCUserDataManager shared].userName = self.tfName.text;
            // Tear down current connection and start again
            [appDelegate.mcManager tearDown];
#if TARGET_IPHONE_SIMULATOR
            [appDelegate.mcManager setupPeerAndSessionWithDisplayName:@"SIMULATOR"];
#else
            [appDelegate.mcManager setupPeerAndSessionWithDisplayName:self.tfName.text];
#endif
            [appDelegate.mcManager advertiseSelf:YES];
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your name." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    }

}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imvAvatar.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}




@end
