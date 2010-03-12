//
//  NNRestaurant.h
//  lunchd
//
//  Created by MacRae Linton on 3/9/10.
//  Copyright 2010 Apple Inc.. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NNLStatics.h"

@interface NNRestaurant : NSObject {
	NSString *name;
	int state;
}

@property (copy) NSString *name;
@property (assign) int state;

- (id)initWithName:(NSString *)theName;

- (NSImage *)stateImage;


@end
