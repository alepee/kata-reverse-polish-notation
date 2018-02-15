require 'rspec'

module PolishNotationCalculator
  def self.evaluate(formula)
    formula.split.inject([]) { |acc, item|
      if item.match(/\d+/)
        acc.push(item.to_i)
      else
        numbers = acc.pop(2)
        operator = item.to_sym

        left = numbers[0]
        right = operator == :/ ? numbers[1] : numbers[1].to_f

        acc.push left.send(operator, right)
      end

      acc
    }.first
  end
end


describe 'Reverse Polish Notation' do
  it 'will sum two values' do
    entry_value = '3 5 +'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 8
  end

  it 'will sum three values' do
    entry_value = '4 3 2 + +'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 9
  end

  it 'will sum two values with one negative value' do
    entry_value = '-50 5 +'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq -45
  end

  it 'will subtract two values' do
    entry_value = '5 2 -'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 3
  end

  it 'will sum and subtract three values' do
    entry_value = '5 2 - 7 +'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 10
  end

  it 'will sum and subtract three values' do
    entry_value = '5 2 - 0 +'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 3
  end

  it 'will divide two values' do
    entry_value = '6 2 /'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 3
  end

  it 'will raise ZeroDivisionError exception' do
    entry_value = '6 0 /'
    sut = -> { PolishNotationCalculator.evaluate(entry_value) }

    expect(sut).to raise_error(ZeroDivisionError)
  end

  it 'will ' do
    entry_value = '3 4 2 1 + * + 2 /'
    sut = PolishNotationCalculator.evaluate(entry_value)

    expect(sut).to eq 7.5
  end
end
