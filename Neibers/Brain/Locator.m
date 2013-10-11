//
//  Locator.m
//  IORun
//
//  Created by Tal Zarfati on 1/30/10.
//  Copyright 2010 Talz. All rights reserved.
//


//-force_flat_namespace
//-undefined
//supress

#import "Locator.h"


@implementation Locator

@synthesize locationManager;
@synthesize location;

-(id) init
{
	self = [super init];
	if(!self)
	{
		return nil;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	if(!locationManager)
	{
		return nil;
	}
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	locationManager.distanceFilter = kCLDistanceFilterNone;
	locationManager.delegate = self;
	
	//if([CLLocationManager headingAvailable])
	//{
        // attempt to acquire location and thus, the amount of power that will be consumed.
        //locationManager.desiredAccuracy = [[setupInfo objectForKey:kSetupInfoKeyAccuracy] doubleValue];
		[locationManager startUpdatingLocation];
	//}
	//else
	//{
	//	NSLog(@"Location service not available");
	//}
	
	return self;
}

-(BOOL) getCoordinates: (CLLocationCoordinate2D* ) coordinates
{	
    if([CLLocationManager locationServicesEnabled])
    {
        //loop untill we get a location, or a failure
        while(NO == isLocated)
        {
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.25, false);
        }
	}
    else
    {
        if(nil == location)
        {
            return NO;
        }
    }
	
	(*coordinates) = [location coordinate];
	
	return YES;
}


- (void)locationManager:(CLLocationManager *)manager 
	didUpdateToLocation:(CLLocation *)newLocation 
		   fromLocation:(CLLocation *)oldLocation
{
	@synchronized(self)
	{
		self.location = newLocation;
		isLocated = YES;
	}
}

- (void)locationManager:(CLLocationManager *)manager 
	   didFailWithError:(NSError *)error
{
	@synchronized(self)
	{
		self.location = nil;
		isLocated = YES;
	}
}

- (void)locationManager:(CLLocationManager *)manager 
	   didUpdateHeading:(CLHeading *)newHeading
{
	//stub
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration: (CLLocationManager *)manager
{
	//stub
	return NO;
}

@end
