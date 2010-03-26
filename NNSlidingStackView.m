//
//  NNSlidingStackView.m
//  lunchd
//
//  Created by MacRae Linton on 3/26/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNSlidingStackView.h"


@implementation NNSlidingStackView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		NSLog(@"I HAVE BEEN CREATED");
	}
    return self;
}

- (BOOL)isOpaque
{
	return YES;
}

- (BOOL)isFlipped
{
	return YES;
}

- (void)drawRect:(NSRect)rect
{
    // erase the background by drawing white
	//might be all I need to do here, others will draw on top. 
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:rect];
}

@end
