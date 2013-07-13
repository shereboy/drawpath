//
//  DPDropBrick.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/12/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBrick.h"

@interface DPDropBrick : NSObject

@property (nonatomic,strong) DPBrick* brickToDrop;
@property int stepsToDrop;

@end
