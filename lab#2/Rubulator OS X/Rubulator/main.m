//
//  main.m
//  Rubulator
//
//  Created by Roman on 03.23.13.
//  Copyright (c) 2013 Roman Roibu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
