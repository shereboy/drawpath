//
//  DPMove.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPMove.h"

@implementation DPMove

+(BOOL) isLegalMove:(DPBrick*) brickA : (DPBrick*) brickB;
{
  if(brickA.colNumber == brickB.colNumber && brickA.rowNumber == brickB.rowNumber)
    return NO;
  if(brickA.brickImage!= brickB.brickImage)
    return NO;
  if(abs(brickA.rowNumber-brickB.rowNumber)<=1 && abs(brickA.colNumber-brickB.colNumber)<=1)
    return YES;
  else
    return NO;
}

@end
