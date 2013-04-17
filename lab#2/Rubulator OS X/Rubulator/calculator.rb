require 'mathn'
require 'singleton'

class CalculatorClass
  include Singleton

  def initialize
    @operator = ""
    @first_operand = ""
    @second_operand = ""
  end

  def add_digit(digit)
      if @operator.empty?
          @first_operand << digit.to_s if (@first_operand.size < 10)
      else
        @second_operand << digit.to_s if (@second_operand.size < 10)
      end
      @operator.empty? ? @first_operand : @second_operand
  end

  def add_operator(operator)
      eval_result unless @second_operand.empty?
      @operator = operator
  end

  def add_dot
      if @operator.empty?
        @first_operand << '0' if @first_operand.empty?
        @first_operand << '.' if (!@first_operand.include?('.'))&&(@first_operand.size < 9)
      else
        @second_operand << '0' if @second_operand.empty?
        @second_operand << '.' if (!@second_operand.include?('.'))&&(@second_operand.size < 9)
      end
  end
    
  def change_sgn
    if @operator.empty? && !@first_operand.empty?
      if @first_operand[0] == '-'
        @first_operand[0] = ''
      else
        @first_operand[0,0] = '-'
      end
    elsif !@second_operand.empty?
      if @second_operand[0] == '-'
        @second_operand[0] = ''
      else
        @second_operand[0,0] = '-'
      end
    end
    @operator.empty? ? @first_operand : @second_operand
  end
    
  def eval_2root
    eval_result unless @second_operand.empty?

    result = Math.sqrt(@first_operand.to_f)
    result = result.to_s[0...10].to_f if result > 10 ** 10 - 1
    result = result.round(10 - (result.to_s.split('.')[0].size))
    result = result.to_i if result.to_s.split('.')[1].to_i == 0

    @first_operand = result.to_s
  end

  def clear_all
    @operator = ''
    @first_operand = ''
    @second_operand = ''
  end

  def eval_result
    unless @operator.empty? || @second_operand.empty?

        result = @first_operand.to_f.__send__(@operator.to_sym, @second_operand.to_f)
        result = result.to_i.to_s[0...10].to_f if result.to_i.class == Bignum
        result = result.to_s[0...10].to_f if result > 10 ** 10 - 1
        result = result.round(10 - (result.to_s.split('.')[0].size))
        result = result.to_i if result.to_s.split('.')[1].to_i == 0

        @first_operand = result.to_s
        @second_operand = ''
        @operator = ''
    end
  end

  def display
    if @second_operand.empty?
      @first_operand.empty? ? '0' : @first_operand
    else
      @second_operand.empty? ? '0' : @second_operand
    end
  end
end


