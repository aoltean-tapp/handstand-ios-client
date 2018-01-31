//
//  YMLocationManager.m
//  YesMe
//
//  Created by Sri on 20/04/15.
//  Copyright (c) 2015 urgo. All rights reserved.
//
#import "YMLocationManager.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface YMLocationManager()<CLLocationManagerDelegate, UIAlertViewDelegate>
{
    NSMutableArray *handlers;

}
@property (nonatomic, assign) BOOL mAlertViewShow;
@end

@implementation YMLocationManager
+(YMLocationManager *)sharedLocationManager
{
    static YMLocationManager *sharedLocationManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc] init];
//        [sharedLocationManager reInitialiseLocationManager];
//        sharedLocationManager.locationManager = [[CLLocationManager alloc] init];
//        sharedLocationManager.locationManager.distanceFilter = kCLDistanceFilterNone;
//        sharedLocationManager.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
//        sharedLocationManager.locationManager.delegate = sharedLocationManager;
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//        {
//            [self.locationManager requestAlwaysAuthorization];
//        }
//        [self.locationManager startMonitoringSignificantLocationChanges];

    });
    return sharedLocationManager;

}



-(instancetype)init
{
    self = [super init];
    handlers = [[NSMutableArray alloc]init];
    return self;
}

-(BOOL)locationServiceState{
//    if ([PFUser currentUser][kPFUserIsSettingsSet]) {
//        return [[PFUser currentUser][kPFUserLocationServices] boolValue];
//    }
    return YES;
}

-(void)reInitialiseLocationManager
{
//    if(self.locationManager)
//    {
//        [self.locationManager stopUpdatingLocation];
//        [self.locationManager stopMonitoringSignificantLocationChanges];
//    }
//
    self.locationManager = [[CLLocationManager  alloc]init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    if ([self locationServiceState]) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
//        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

-(void)refreshLocation:(locationManagerCompleted)onLocationUpdate
{
    locationManagerCompleted locationUpdatedHandler = onLocationUpdate;
    [handlers addObject:locationUpdatedHandler];
    if ([self locationServiceState]) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Core


-(void)stopServices{
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

-(BOOL)startServices{
    if ([CLLocationManager locationServicesEnabled]) {
        [self reInitialiseLocationManager];
        [self.locationManager startUpdatingLocation];
        return YES;
    }
    else{
        [self showEnableLocationMessage];
    }
    return NO;
}

-(void)checkLocationStatusAndAlertUser{
    if (![CLLocationManager locationServicesEnabled]) {
        [self showEnableLocationMessage];
    }
    else{
        if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
            [self showEnableLocationMessage];
        }
    }
}

-(BOOL)isLocationServiceAvailable{
    if (![CLLocationManager locationServicesEnabled]) {
        return NO;
    }
    else{
        if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
            return NO;
        }
    }
    return YES;
}


-(void)showEnableLocationMessage{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Handstand needs your location services enabled for better experience" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Setting", nil];
    alert.delegate = self;
    [alert show];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    self.lastUpdatedLocation = [locations objectAtIndex:0];
    [self.locationManager stopUpdatingLocation];
    if (handlers)
    {
        for ( locationManagerCompleted locationHandler in handlers)
        {
            locationHandler(self.lastUpdatedLocation.coordinate.latitude, self.lastUpdatedLocation.coordinate.longitude, nil);
        }
        [handlers removeAllObjects];
    }

//    if (kAppDelegate.currentUser.PFUser)
//    {
//        kAppDelegate.currentUser.PFUser[kUserLocation] = [PFGeoPoint geoPointWithLatitude:self.lastUpdatedLocation.coordinate.latitude longitude:self.lastUpdatedLocation.coordinate.longitude];
//        [kAppDelegate.currentUser.PFUser saveInBackground];
//    }
//    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    for ( locationManagerCompleted locationHandler in handlers)
    {
        if ([CLLocationManager locationServicesEnabled]) {
            locationHandler(0.0, 0.0, error);
        }
        else{
            locationHandler(0.0, 0.0, [NSError errorWithDomain:@"LocationAlert" code:1400 userInfo:@{NSLocalizedDescriptionKey:@"Please enable location service for Handstand to work better."}]);
        }
    }
    [handlers removeAllObjects];
    NSString *errorString;
    [manager stopUpdatingLocation];
    if (!self.mAlertViewShow && [CLLocationManager locationServicesEnabled])
    {
        switch([error code])
        {
            case kCLErrorDenied:
            {
                //Access denied by user
//                errorString = @"Access to Location Services denied by user.";
//                UIAlertView *alert;
//                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
//                {
//                    alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Setting", nil];
//                    alert.delegate = self;
//
//                }
//                else
//                {
//                    alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                }
//                [alert show];
                break;
            }
            case kCLErrorLocationUnknown:
            {
//                errorString = @"Location data unavailable. Please try again";
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//                alert.delegate = self;
//                [alert show];
                break;
            }
            default:
            {
                errorString = @"An unknown error has occurred";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alert.delegate = self;
                [alert show];
                break;
            }
        }
        self.mAlertViewShow = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.mAlertViewShow = NO;
    switch (buttonIndex)
    {
        case 1:
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
            break;
        default:
            break;
    }
}



@end
