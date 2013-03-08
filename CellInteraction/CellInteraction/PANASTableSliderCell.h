//
//  PANASTableSliderCell.h
//  CellInteraction
//
//  Created by Long Vinh Nguyen on 3/7/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PANASTableSliderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *sliderLabel;

@end
