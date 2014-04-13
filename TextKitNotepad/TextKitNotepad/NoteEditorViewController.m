//
//  CENoteEditorControllerViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "Note.h"
#import "TimeIndicatorView.h"
#import "SyntaxHighLightTextStorage.h"
#import "WebViewController.h"

@interface NoteEditorViewController () <UITextViewDelegate>

//@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NoteEditorViewController
{
    TimeIndicatorView *_timeView;
    SyntaxHighLightTextStorage *_textStorage;
    UITextView *_textView;
    CGRect _textViewFrame;
    CGRect _keyboardFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTextView];
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    _timeView = [[TimeIndicatorView alloc] init:self.note.timestamp];
    [self.view addSubview:_timeView];
    _textViewFrame = self.view.bounds;
    _textView.delegate = self;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toogleTextView)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidLayoutSubviews
{
    [self updateTimeIndicatorFrame];
    _textView.frame = self.view.bounds;
    _textView.frame = _textViewFrame;
}

- (void)createTextView
{
    // Create the text storage that backs the editor
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.note.contents attributes:attrs];
    _textStorage = [SyntaxHighLightTextStorage new];
    [_textStorage appendAttributedString:attrString];
    
    CGRect newTextViewRect = self.view.bounds;
    
    // Create the layout manager
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    
    
    // Create the text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width, FLT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];
    
    // Create UITextView
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect textContainer:container];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}

- (void)updateTimeIndicatorFrame
{
    [_timeView updateSize];
    _timeView.frame = CGRectOffset(_timeView.frame, self.view.frame.size.width - _timeView.frame.size.width, 0.0);
    UIBezierPath *exclusionPath = [_timeView curvePathWithOrigin:_timeView.center];
    _textView.textContainer.exclusionPaths = @[exclusionPath];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // copy the updated note text to the underlying model.
    self.note.contents = textView.text;
    _textViewFrame = self.view.bounds;
    _textView.frame = _textViewFrame;
}

- (void)preferredContentSizeChanged:(NSNotification *)n
{
    [_textStorage update];
    [self updateTimeIndicatorFrame];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textViewFrame = self.view.bounds;
    _textViewFrame.size.height -= 162;
    _textView.frame = _textViewFrame;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self performSegueWithIdentifier:@"OpenWeb" sender:URL];
    return NO;
}

- (void)toogleTextView
{
    _textView.editable = !_textView.editable;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OpenWeb"]) {
        // if the cell selected segue was fired, edit the selected note
        WebViewController *wvc = (WebViewController *)segue.destinationViewController;
        wvc.url = (NSURL *)sender;
    }
}



@end
