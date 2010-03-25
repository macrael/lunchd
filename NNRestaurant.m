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
@synthesize votes;

- (id)initWithName:(NSString *)theName
{
	self = [super init];
	if (self){
		[self setName:theName];
		[self setVotes:0];
	}
	return self;
}

-(void)dealloc
{
	[name release];
	[super dealloc];
}

- (void)giveVote
{
	if (votes >=0){
		[self setVotes: votes + 1];
	}else {
		NSLog(@"ERROR: Shouldn't be voting for a vetoed place.");
	}
}
- (void)giveVeto
{
	if (votes == -1){
		NSLog(@"ERROR: Shouldn't be vetoing an already vetoed place.");
	}
	[self setVotes:-1];
}

- (id)copyWithZone:(NSZone *)zone
{
	NNRestaurant *copiedRest = [[[self class] allocWithZone:zone] initWithName:[[self name] copy]];
	[copiedRest setVotes:[self votes]];
	return copiedRest;
}

@end
