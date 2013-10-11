//
//  WebImageView.h
//  CoffeeConnect
//
//  Created by Ivan Chubov on 2/13/12.
//  Copyright 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageViewDelegate.h"

@interface WebImageView : UIImageView {
    id<WebImageViewDelegate> _delegate;
    NSURLConnection *_connection;
	NSMutableData *_data;
    UIActivityIndicatorView *_imageActivityIndicator;
}

@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, assign) id<WebImageViewDelegate> delegate;

- (void)loadFromURL:(NSURL *)url;
- (void)loadFromURL:(NSURL *)url useCache:(BOOL)useCache;
- (void)reset;

@end
