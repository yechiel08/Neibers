//
//  Article.m
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import "Article.h"

@implementation Article
@synthesize ID, accessToken, imageFile, type, numberType, title, subtitle, description, link;
@synthesize coordinate, longitude, latitude, openClose, numberFriends, name, address;

//MapList
-(id)initWithID:(NSString*)_ID accessToken:(NSString*)_accessToken imageFile:(NSString *)_imageFile type:(NSString *)_type numberType:(NSString*)_numberType title:(NSString*)_name subtitle:(NSString *)_address description:(NSString *)_description link:(NSString *)_link openClose:(NSString *)_openClose numberFriends:(NSString *)_numberFriends longitude:(float)_longitude latitude:(float)_latitude coordinate:(CLLocationCoordinate2D)_coordinate;
{
    if (self = [super init]) {
        self.ID = _ID;
		self.accessToken = _accessToken;
		self.imageFile = _imageFile;
		self.type = _type;
		self.numberType = _numberType;
		self.title = _name;
		self.subtitle = _address;
		self.description = _description;
		self.link = _link;
		self.openClose = _openClose;
		self.numberFriends = _numberFriends;
		self.longitude = _longitude;
		self.latitude = _latitude;
		self.coordinate = _coordinate;
	}
    
	return self;
}

//MyCommunityList
-(id)initWithID:(NSString*)_ID accessToken:(NSString*)_accessToken imageFile:(NSString *)_imageFile type:(NSString *)_type numberType:(NSString*)_numberType name:(NSString*)_name address:(NSString *)_address description:(NSString *)_description link:(NSString *)_link openClose:(NSString *)_openClose numberFriends:(NSString *)_numberFriends;
{
    if (self = [super init]) {
        self.ID = _ID;
		self.accessToken = _accessToken;
		self.imageFile = _imageFile;
		self.type = _type;
		self.numberType = _numberType;
		self.name = _name;
		self.address = _address;
		self.description = _description;
		self.link = _link;
		self.openClose = _openClose;
		self.numberFriends = _numberFriends;
	}
    
	return self;
}

@end
