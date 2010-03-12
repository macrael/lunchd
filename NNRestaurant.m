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

@end
