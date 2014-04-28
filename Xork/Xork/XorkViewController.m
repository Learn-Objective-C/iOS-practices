//
//  ViewController.m
//  Xork
//
//  Created by Pietro Rea on 8/4/13.
//  Copyright (c) 2013 Pietro Rea. All rights reserved.
//

#import "XorkViewController.h"
#import "ConsoleTextView.h"
@import JavaScriptCore;

@interface XorkViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ConsoleTextView *outputTextView;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, strong) JSContext *context;

@end

@implementation XorkViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.inputTextField.delegate = self;
    [self.inputTextField becomeFirstResponder];
    
    UIFont *navBarFont = [UIFont fontWithName:@"Courier" size:23];
    NSDictionary *attributes = @{NSFontAttributeName : navBarFont};
    [self.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:@"xork" ofType:@"js"];
    NSString *scriptString = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:nil];
    self.context = [[JSContext alloc] init];
    [self.context evaluateScript:scriptString];
    
    // 2
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:dataPath];
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    //
    __weak XorkViewController *weakSelf = self;
    self.context[@"print"] = ^(NSString *text) {
        text = [NSString stringWithFormat:@"\n%@", text];
        [weakSelf.outputTextView setText:text concatenate:NO];
    };
    

    JSValue *dataValue = [JSValue valueWithObject:jsonArray inContext:self.context];
    JSValue *function = self.context[@"startGame"];
    [function callWithArguments:@[dataValue]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processUserInput:(NSString *)inputString
{
    JSValue *value = [JSValue valueWithObject:inputString inContext:self.context];
    JSValue *function = self.context[@"processUserInput"];
    [function callWithArguments:@[value]];
}

#pragma mark - UITextFielDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //
    NSString *inputString = textField.text;
    [inputString lowercaseString];
    
    if ([inputString isEqualToString:@"clear"]) {
        [self.outputTextView clear];
    } else {
        [self processUserInput:inputString];
    }
    
    self.inputTextField.text = @"";
    
    return YES;
}



@end
