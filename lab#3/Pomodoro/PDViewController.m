//
//  PDViewController.m
//  Pomodoro
//
//  Created by Roman on 04.18.13.
//  Copyright (c) 2013 Roman Roibu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PDViewController.h"

@interface PDViewController ()

@end

@implementation PDViewController

@synthesize mainView;

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

	// Add shadow under the mainView
    self.mainView.layer.masksToBounds = NO;
    self.mainView.layer.shadowOffset = CGSizeMake(-25, 0);
    self.mainView.layer.shadowRadius = 25;
    self.mainView.layer.shadowOpacity = 0.8;
    
    // Remove white line button problem for START button
    [self->startButton.layer setBackgroundColor: [[UIColor blackColor]CGColor]];
    [self->startButton.layer setBorderWidth:1.0f];
    [self->startButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:1.0]CGColor]];
    [self->startButton.layer setShadowOpacity:0.1f];
    [self->startButton.layer setCornerRadius:5.8];
    
    // Remove white line button problem for STOP button
    [self->stopButton.layer setBackgroundColor: [[UIColor blackColor]CGColor]];
    [self->stopButton.layer setBorderWidth:1.0f];
    [self->stopButton.layer setBorderColor:[[UIColor colorWithWhite:0.3 alpha:1.0]CGColor]];
    [self->stopButton.layer setShadowOpacity:0.1f];
    [self->stopButton.layer setCornerRadius:5.8];
    
    // Enable START button and disable STOP button
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    if ([animationID isEqualToString:@"slideMenu"]){
        UIView *sq = (UIView *) CFBridgingRelease(context);
        [sq removeFromSuperview];
    }
}

- (IBAction)settingsTapped:(id) sender {
//    NSLog(@"Menu tapped");
    CGRect frame = self.mainView.frame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector( animationDidStop:finished:context: )];
    [UIView beginAnimations:@"slideMenu" context:(__bridge void *)(self.mainView)];
    
    if(menuOpen) {
        if (![sender isKindOfClass:[UIBarButtonItem class]]) {
            if ([sender direction] == UISwipeGestureRecognizerDirectionRight) {
                return;
            }
        }
        // If pressed by button, or swiped left, perform the animation
        frame.origin.x = 0;
        menuOpen = NO;
    }
    else {
        if (![sender isKindOfClass:[UIBarButtonItem class]]) {
            if ([sender direction] == UISwipeGestureRecognizerDirectionLeft) {
                return;
            }
        }
        // If pressed by button, or swiped right, perform the animation
        frame.origin.x = 250;
        menuOpen = YES;
    }
    
    self.mainView.frame = frame;
    [UIView commitAnimations];
}

-(void)countdown {
    // If the time ends
    if (minutes == 0 && seconds == 0) {
        [self pomodoroComplete];
    }
    else {
        // If ran out of seconds, get some
        if (seconds == 0) { minutes--; seconds = 60; }
        
        // Decrement one second
        seconds--;
        
        // Update minutes and seconds labels
        minuteLabel.text = [NSString stringWithFormat:@"%i %i", (minutes / 10), minutes - (minutes / 10 * 10)];
        secondLabel.text = [NSString stringWithFormat:@"%i %i", (seconds / 10), seconds - (seconds / 10 * 10)];
    }
}

-(IBAction)doStartPomodoro :(id)sender {
    // Set minutes and seconds
    minutes = minPomodoros;
    seconds = 0;
    
    // Update minutes and seconds labels
    minuteLabel.text = [NSString stringWithFormat:@"%i %i", (minutes / 10), minutes - (minutes / 10 * 10)];
    secondLabel.text = [NSString stringWithFormat:@"%i %i", (seconds / 10), seconds - (seconds / 10 * 10)];

    // Create timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdown) userInfo:nil repeats:YES];
    
    // Disable START button, and enable STOP button
    [startButton setEnabled:NO];
    [stopButton setEnabled:YES];
    
    if (podomorosSoFar < longBreakInterval) {
        breakTypeLabel.text = @"Short";
    }
    else {
        breakTypeLabel.text = @"Long";
    }
}

-(IBAction)doStopPomodoro:(id)sender {
    // Invalidate the timer
    [timer invalidate];
    
    // Display a message
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Pomodoro Stoped!"
                          message:@"You musn't stop a Pomodoro. No cookie for you!"
                          delegate:nil
                          cancelButtonTitle:@"OK :("
                          otherButtonTitles:nil];
    [alert show];
    
    // Set minutes to selected minite config
    minutes = minPomodoros;
    seconds = 0;
    
    // Update minutes and seconds labels
    minuteLabel.text = [NSString stringWithFormat:@"%i %i", (minutes / 10), minutes - (minutes / 10 * 10)];
    secondLabel.text = [NSString stringWithFormat:@"%i %i", (seconds / 10), seconds - (seconds / 10 * 10)];
    
    // Disable STOP button, and enable START button
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];
}

-(IBAction) doPomodoroSliderValueChanged:(UISlider *)sender {
    minPomodoros = (int)[sender value] / 5 * 5;
    pomodoroSettings.text = [NSString stringWithFormat:@"%d", minPomodoros];
}

-(IBAction)doPomodoroSliderButtonUp:(UISlider *)sender {
    minPomodoros = (int)[sender value] / 5 * 5;
    sender.value = minPomodoros;
}

-(IBAction) doIntervalSliderValueChanged:(UISlider *)sender {
    longBreakInterval = [sender value];
    intervalSettings.text = [NSString stringWithFormat:@"%d", longBreakInterval];
}

-(void)pomodoroComplete {
    // Invalidate the timer
    [timer invalidate];
    
    // Disable STOP button, and enable START button
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];

    totalPomodoros++;
    pomodorosCompleteLabel.text = [NSString stringWithFormat:@"%d", totalPomodoros];
    
    podomorosSoFar++;
    // Take a break message
    if ([breakTypeLabel.text isEqual: @"Short"]) {
        // Short break message
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Pomodoro Completed!"
                              message:@"You just completed a Pomodoro. You're awesome.\nGo for a SHORT BREAK!"
                              delegate:nil
                              cancelButtonTitle:@"OK :)"
                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        podomorosSoFar = 0;
        // Long break message
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Pomodoro Completed!"
                              message:@"You just completed a Pomodoro. Gret job!\nYou deserve a LONG BREAK!"
                              delegate:nil
                              cancelButtonTitle:@"OK :)"
                              otherButtonTitles:nil];
        [alert show];
    }
}

@end
