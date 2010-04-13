//
//  NNPerson.m
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import "NNPerson.h"


@implementation NNPerson

@synthesize name;
@synthesize state;
@synthesize veto;
@synthesize votes;
@synthesize host;

- (id)initWithName:(NSString *)newName
{
	self = [super init];
	if (self){
		[self setName:newName];
		[self setState:NNUndefinedState];
		[self setVeto:nil];
		votes = [[NSMutableArray alloc] initWithCapacity:5];
	}
	return self;
}

- (void)voteFor:(NSString *)restaurant
{
	if ([votes containsObject:restaurant]){
		NSLog(@"ERROR? VOTE TWICE?");
	}
	if ([veto isEqualToString:restaurant]){
		NSLog(@"ERROR? Vote FOR VETO?");
	}
	
	[votes addObject:restaurant];
}

- (void)giveVeto:(NSString *)restaurant
{
	if (! [veto isEqual: nil]){
		NSLog(@"ERROR, CAN't GIVE 2 VETOS");
	}
	[self setVeto:restaurant];
}

@end
