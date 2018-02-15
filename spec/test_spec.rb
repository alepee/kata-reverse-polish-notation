require 'rspec'

class PolishNotationCalculator
  def initialize(formula)
    @formula = formula
  end

  def evaluate
    @formula.split.inject([]) { |acc, item|
      if item.match(/\d+/)
        acc.concat [Operand.new(item.to_i)]
      else
        operand = acc.last
        operand.send(item.to_sym, acc)
      end


    }.first.get_number
  end
end

class Operand
  def initialize(number)
    @number = number
  end

  def +(stack)
    other = stack[-2].get_number
    stack.pop(2)
    stack.concat [Operand.new(@number + other)]
  end

  def -(stack)
    other = stack[-2].get_number
    stack.pop(2)
    stack.concat [Operand.new(@number - other)]
  end

  def *(stack)
    other = stack[-2].get_number
    stack.pop(2)
    stack.concat [Operand.new(@number * other)]
  end

  def /(stack)
    other = stack[-2].get_number
    stack.pop(2)
    stack.concat [Operand.new(@number / other)]
  end

  def sqr(stack)
    stack.pop(1)
    stack.concat [Operand.new(@number ** 2)]
  end

  def get_number
    @number
  end
end

describe 'Reverse Polish Notation' do
  it 'will sum two values' do
    entry_value = '3 5 +'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 8
  end

  it 'will sum three values' do
    entry_value = '4 3 2 + +'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 9
  end

  it 'will sum two values with one negative value' do
    entry_value = '-50 5 +'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq -45
  end

  it 'will subtract two values' do
    entry_value = '5 2 -'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 3
  end

  it 'will sum and subtract three values' do
    entry_value = '5 2 - 7 +'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 10
  end

  it 'will sum and subtract three values' do
    entry_value = '5 2 - 0 +'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 3
  end

  it 'will evaluate a formula with multiple operators' do
    entry_value = '3 4 2 1 + * + 2 /'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 7.5
  end

  it 'will evaluate 5^2' do
    entry_value = '5 sqr'
    sut = PolishNotationCalculator.new(entry_value).evaluate

    expect(sut).to eq 25
  end
end
