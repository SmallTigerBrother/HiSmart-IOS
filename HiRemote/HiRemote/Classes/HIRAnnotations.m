//
//  HIRAnnotations.m
//  HiRemote
//
//  Created by parker on 7/1/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRAnnotations.h"

@implementation HIRAnnotations
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize type;
@synthesize tag;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coord{
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void) dealloc
{
    self.title = nil;
    self.subtitle = nil;
    self.type = nil;
}

@end
