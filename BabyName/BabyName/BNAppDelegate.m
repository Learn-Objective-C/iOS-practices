//
//  BNAppDelegate.m
//  BabyName
//
//  Created by Long Vinh Nguyen on 3/2/13.
//  Copyright (c) 2013 home.vn. All rights reserved.
//

#import "BNAppDelegate.h"
#import "BNName.h"


#import "BNViewController.h"

@implementation BNAppDelegate
@synthesize tableData;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUInteger numberOfNames = 25;
    self.tableData = [[NSMutableArray alloc] initWithCapacity:numberOfNames];
    
    // Create a temporary array of tableData
    for (NSUInteger i = 0; i < numberOfNames; i++) {
        // Create a new name with nonsense data
        BNName *tempName = [self createNameWithNonsenseDataWithIndex:i];
        
        // Add it to the temporary array
        [self.tableData addObject:tempName];
    }
    
    BNViewController *bnViewController = [[BNViewController alloc] initWithNibName:@"BNViewController" bundle:nil];
    
    // Pass the array of dummy names into the view controller
    [bnViewController setTableData:tableData];
    
    // Create an instance of UINavigationController called navController
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:bnViewController];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BNName *)createNameWithNonsenseDataWithIndex:(int)index
{
    BNName *randomDataName = [[BNName alloc] init];
    
    NSArray *namesArray = [[NSArray alloc] initWithObjects:@"Abigail", @"Ada", @"Adelaide", @"Abel", @"Algernon", @"Anatole", @"Barbara", @"Bertha", @"Brunhilda", @"Barton", @"Ben", @"Boris", @"Calista", @"Cassandra", @"Constance", @"Caspar", @"Clive",@"Corey", @"Danica", @"Dido", @"Dora", @"Darnell", @"Dexter", @"Dunstan", @"Duncan", nil];
    
    NSArray *genderArray = [[NSArray alloc] initWithObjects:@"Boy", @"Girl", @"Unisex", nil];
    
    NSArray *notesArray = [[NSArray alloc] initWithObjects:@"'Properous and joyful'. A popular name in Victorian times.", @"'Bright fair one'. A term of endearment used by the Irish.",@"'Son of the furrows; ploughman' One of the twelve apostles", @"One who is graceful and charming", @"'Spear'. A warrior who wielded her spear to the deriment of her enemies", nil];
    
    NSArray *derivationArray = [[NSArray alloc] initWithObjects:@"Celtic", @"Germanic", @"Old English", @"Latin", @"Geek",  nil];
    
    NSArray *iconArray = [[NSArray alloc] initWithObjects:@"icon1.png", @"icon2.png", @"icon3.png", @"icon4.png", @"icon5.png", nil];
    
    int genderCount = [genderArray count];
    int notesCount = [notesArray count];
    int iconCount = [iconArray count];
    int derivationCount = [derivationArray count];
    
    [randomDataName setNameText:[namesArray objectAtIndex:index]];
    [randomDataName setGender:[genderArray objectAtIndex:arc4random() % genderCount]];
    [randomDataName setNotes:[notesArray objectAtIndex:arc4random() % notesCount]];
    [randomDataName setIconName:[iconArray objectAtIndex:arc4random() % iconCount]];
    [randomDataName setDerivation:[derivationArray objectAtIndex:arc4random() % derivationCount]];
    
    return randomDataName;
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Hanle open URL");
    if (url!= nil) {
        NSLog(@"URL: %@",[url absoluteString]);
        NSLog(@"URL: %@",[url absoluteURL]);

    } return NO;
    
    return YES;
}









@end
