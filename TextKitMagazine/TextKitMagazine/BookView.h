//
//  BookView.h
//  TextKitMagazine
//
//  Created by Long Vinh Nguyen on 4/13/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookView;

@protocol BookViewDelegate <NSObject>

- (void)bookView:(BookView *)bookView didHighLightWord:(NSString *)word inRect:(CGRect)rect;

@end

@interface BookView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, copy) NSAttributedString *bookMarkup;
@property (nonatomic, weak) id<BookViewDelegate>bookViewDelegate;

- (void)buildFrames;
- (void)navigateToCharacterLocation:(NSUInteger)location;
- (void)removeWordHighLight;

@end
