//
//  BookView.m
//  TextKitMagazine
//
//  Created by Long Vinh Nguyen on 4/13/14.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "BookView.h"

@implementation BookView
{
    NSLayoutManager *_layoutManager;
    NSRange _wordCharacterRange;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (NSArray *)textSubviews
{
    NSMutableArray *views = [NSMutableArray new];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            [views addObject:view];
        }
    }
    
    return views;
}

- (UITextView *)textViewForContainer:(NSTextContainer *)container
{
    for (UITextView *view in [self textSubviews]) {
        if (view.textContainer == container) {
            return view;
        }
    }
    return nil;
}
- (BOOL)shouldRenderView:(CGRect)viewFrame
{
    if (viewFrame.origin.x + viewFrame.size.width < self.contentOffset.x - self.bounds.size.width) {
        return NO;
    }
    if (viewFrame.origin.x > self.contentOffset.x + self.bounds.size.width * 2) {
        return NO;
    }
    
    return YES;
}

- (void)buildViewsForCurrentOffset
{
    for (int index = 0; index < _layoutManager.textContainers.count; index++) {
        NSTextContainer *container = _layoutManager.textContainers[index];
        UITextView *textView = [self textViewForContainer:container];
        CGRect textViewFrame = [self frameForViewAtIndex:index];
        
        if ([self shouldRenderView:textViewFrame]) {
            if (!textView) {
                NSLog(@"Adding view at index %u", index);
                textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:container];
                [self addSubview:textView];
            }
        } else {
            if (textView) {
                NSLog(@"Deleting view at index %u", index);
                [textView removeFromSuperview];
            }
        }
    }
}

- (void)buildFrames
{
    // create the text storate
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.bookMarkup];
    
    _layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:_layoutManager];
    
    // build the frames
    NSRange range = NSMakeRange(0, 0);
    NSUInteger containerIndex = 0;
    while (NSMaxRange(range) < _layoutManager.numberOfGlyphs) {
        CGRect textViewRect = [self frameForViewAtIndex:containerIndex];
        CGSize containerSize = CGSizeMake(textViewRect.size.width, textViewRect.size.height - 16.0);
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:containerSize];
        [_layoutManager addTextContainer:textContainer];
        
        [self buildViewsForCurrentOffset];
        range = [_layoutManager glyphRangeForTextContainer:textContainer];
        containerIndex ++;
    }
    
    self.contentSize = CGSizeMake((self.bounds.size.width / 2) * (CGFloat)containerIndex, self.bounds.size.height);
    self.pagingEnabled = YES;
}

- (CGRect)frameForViewAtIndex:(NSUInteger)containerIndex
{
    CGRect textViewFrame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);
    textViewFrame = CGRectInset(textViewFrame, 10.0, 20.0);
    textViewFrame = CGRectOffset(textViewFrame, self.bounds.size.width / 2 * (CGFloat)containerIndex, 0);
    return textViewFrame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self buildViewsForCurrentOffset];
}

- (void)navigateToCharacterLocation:(NSUInteger)location
{
    CGFloat offset = 0.0f;
    for (NSTextContainer *container in _layoutManager.textContainers) {
        NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:container];
        NSRange characterRange = [_layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
        if (location >= characterRange.location && location < NSMaxRange(characterRange)) {
            self.contentOffset = CGPointMake(offset, 0);
            [self buildFrames];
            return;
        }
        offset += self.bounds.size.width / 2;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    NSTextStorage *textStorage = _layoutManager.textStorage;
    
    CGPoint tappedPoint = [gesture locationInView:self];
    
    UITextView *tappedTextView = nil;
    for (UITextView *textView in [self textSubviews]) {
        if (CGRectContainsPoint(textView.frame, tappedPoint)) {
            tappedTextView = textView;
        }
    }
    if (!tappedTextView) {
        return;
    }
    
    //
    CGPoint subViewLocation = [gesture locationInView:tappedTextView];
    subViewLocation.y -= 8.0f;
    NSUInteger glyphIndex = [_layoutManager glyphIndexForPoint:subViewLocation inTextContainer:tappedTextView.textContainer];
    NSUInteger characterIndex = [_layoutManager characterIndexForGlyphAtIndex:glyphIndex];
 
    if (![[NSCharacterSet letterCharacterSet] characterIsMember:[textStorage.string characterAtIndex:characterIndex]]) {
        return;
    }
    
    _wordCharacterRange = [self wordContainsCharacter:characterIndex inString:textStorage.string];
    [textStorage addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:_wordCharacterRange];
}

- (NSRange)wordContainsCharacter:(NSUInteger)charIndex inString:(NSString *)string
{
    NSUInteger startLocation = charIndex;
    while (startLocation > 0 && [[NSCharacterSet letterCharacterSet] characterIsMember:[string characterAtIndex:startLocation - 1]]) {
        startLocation--;
    }
    
    NSUInteger endLocation = charIndex;
    while (endLocation < string.length && [[NSCharacterSet letterCharacterSet] characterIsMember:[string characterAtIndex:endLocation+1]]) {
        endLocation++;
    }
    
    return NSMakeRange(startLocation, endLocation-startLocation+1);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
