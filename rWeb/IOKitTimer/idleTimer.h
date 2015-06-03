//
//  idleTimer.h
//  rWeb
//
//  Created by David Haylock on 02/06/2015.
//  Copyright (c) 2015 David Haylock. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <IOKit/IOKitLib.h>

@interface idleTimer : NSObject

-(int64_t)SystemIdleTime;

@end
