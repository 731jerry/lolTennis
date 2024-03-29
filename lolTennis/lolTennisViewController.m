//
//  lolTennisViewController.m
//  lolTennis
//
//  Created by Administrator on 8/5/11.
//  Copyright 2011 University of Maine. All rights reserved.
//

#import "lolTennisViewController.h"

#define kGameStateRunning 1
#define kGameStatePaused  2

#define kBallSpeedX 3
#define kBallSpeedY 4

#define kCompMoveSpeed 3
#define kScoreToWin 5

@implementation lolTennisViewController
@synthesize ball,racquet_yellow,racquet_green,player_score,computer_score,gameState,ballVelocity,tapToBegin;

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if(gameState == kGameStatePaused) {
		tapToBegin.hidden = YES;
		gameState = kGameStateRunning;
	} else if(gameState == kGameStateRunning) {
		[self touchesMoved:touches withEvent:event];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint location = [touch locationInView:touch.view];
	CGPoint xLocation = CGPointMake(location.x,racquet_yellow.center.y);
	racquet_yellow.center = xLocation;
}

-(void) gameLoop {
	if(gameState == kGameStateRunning) {
        
		ball.center = CGPointMake(ball.center.x + ballVelocity.x , ball.center.y + ballVelocity.y);
        
		if(ball.center.x > self.view.bounds.size.width || ball.center.x < 0) {
			ballVelocity.x = -ballVelocity.x;
		}
		
		if(ball.center.y > self.view.bounds.size.height || ball.center.y < 0) {
			ballVelocity.y = -ballVelocity.y;
		}
		
		if(CGRectIntersectsRect(ball.frame,racquet_yellow.frame)) {
			if(ball.center.y < racquet_yellow.center.y) {
				ballVelocity.y = -ballVelocity.y;
			}
		}
		
		if(CGRectIntersectsRect(ball.frame,racquet_green.frame)) {
			if(ball.center.y > racquet_green.center.y) {
				ballVelocity.y = -ballVelocity.y;
			}
		}
		
		
		// Begin Simple AI
		if(ball.center.y <= self.view.center.y) {
			if(ball.center.x < racquet_green.center.x) {
				CGPoint compLocation = CGPointMake(racquet_green.center.x - kCompMoveSpeed, racquet_green.center.y);
				racquet_green.center = compLocation;
			}
			
			if(ball.center.x > racquet_green.center.x) {
				CGPoint compLocation = CGPointMake(racquet_green.center.x + kCompMoveSpeed, racquet_green.center.y);
				racquet_green.center = compLocation;
			}
		}
		// Begin Scoring Game Logic
		if(ball.center.y <= 0) {
			player_score_value++;
			[self reset:(player_score_value >= kScoreToWin)];
		}
		
		if(ball.center.y > self.view.bounds.size.height) {
			computer_score_value++;
			[self reset:(computer_score_value >= kScoreToWin)];
		}
		
	} else {
		if(tapToBegin.hidden) {
			tapToBegin.hidden = NO;
		}
	}
}

-(void)reset:(BOOL) newGame {
	self.gameState = kGameStatePaused;
	ball.center = self.view.center;
	if(newGame) {
		if(computer_score_value > player_score_value) {
			tapToBegin.text = @"Oops...You Died!";
		} else {
			tapToBegin.text = @"Yeah...You Wins!";
		}
		
		computer_score_value = 0;
		player_score_value = 0;
	} else {
		tapToBegin.text = @"Tap Anywhere To Begin";
	}
	
	player_score.text = [NSString stringWithFormat:@"%d",player_score_value];
	computer_score.text = [NSString stringWithFormat:@"%d",computer_score_value];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.gameState = kGameStatePaused;
	ballVelocity = CGPointMake(kBallSpeedX,kBallSpeedY);
	[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)dealloc {
    [super dealloc];
	[ball release];
	[racquet_green release];
	[racquet_yellow release];
	[player_score release];
	[computer_score release];
	[tapToBegin release];
}

@end
