//
//  YMLocationManager.h
//  YesMe
//
//  Created by Sri on 20/04/15.
//  Copyright (c) 2015 urgo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

typedef void (^locationManagerCompleted)(float latitude, float longitude, NSError *error);
@interface YMLocationManager : NSObject
@property(nonatomic, strong)CLLocationManager *locationManager;
@property(nonatomic, strong)CLLocation *lastUpdatedLocation;
+(YMLocationManager *)sharedLocationManager;
-(void)refreshLocation:(locationManagerCompleted)onLocationUpdate;
-(void)reInitialiseLocationManager;
-(void)stopServices;
-(BOOL)startServices;
-(void)checkLocationStatusAndAlertUser;
-(BOOL)isLocationServiceAvailable;
@end
