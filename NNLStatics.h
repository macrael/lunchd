//
//  NNLStatics.h
//  lunchd
//
//  Created by MacRae Linton on 3/10/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

enum {
	NNUndefinedState = 0,
	
	NNComingState = 1,
	NNNotComingState = 2,
	
	NNVetoedState = 5,
	NNVotedForState = 6,
	NNChosenState = 7
};