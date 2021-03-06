//
//  AppDelegate.m
//  TextKitMagazine
//
//  Created by Colin Eberhardt on 02/07/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "AppDelegate.h"
#import "MarkdownParser.h"
#import "Chapter.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    // style the navigation bar
    UIColor* navColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    [[UINavigationBar appearance] setBarTintColor:navColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    // make the status bar white
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.chapters = [self locateChapters:self.bookMarkup.string];
    
    return YES;
}

- (NSArray *)locateChapters:(NSString *)markdown
{
    NSMutableArray *chapters = [NSMutableArray new];
    [markdown enumerateSubstringsInRange:NSMakeRange(0, markdown.length) options:0 usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        if (substring.length > 7 && [[substring substringToIndex:7] isEqualToString:@"CHAPTER"]) {
            Chapter *chapter = [Chapter new];
            chapter.title = [substring substringFromIndex:7];
            chapter.location = substringRange.location;
            [chapters addObject:chapter];
        }
    }];
    
    return chapters;
}

- (NSAttributedString *)bookMarkup
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alices_adventures" ofType:@"md"];
    MarkdownParser *markdownParser = [[MarkdownParser alloc] init];
    _bookMarkup = [markdownParser parseMarkdownFile:path];
    return _bookMarkup;
}

@end
