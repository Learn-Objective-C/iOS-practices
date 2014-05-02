//
//  SettingsViewController.m
//  ColloQR
//
//  Created by Long Vinh Nguyen on 5/2/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISlider *speedSlider;
@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;
@property (nonatomic, weak) IBOutlet UISlider *pitchSlider;

@end

@implementation SettingsViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float speed = [[NSUserDefaults standardUserDefaults] floatForKey:@"speed"];
    float volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"volume"];
    float pitch = [[NSUserDefaults standardUserDefaults] floatForKey:@"pitch"];
    
    _speedSlider.value = speed;
    _volumeSlider.value = volume;
    _pitchSlider.value = pitch;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setFloat:_speedSlider.value forKey:@"speed"];
    [[NSUserDefaults standardUserDefaults] setFloat:_volumeSlider.value forKey:@"volume"];
    [[NSUserDefaults standardUserDefaults] setFloat:_pitchSlider.value forKey:@"pitch"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
