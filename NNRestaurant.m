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
@synthesize hasYourVote;

- (id)initWithName:(NSString *)theName
{
	self = [super init];
	if (self){
		[self setName:theName];
		[self setVotes:0];
		[self setHasYourVote:NO];
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
	//right now can give infinite votes.
	if (votes >=0 && !hasYourVote){
		[self setHasYourVote:YES];
		[self setVotes: votes + 1];
	}else {
		NSLog(@"ERROR: Shouldn't be voting for this place.");
	}
}
- (void)giveVeto
{
	if (votes >= 0){
		[self setVotes:-1];
	}else {
		[self setVotes: votes - 1];
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	NNRestaurant *copiedRest = [[[self class] allocWithZone:zone] initWithName:[[self name] copy]];
	[copiedRest setVotes:[self votes]];
	return copiedRest;
}

@end
