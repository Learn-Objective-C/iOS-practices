//
//  DirectionsListViewController.m
//  FlyMeThere
//
//  Created by Matt Galloway on 23/06/2013.
//  Copyright (c) 2013 Matt Galloway. All rights reserved.
//

#import "DirectionsListViewController.h"

#import "Route.h"
#import "Airport.h"
#import "MapKitHelpers.h"

@import MapKit;

@interface DirectionsListViewController ()
@end

@implementation DirectionsListViewController {
    NSMutableDictionary *_snapShots;
}

#pragma mark -

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _snapShots = [NSMutableDictionary new];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _route.toSourceAirportRoute.steps.count; break;
        case 1:
            return 1; break;
        case 2:
            return _route.fromDestinationAirportRoute.steps.count; break;
    }
    return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"To Airport"; break;
        case 1:
            return @"Flight"; break;
        case 2:
            return @"From Airport"; break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = nil;
    MKRouteStep *step = nil;
    
    switch (indexPath.section) {
        case 0: {
            step = _route.toSourceAirportRoute.steps[indexPath.row];
        }
            break;
        case 2: {
            step = _route.fromDestinationAirportRoute.steps[indexPath.row];
        }
            break;
    }
    
    if (step) {
        cell.textLabel.text = step.instructions;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Fly from %@ to %@", _route.sourceAirport.title, _route.destinationAirport.title];
    }
    UIImage *cachedImage = _snapShots[indexPath];
    if (cachedImage) {
        cell.imageView.image = cachedImage;
    } else {
        [self loadSnapshotForCellAtIndexPath:indexPath];
    }
    
    
    return cell;
}

- (void)loadSnapshotForCellAtIndexPath:(NSIndexPath *)indexPath
{
    MKRouteStep *step = nil;
    
    switch (indexPath.section) {
        case 0: {
            step = _route.toSourceAirportRoute.steps[indexPath.row];
        }
            break;
        case 2: {
            step = _route.fromDestinationAirportRoute.steps[indexPath.row];
        }
            break;
    }
    
    if (step) {
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.scale = [UIScreen mainScreen].scale;
        options.region = CoordinateRegionBoundingMapPoints(step.polyline.points, step.polyline.pointCount);
        options.size = CGSizeMake(44.0, 44.0);
        
        MKMapSnapshotter *snapshooter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshooter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        cell.imageView.image = snapshot.image;
                        [cell setNeedsLayout];
                    }
                    
                    _snapShots[indexPath] = snapshot.image;
                });
            }
        }];
    }

}

@end
