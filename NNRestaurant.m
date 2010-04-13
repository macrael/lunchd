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
@synthesize vetos;
@synthesize state;

- (id)initWithName:(NSString *)theName
{
	self = [super init];
	if (self){
		[self setName:theName];
		[self setVotes:0];
		[self setVetos:0];
		[self setState:NNUndefinedState];
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
	NSLog(@"GIVE VOTE: %@",name);
	[self setVotes:votes +1];
	if (vetos == 0 && votes == 1){
		[self setState:NNVotedForState];
	}
}

- (void)takeVote
{
	NSLog(@"TAKE VOTE: %@",name);
	[self setVotes:votes -1];
	if (vetos == 0 && votes == 0){
		[self setState:NNUndefinedState];
	}
	if (vetos == -1){
		NSLog(@"WOAH NEGATIVE VOOTES--------------------------------------------------");
	}
}

- (void)giveVeto
{
	NSLog(@"GIVE VETO: %@",name);
	[self setVetos:vetos + 1];
	if (vetos == 1){
		[self setState:NNVetoedState];
	}
}

- (void)takeVeto
{
	NSLog(@"TAKE VETO: %@",name);
	[self setVetos:vetos - 1];
	if (vetos == 0){
		if (votes == 0){
			[self setState:NNUndefinedState];
		}else {
			[self setState:NNVotedForState];
		}
	}
	if (vetos == -1){
		NSLog(@"WOAH NEGATIVE VETOS--------------------------------------------------");
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	NNRestaurant *copiedRest = [[[self class] allocWithZone:zone] initWithName:[[self name] copy]];
	[copiedRest setVotes:[self votes]];
	[copiedRest setVetos:[self vetos]];
	return copiedRest;
}

@end
