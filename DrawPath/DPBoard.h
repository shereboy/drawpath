//
//  DPBoard.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPBoard : NSObject

@property (strong,nonatomic) NSArray* colorArray ;
@property (strong, nonatomic) NSMutableArray* initialBricksArray;

-(void) drawBoard;

@end
