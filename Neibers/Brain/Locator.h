//
//  Locator.h
//  IORun
//
//  Created by Tal Zarfati on 1/30/10.
//  Copyright 2010 Talz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Locator : NSObject <CLLocationManagerDelegate>{
	CLLocationManager* locationManager;
	CLLocation* location;
	
	BOOL isLocated;
}

@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, copy) CLLocation* location;

-(BOOL) getCoordinates: (CLLocationCoordinate2D* ) coordinates;
@end