//
//  MapPinView.h
//  ZoomGala
//
//  Created by Yechiel Amar on 19/03/13.
//  Copyright (c) 2013 Yechiel  Amar. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "DomainObjects.h"
#import "WebImageView.h"
#import "Article.h"

#define MAP_PIN_ID @"MapPinView"

@interface MapPinView : MKAnnotationView <UINavigationControllerDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet WebImageView *imageProfile;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UIImageView *cup;
@property (strong, nonatomic) IBOutlet UILabel *headline;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UIButton *nameButton;
@property (strong, nonatomic) IBOutlet UIButton *nameImageButton;
@property (strong, nonatomic) IBOutlet UIImageView *dolarIcon;


@property (nonatomic, retain) Article *article;

@end
