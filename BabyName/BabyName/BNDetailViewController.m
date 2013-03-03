//
//  BNDetailViewController.m
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "BNDetailViewController.h"
#import "BNName.h"

@implementation BNDetailViewController
@synthesize BNName, nameTextLabel, genderLabel, derivationLabel, notesLabel, iconImageView;

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
    // Do any additional setup after loading the view from its nib.
    [self.nameTextLabel setText:self.BNName.nameText];
    [self.genderLabel setText:self.BNName.gender];
    [self.derivationLabel setText:self.BNName.derivation];
    [self.notesLabel setText:self.BNName.notes];
    UIImage *image = [UIImage imageNamed:self.BNName.iconName];
    [self.iconImageView setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
