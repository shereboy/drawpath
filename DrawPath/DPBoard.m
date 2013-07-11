//
//  DPBoard.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPBoard.h"

@implementation DPBoard

@synthesize colorArray;



-(id)init
{
  self = [super init];
  if (self)
  {
  colorArray =[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor], nil];
  }
  return self;
}



@end
