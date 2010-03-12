//
//  NNRestaurant.m
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNRestaurant.h"

@implementation NNRestaurant

@synthesize name;
@synthesize state;

- (id)initWithName:(NSString *)theName
{
	self = [super init];
	if (self){
		[self setName:theName];
		[self setState:NNUndefinedState];
	}
	return self;
}

- (NSImage *)stateImage
{
	if (state == NNUndefinedState){
		return [NSImage imageNamed:@"NSAddTemplate"];
	}
	else if (state == NNVetoedState){
		return [NSImage imageNamed:@"NSStopProgressTemplate"];
	}
	else if (state == NNVotedForState){
		return [NSImage imageNamed:@"NSAddTemplate"];
	}
	return nil;
}

@end
