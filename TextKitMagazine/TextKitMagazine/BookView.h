//
//  BookView.h
//  TextKitMagazine
//
//  Created by Long Vinh Nguyen on 4/13/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, copy) NSAttributedString *bookMarkup;

- (void)buildFrames;
- (void)navigateToCharacterLocation:(NSUInteger)location;

@end
