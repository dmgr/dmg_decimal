require File.join(File.dirname(__FILE__), '..', 'lib', 'dmg_decimal')

include Dmg

describe Decimal do
  it "should parse real amount" do
    m = Decimal.real 123.45, scale: 2
    m.to_s('F').should == "123.45"

    m = Decimal.real "123.45", scale: 2
    m.to_s('F').should == "123.45"
  end

  it "should parse pips amount" do
    m = Decimal.pips 12345, scale: 2
    m.to_s('F').should == "123.45"
  end

  it "should round up from 0.03 to 0.04" do
    m = Decimal.real 0.03, scale: 2

    a = m * 1.22
    b = m * Decimal.real(1.22, scale: 2)

    a.pips.should == 4
    a.should == b
  end

  it "should works" do
    [0, 0.01, 0.03, 0.04, 100, 1000, 10000.0, 100000, 8978778869].each do |n|
      m = Decimal.real n, scale: 2

      a = (m / Decimal.real(1.07, scale: 2) * Decimal.real(1.22, scale: 2))
      b = (m / 1.07 * 1.22)

      a.should == b
      (a.to_f - n / 1.07 * 1.22).abs.should <= 0.01
    end
  end

  it "should rounds properly" do
    Decimal.real(1.045, scale: 2).to_s('F').should == "1.05"
    Decimal.real(1.044, scale: 2).to_s('F').should == "1.04"
    
    res = Decimal.real("-123.6789", precision: 3, precision_approximation: :truncate)
    res.to_s('F').should == "-123.0"
    
    res = Decimal.real("-123.6789", precision: 3, precision_approximation: :round)
    res.to_s('F').should == "-124.0"
    
    res = Decimal.real("-123.6789", precision: 3, precision_approximation: :floor)
    res.to_s('F').should == "-124.0"
    
    res = Decimal.real("123.6789", precision: 3, precision_approximation: :ceil)
    res.to_s('F').should == "124.0"
  end

  it "should rescale" do
    m = Decimal.real 123.45, scale: 2

    a = m.rescale(3)
    a.pips.should == 123450

    a = m.rescale(2)
    a.pips.should == 12345

    b = m.rescale(1)
    b.pips.should == 1235

    b = m.rescale(0)
    b.pips.should == 123
  end

  it "should handle equality" do
    a = Decimal.real(123.45, scale: 2)
    b = Decimal.pips(12345, scale: 2)

    a.should == b
  end

  it "should compare other decimals" do
    a = Decimal.real(1, scale: 2)
    b = Decimal.real(2, scale: 2)

    a.should < b
  end

  it "should takes care about precision" do
    res = Decimal.real("12345.6789", scale: 2, precision: 3)
    res.to_s('F').should == "12300.0"

    res = Decimal.real("12399.0", scale: 2, precision: 3)
    res.pips.should == 1240000
    res.to_s('F').should == "12400.0"

    res = Decimal.real("-0.6789", scale: 2, precision: 3)
    res.to_s('F').should == "-0.68"
    
    res = Decimal.real("0.6789", scale: 99, precision: 3)
    res.to_s('F').should == "0.679"
  end
end