//
//  DPViewControllerGame.m
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import "DPViewControllerGame.h"

#import "Constants.h"
#import "DPBrick.h"
#import "DPMove.h"

@interface DPViewControllerGame ()

@end

@implementation DPViewControllerGame

@synthesize BrickStack;
@synthesize InitialBrickStack;
@synthesize BrickTimer;

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
	// Do any additional setup after loading the view.
  
  self.BrickStack = [[NSMutableArray alloc] init];
  self.InitialBrickStack = [[NSMutableArray alloc] init];
  
}

- (void) viewDidAppear:(BOOL)animated
{
  [self drawBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CUSTOM METHODS

-(void) drawBoard
{
  NSArray* colorArray =[NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor greenColor],[UIColor yellowColor],[UIColor orangeColor], nil];
  
  for (int i = 0; i<ROW_COUNT ; i++) {
    for (int j = 0; j<COL_COUNT; j++)
    {
      if (j !=0 && j%COL_COUNT == 0) continue;
      else
      {
        NSUInteger randomIndex = arc4random() % [colorArray count];
        DPBrick *brick = [DPBrick alloc];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
          brick.frameX=(j*IPAD_BOX_WIDTH+FRAME_LEFT_PADDING);
          brick.frameY=(i*IPAD_BOX_HEIGHT+FRAME_TOP_PADDING);
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
          brick.frameX=(j*BOX_WIDTH+FRAME_LEFT_PADDING);
          brick.frameY=(i*BOX_HEIGHT+FRAME_TOP_PADDING);
        }
        
        
        
        brick.assignedColor = colorArray[randomIndex];
        brick.rowNumber = i;
        brick.colNumber = j;
        [InitialBrickStack addObject:brick];
        //[self drawRectangle:i*50+FRAME_LEFT_PADDING :j*50+FRAME_TOP_PADDING :colorArray[randomIndex]:i:j];
      }
    }
  }
  
  
  BrickTimer = [NSTimer scheduledTimerWithTimeInterval:ANIMATION_DURATION
                                                target:self
                                              selector:@selector(drawRectangleFromStack:)
                                              userInfo:nil
                                               repeats:YES
                ];
  
}

-(void) drawRectangleFromStack :(id) sender
{
  NSLog(@"TIMER WORKING");
  if ([InitialBrickStack count] > 0)
  {
    DPBrick *brick = [self.InitialBrickStack objectAtIndex:[self.InitialBrickStack count]-1];
    [self drawRectangle:brick.frameX:brick.frameY :brick.assignedColor:brick.rowNumber:brick.colNumber];
    
    
    [InitialBrickStack removeLastObject];
  }
  else
  {
    [self.BrickTimer invalidate];
    self.BrickTimer = nil;
  }
  
  
  
  
}

-(void) drawRectangle:(int)x
                     :(int)y
                     :(UIColor*)color
                     :(int)rowNumber
                     :(int)colNumber
{
  
  DPBrick* thisBrick =[DPBrick alloc];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    thisBrick =[[DPBrick alloc]initWithFrame:CGRectMake(x,y,IPAD_BOX_WIDTH,IPAD_BOX_HEIGHT)];
  }
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    thisBrick =[[DPBrick alloc]initWithFrame:CGRectMake(x,y,BOX_WIDTH,BOX_HEIGHT)];
  }
  
  
  thisBrick.colNumber = colNumber;
  thisBrick.rowNumber = rowNumber;
  
  thisBrick.backgroundColor = color;
  thisBrick.assignedColor = color;
  thisBrick.alpha = 0;
  
  CGPoint center = CGPointMake(thisBrick.center.x,thisBrick.center.y-ANIMATION_DISTANCE);
  
  thisBrick.center = center;
  
  
  
  center = CGPointMake(thisBrick.center.x,thisBrick.center.y+ANIMATION_DISTANCE);
  
  [UIView animateWithDuration: ANIMATION_DURATION
                   animations: ^{
                     thisBrick.alpha = 1;
                     thisBrick.center = center;
                   }
                   completion: ^(BOOL finished) {
                     
                     //[self.car removeFromSuperview];
                   }
   ];
  
  //[view addTarget:self action:@selector(rectClicked:) forControlEvents:UIControlEventTouchDragInside];
  [self.view addSubview:thisBrick];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  
  NSLog( @"%@%f%@%f", @"Touch Oldu: ", touchLocation.x, @" - ", touchLocation.y );
  
  for(DPBrick *brick in self.view.subviews)
    if(CGRectContainsPoint(brick.frame,touchLocation) &&
       brick.backgroundColor != [UIColor blackColor] &&
       ![self.BrickStack containsObject:brick] &&
       [brick isKindOfClass:[DPBrick class]]
       )
    {
      if([self.BrickStack count]>0)
      {
        DPBrick *tmpBrick = [self.BrickStack objectAtIndex:[self.BrickStack count]-1];

        if([DPMove isLegalMove:tmpBrick :brick])
        {
          
          [self.BrickStack addObject:brick];
          [self rectClicked:brick];
        }
        else
        {
          NSLog(@"arkaplan farkli");
        }
      }
      else
      {
        [self.BrickStack addObject:brick];
        [self rectClicked:brick];
      }
    }
  
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
  [self.BrickStack removeAllObjects];
  
  for(DPBrick *brick in self.view.subviews)
    if([brick isKindOfClass:[DPBrick class]])
      brick.backgroundColor = brick.assignedColor;
}

-(IBAction)rectClicked:(id)sender{
  
  UIButton *button = (UIButton *) sender;
  button.backgroundColor= [UIColor blackColor];
  CGColorRef colorRef = button.backgroundColor.CGColor;
  NSString *boxColor = [CIColor colorWithCGColor:colorRef].stringRepresentation;
  NSLog(@"%@", boxColor);
  
}

@end

