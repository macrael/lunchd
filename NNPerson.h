//
//  NNPerson.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NNPerson : NSObject {
	NSString *name;
	int state;
}

@property (copy) NSString *name;
@property (assign) int state;

- (NSURL *)stateImage;

@end
