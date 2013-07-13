//
//  DPBoard.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPBrick.h"

@interface DPBoard : UIView

@property (strong,nonatomic) NSArray *colorArray ;
@property (strong, nonatomic) NSMutableArray *initialBricksArray;
@property (strong, nonatomic) NSMutableArray *currentBricksArray;
@property (strong,nonatomic) NSMutableArray *dropBricksArray;
@property (strong, nonatomic) NSTimer *brickTimer;
@property(strong,nonatomic) UIView *parentView;
@property int brickWidth;
@property int brickHeight;

-(void) drawBoard:(id)parent;
+(void) hoverBrick:(id)sender;
-(void)addToDropArray :(DPBrick*) brick;
-(void)addToDropArray2 :(DPBrick*) brick;
@end
