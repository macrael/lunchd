//
//  NNRestaurantView.m
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNRestaurantView.h"


@implementation NNRestaurantView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"I HAVE BEEN Cratered");
	}
    return self;
}

- (void)awakeFromNib
{
	NSLog(@"RVIEW AWAKES");
}

- (BOOL)isOpaque
{
	return YES;
}

- (void)drawRect:(NSRect)rect
{
    // erase the background by drawing white
	//might be all I need to do here, others will draw on top. 
    [[NSColor blueColor] set];
    [NSBezierPath fillRect:rect];
}

@end
