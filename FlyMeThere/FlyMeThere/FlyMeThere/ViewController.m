//
//  ViewController.m
//  FlyMeThere
//
//  Created by Matt Galloway on 22/06/2013.
//  Copyright (c) 2013 Matt Galloway. All rights reserved.
//

#import "ViewController.h"

#import "DirectionsListViewController.h"

#import "Airport.h"
#import "Route.h"
#import "MapKitHelpers.h"

@import MapKit;

typedef void (^LocationCallback)(CLLocationCoordinate2D);

@interface ViewController () <MKMapViewDelegate, UISearchBarDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIActivityIndicatorView *renderLoadingView;
@end

@implementation ViewController {
    NSArray *_airports;
    NSArray *_foundMapItems;
    LocationCallback _foundLocationCallback;
    Route *_route;
    NSMutableArray *_pendingCameras;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAirportData];
    [self addRightCustomView];
    _mapView.pitchEnabled = YES;
    _pendingCameras = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.toolbarHidden = NO;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"List"]) {
        return _route != nil;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"List"]) {
        DirectionsListViewController *vc = (DirectionsListViewController*)segue.destinationViewController;
        vc.route = _route;
    }
}

-(void)addRightCustomView
{
    _renderLoadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    _renderLoadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _renderLoadingView.hidesWhenStopped = YES;
    UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithCustomView:_renderLoadingView];
    [self.navigationItem setRightBarButtonItem:rightBarbutton];
}

#pragma mark -

- (void)loadAirportData {
    NSMutableArray *airports = [NSMutableArray new];
    
    NSURL *dataFileURL = [[NSBundle mainBundle] URLForResource:@"airports" withExtension:@"csv"];
    
    NSString *data = [NSString stringWithContentsOfURL:dataFileURL encoding:NSUTF8StringEncoding error:nil];
    
    NSCharacterSet *quotesCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:data];
    BOOL ok = YES;
    BOOL firstLine = YES;
    while (![scanner isAtEnd] && ok) {
        NSString *line = nil;
        ok = [scanner scanUpToString:@"\n" intoString:&line];
        
        if (firstLine) {
            firstLine = NO;
            continue;
        }
        
        if (line && ok) {
            NSArray *components = [line componentsSeparatedByString:@","];
            
            NSString *type = [components[2] stringByTrimmingCharactersInSet:quotesCharacterSet];
            if ([type isEqualToString:@"large_airport"]) {
                Airport *airport = [Airport new];
                airport.name = [components[3] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.city = [components[10] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.code = [components[13] stringByTrimmingCharactersInSet:quotesCharacterSet];
                airport.location = [[CLLocation alloc] initWithLatitude:[components[4] doubleValue]
                                                              longitude:[components[5] doubleValue]];
                
                [airports addObject:airport];
            }
        }
    }
    
    _airports = airports;
}

- (void)startSearchForText:(NSString*)searchText {
    // 1
    [_searchBar resignFirstResponder];
    _searchBar.userInteractionEnabled = NO;
    
    // 2
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = searchText;
    
    // 3
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count > 0) {
            // 4
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a location"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
            [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *mapItem, NSUInteger idx, BOOL *stop) {
                [actionSheet addButtonWithTitle:mapItem.placemark.title];
            }];
            
            [actionSheet addButtonWithTitle:@"Cancel"];
            actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
            
            // 5
            _foundMapItems = [response.mapItems copy];
            [actionSheet showInView:self.view];
        } else {
            // 6
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                            message:@"No search results found! Try again with a different query."
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            
            _searchBar.userInteractionEnabled = YES;
        }
    }];
}

- (MKMapItem*)mapItemForCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    return mapItem;
}

- (void)performAfterFindingLocation:(LocationCallback)callback {
    if (self.mapView.userLocation != nil) {
        if (callback) {
            callback(self.mapView.userLocation.coordinate);
        }
    } else {
        _foundLocationCallback = [callback copy];
    }
}

- (void)setupWithNewRoute:(Route *)route {
    if (_route) {
        [_mapView removeAnnotations:@[_route.source, _route.sourceAirport, _route.destination, _route.destinationAirport]];
        [_mapView removeOverlays:@[_route.flyPartPolyline, _route.toSourceAirportRoute.polyline, _route.fromDestinationAirportRoute.polyline]];
        _route = nil;
    }

    _route = route;
    
    [_mapView addAnnotations:@[_route.source, _route.sourceAirport, _route.destination, _route.destinationAirport]];
    [_mapView addOverlay:_route.fromDestinationAirportRoute.polyline level:MKOverlayLevelAboveRoads];
    [_mapView addOverlay:_route.toSourceAirportRoute.polyline level:MKOverlayLevelAboveRoads];
    [_mapView addOverlay:_route.flyPartPolyline level:MKOverlayLevelAboveRoads];
    
    //
    MKMapPoint points[4];
    points[0] = MKMapPointForCoordinate(_route.source.coordinate);
    points[1] = MKMapPointForCoordinate(_route.destination.coordinate);
    points[2] = MKMapPointForCoordinate(_route.sourceAirport.coordinate);
    points[3] = MKMapPointForCoordinate(_route.destinationAirport.coordinate);
    
    MKCoordinateRegion boundingregion = CoordinateRegionBoundingMapPoints(points, 4);
    boundingregion.span.latitudeDelta *= 1.1;
    boundingregion.span.longitudeDelta *= 1.1;
    
    [_mapView setRegion:boundingregion animated:YES];
    
    
}

- (Airport*)nearestAirportToCoordinate:(CLLocationCoordinate2D)coordinate {
    __block Airport *nearestAirport = nil;
    __block CLLocationDistance nearestDistance = DBL_MAX;
    
    CLLocation *coordinateLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [_airports enumerateObjectsUsingBlock:^(Airport *airport, NSUInteger idx, BOOL *stop) {
        CLLocationDistance distance = [coordinateLocation distanceFromLocation:airport.location];
        if (distance < nearestDistance) {
            nearestAirport = airport;
            nearestDistance = distance;
        }
    }];
    
    return nearestAirport;
}

- (void)calculateRouteToMapItem:(MKMapItem *)item
{
    [self performAfterFindingLocation:^(CLLocationCoordinate2D userLocation) {
        MKPointAnnotation *sourceAnnotation = [MKPointAnnotation new];
        sourceAnnotation.coordinate = userLocation;
        sourceAnnotation.title = @"Start";
        
        MKPointAnnotation *destinationAnnotation = [MKPointAnnotation new];
        destinationAnnotation.coordinate = item.placemark.coordinate;
        destinationAnnotation.title = @"End";
        
        Airport *sourceAirport = [self nearestAirportToCoordinate:userLocation];
        Airport *destinationAirport = [self nearestAirportToCoordinate:item.placemark.coordinate];
        
        MKMapItem *sourceItem = [self mapItemForCoordinate:userLocation];
        MKMapItem *destinationItem = item;
        
        MKMapItem *sourceAirportItem = [self mapItemForCoordinate:sourceAirport.coordinate];
        sourceAirportItem.name = sourceAirport.title;
        
        MKMapItem *destinationAirportItem = [self mapItemForCoordinate:destinationAirport.coordinate];
        sourceAirportItem.name = destinationAirport.title;
        
        __block MKRoute *toSourceAirportDirectionRoute = nil;
        __block MKRoute *fromDestinationAirportDirectionRoute = nil;
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        
        [self obtainDirectionsFrom:sourceItem to:sourceAirportItem completion:^(MKRoute *route, NSError *error) {
            if (!error) {
                toSourceAirportDirectionRoute = route;
            }
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [self obtainDirectionsFrom:destinationAirportItem to:destinationItem completion:^(MKRoute *route, NSError *error) {
            if (!error) {
                fromDestinationAirportDirectionRoute = route;
            }
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            if (fromDestinationAirportDirectionRoute && toSourceAirportDirectionRoute) {
                Route *route = [Route new];
                route.sourceAirport = sourceAirport;
                route.destinationAirport = destinationAirport;
                route.source = sourceAnnotation;
                route.destination = destinationAnnotation;
                route.fromDestinationAirportRoute = fromDestinationAirportDirectionRoute;
                route.toSourceAirportRoute = toSourceAirportDirectionRoute;
                
                CLLocationCoordinate2D coords[2] = {sourceAirport.coordinate, destinationAirport.coordinate};
                route.flyPartPolyline = [MKGeodesicPolyline polylineWithCoordinates:coords count:2];
                [self setupWithNewRoute:route];
                
                self.searchBar.userInteractionEnabled = YES;
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Failed to find directions! Please try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }

        });
    }];
}

- (void)obtainDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to completion:(void(^)(MKRoute*, NSError*)) completion
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *anError) {
        MKRoute *route = nil;
        if (response.routes.count > 0) {
            route = response.routes[0];
        } else {
            NSError *error = [NSError errorWithDomain:@"com.longnv.FlyMeThere" code:404 userInfo:@{NSLocalizedDescriptionKey: @"No routes found"}];
            NSLog(@"Error %@", error.localizedDescription);
        }
        if (completion) {
            completion(route, anError);
        }
    }];
}

- (void)moveCameraToCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKMapCamera *endCamera = [MKMapCamera cameraLookingAtCenterCoordinate:coordinate fromEyeCoordinate:coordinate eyeAltitude:1000.0f];
    endCamera.pitch = 55.0f;
    [_pendingCameras addObject:endCamera];
    
    CLLocationCoordinate2D currentCoordinate = _mapView.centerCoordinate;
    CLLocation *coordinateLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
    
    CLLocationDistance distance = ABS([coordinateLocation distanceFromLocation:currentLocation]);
    
    if (distance > 5000.0f) {
        MKMapCamera *upEndCamera = [MKMapCamera cameraLookingAtCenterCoordinate:coordinate
                                                              fromEyeCoordinate:coordinate
                                                                    eyeAltitude:distance];
        [_pendingCameras addObject:upEndCamera];
        
        MKMapCamera *upStartCamera = [MKMapCamera cameraLookingAtCenterCoordinate:currentCoordinate
                                                                fromEyeCoordinate:currentCoordinate
                                                                      eyeAltitude:distance];
        [_pendingCameras addObject:upStartCamera];
    } else if (distance > 2500.0f) {
        CLLocationCoordinate2D midPoint = CLLocationCoordinate2DMake((currentCoordinate.latitude + coordinate.latitude) / 2.0f,
                                                                     (currentCoordinate.longitude + coordinate.longitude) / 2.0f);
        
        MKMapCamera *midCamera = [MKMapCamera cameraLookingAtCenterCoordinate:midPoint
                                                            fromEyeCoordinate:midPoint
                                                                  eyeAltitude:distance];
        [_pendingCameras addObject:midCamera];
    }
    [self goToNextCamera];

}

- (void)goToNextCamera
{
    if (_pendingCameras.count > 0) {
        MKMapCamera *camera = [_pendingCameras lastObject];
        [_pendingCameras removeLastObject];
        
        [UIView animateWithDuration:1.0 animations:^{
            _mapView.camera = camera;
        }];
    }
}


#pragma mark - MKMapViewDelegate

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPlacemark class]]) {
        MKPinAnnotationView *pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"placemark"];
        if (!pin) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"placemark"];
            pin.pinColor = MKPinAnnotationColorRed;
            pin.canShowCallout = YES;
        } else {
            pin.annotation = annotation;
        }
        return pin;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        if (overlay == _route.flyPartPolyline) {
            renderer.strokeColor = [UIColor redColor];
        } else {
            renderer.strokeColor = [UIColor blueColor];
        }
        
        return renderer;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_foundLocationCallback) {
        _foundLocationCallback(userLocation.coordinate);
        _foundLocationCallback = nil;
    }
}

- (void)mapViewWillStartRenderingMap:(MKMapView *)mapView
{
    [_renderLoadingView startAnimating];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered
{
    [_renderLoadingView stopAnimating];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self goToNextCamera];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSearchForText:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        MKMapItem *item = _foundMapItems[buttonIndex];
        NSLog(@"Selected item: %@", item);
        // TODO: Calculate route
        [self calculateRouteToMapItem:item];
        _searchBar.userInteractionEnabled = YES;
    } else {
        _searchBar.userInteractionEnabled = YES;
    }
}

#pragma mark - Change Camera
- (IBAction)startTapped:(id)sender
{
    [self moveCameraToCoordinate:_route.source.coordinate];
}

- (IBAction)airportATapped:(id)sender
{
    [self moveCameraToCoordinate:_route.sourceAirport.location.coordinate];
}

- (IBAction)airportBTapped:(id)sender
{
    [self moveCameraToCoordinate:_route.destinationAirport.location.coordinate];
}

- (IBAction)endTapped:(id)sender
{
    [self moveCameraToCoordinate:_route.destination.coordinate];
}

@end
