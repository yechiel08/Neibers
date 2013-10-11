//
//  GradientButton.m
//  Neibers
//
//  Created by Yechiel Amar on 23/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "GradientButton.h"

@implementation GradientButton

- (id)init
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}
-(void)initLayers{
    // Initialization code here.
//    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [[self layer] setCornerRadius:7.0f];
//    [[self layer] setMasksToBounds:YES];
//    [[self layer] setBorderWidth:1.0f];
    
}

- (void)awakeFromNib {
    [self initLayers];
}

- (void)setHighlighted:(BOOL)highlight {
    if (highlight != self.highlighted){
        CALayer *aL = [[[self layer] sublayers] objectAtIndex:0];
        CAGradientLayer *bL = [[[self layer] sublayers] objectAtIndex:1];
        [bL removeFromSuperlayer];
        [[self layer] insertSublayer:bL below:aL];
    }
    
    [self setNeedsDisplay];
    [super setHighlighted:highlight];
}

@end
