//
//  Article.h
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import "BaseDomainObject.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Article : BaseDomainObject <CLLocationManagerDelegate>

@property (nonatomic, retain) NSString *ID, *accessToken, *imageFile, *type, *numberType, *title, *subtitle, *description, *link, *openClose, *numberFriends, *name, *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;

//MapList
-(id)initWithID:(NSString*)_ID accessToken:(NSString*)_accessToken imageFile:(NSString *)_imageFile type:(NSString *)_type numberType:(NSString*)_numberType title:(NSString*)_name subtitle:(NSString *)_address description:(NSString *)_description link:(NSString *)_link openClose:(NSString *)_openClose numberFriends:(NSString *)_numberFriends longitude:(float)_longitude latitude:(float)_latitude coordinate:(CLLocationCoordinate2D)_coordinate;

//MyCommunityList
-(id)initWithID:(NSString*)_ID accessToken:(NSString*)_accessToken imageFile:(NSString *)_imageFile type:(NSString *)_type numberType:(NSString*)_numberType name:(NSString*)_name address:(NSString *)_address description:(NSString *)_description link:(NSString *)_link openClose:(NSString *)_openClose numberFriends:(NSString *)_numberFriends;

@end
