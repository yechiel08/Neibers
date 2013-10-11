//
//  WebImageView.m
//  CoffeeConnect
//
//  Created by Ivan Chubov on 2/13/12.
//  Copyright 2012 Ideas. All rights reserved.
//

#import "WebImageView.h"
#import "QuartzCore/QuartzCore.h"

@implementation WebImageView

@synthesize activityIndicator = _imageActivityIndicator;
@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)loadFromURL:(NSURL *)url {
    [self loadFromURL:url useCache:YES];
}

- (void)loadFromURL:(NSURL *)url useCache:(BOOL)useCache {
    if (_data) {
        _data = nil;
    }
    
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
    
    if (_imageActivityIndicator) {
        [_imageActivityIndicator removeFromSuperview];
        _imageActivityIndicator = nil;
    }
    
    _data = [[NSMutableData alloc] initWithCapacity:256];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:useCache ? NSURLRequestUseProtocolCachePolicy : NSURLRequestReloadIgnoringLocalCacheData 
                                         timeoutInterval:60.0];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
    _imageActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _imageActivityIndicator.hidesWhenStopped = YES;
    _imageActivityIndicator.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    _imageActivityIndicator.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    [self addSubview:_imageActivityIndicator];
    [_imageActivityIndicator startAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    UIImage *image = [UIImage imageWithData:_data];
    self.image = image;
    
    [_imageActivityIndicator stopAnimating];
    if (_delegate) {
        [_delegate imageDidFinishLoading:self.image];
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)reset {
}

@end
