//
//  DPViewControllerGame.h
//  DrawPath
//
//  Created by Tolga Seremet on 7/11/13.
//  Copyright (c) 2013 Tolga Seremet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPBoard.h"

@interface DPViewControllerGame : UIViewController

@property (strong, nonatomic) NSMutableArray *BrickStack;
@property (strong, nonatomic) DPBoard *MainBoard;

@end
