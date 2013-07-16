//
//  DPViewControllerGame.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPViewControllerGame.h"
#import "DPBoard.h"

@interface DPViewControllerGame ()

@end

@implementation DPViewControllerGame

@synthesize MainBoard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
  MainBoard = [DPBoard alloc];
  [MainBoard init];
  [self.view addSubview:MainBoard];
  [MainBoard drawBoard:self.view] ;
  
  // [self drawBoard];
}

@end

