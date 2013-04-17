#
#  AppDelegate.rb
#  Rubulator
#
#  Created by Roman on 03.23.13.
#  Copyright 2013 Roman Roibu. All rights reserved.
#

class AppDelegate
    attr_accessor :window
    attr_accessor :display

    
    @@operator_hash = {
    'add' => '+',
    'sub' => '-',
    'mul' => '*',
    'div' => '/',
    'pow' => '**'
    }
    
    def applicationDidFinishLaunching(a_notification)
        @calculator = CalculatorClass.instance
        @calculator.clear_all
    end
    
    def doNumberBtn(sender)
        display.setStringValue (@calculator.add_digit(sender.title))
    end
    
    def doDotBtn(sender)
        @calculator.add_dot
        display.setStringValue @calculator.display
    end
    
    def doSignBtn(sender)
        @calculator.change_sgn
        display.setStringValue @calculator.display
    end
    
    def doOperatorBtn(sender)
        if %w[add sub mul div pow].include? sender.alternateTitle
            @calculator.add_operator @@operator_hash[sender.alternateTitle]
        elsif sender.alternateTitle == 'srt'
            @calculator.eval_2root
        end
        display.setStringValue @calculator.display
    end
    
    def doEqualBtn(sender)
        @calculator.eval_result
        display.setStringValue @calculator.display
    end
    
    def doClearBtn(sender)
        @calculator.clear_all
        display.setStringValue @calculator.display
    end
    
    def doFunctionBtn(sender)
        graph = CPXYGraph.alloc.initWithFrame(CGRectMake(0,0,0,0))
    end

end

