//
//  PDViewController.h
//  Pomodoro
//
//  Created by Roman on 04.18.13.
//  Copyright (c) 2013 Roman Roibu. All rights reserved.
//

#import <UIKit/UIKit.h>

// Set defaults
int longBreakInterval = 4;
int minPomodoros = 25;
int podomorosSoFar = 0;
int totalPomodoros = 0;
//BOOL timerRunning = NO;

// Set timer variables
int minutes;
int seconds;


@interface PDViewController : UIViewController {
    NSTimer *timer;
    
    BOOL menuOpen;
    IBOutlet UIView *mainView;

    IBOutlet UIButton *startButton;
    IBOutlet UIButton *stopButton;

    IBOutlet UILabel *minuteLabel;
    IBOutlet UILabel *secondLabel;
    
    IBOutlet UILabel *pomodorosCompleteLabel;
    IBOutlet UILabel *breakTypeLabel;
    
    IBOutlet UILabel *pomodoroSettings;
    IBOutlet UILabel *intervalSettings;
}

@property(nonatomic, retain) UIView *mainView;

// Show/hide settings view
-(IBAction)settingsTapped:(id) sender;

// Press START/STOP button
-(IBAction)doStartPomodoro :(id)sender;
-(IBAction)doStopPomodoro:(id)sender;

// Slider value was changed
- (IBAction) doPomodoroSliderValueChanged:(id)sender;
- (IBAction) doIntervalSliderValueChanged:(id)sender;
- (IBAction) doPomodoroSliderButtonUp:(id)sender;

// Contdown function
-(void)countdown;

// Called when a pomodoro is complete
-(void)pomodoroComplete;

@end
