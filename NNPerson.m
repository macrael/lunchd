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

- (id)initWithName:(NSString *)newName
{
	self = [super init];
	if (self){
		[self setName:newName];
		[self setState:NNUndefinedState];
		[self setVeto:nil];
		[self setVotes:nil];
	}
	return self;
}

@end
