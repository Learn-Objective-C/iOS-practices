//
//  BNDetailViewController.h
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/3/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNName;

@interface BNDetailViewController : UIViewController

@property (nonatomic, retain) BNName *BNName;

@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *derivationLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
- (IBAction)clickOnButton:(id)sender;




@end
