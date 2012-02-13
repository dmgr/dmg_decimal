# Decimal data type

## Introduction

This library aids one in handling decimals. It is very similar to how SQL decimal data type works.
See the example below.

## Example

``` ruby
require 'dmg_decimal'

decimal = Dmg::Decimal.real("123.456", :scale => 2)
decimal.to_s('F') #=> "123.46"

decimal = Dmg::Decimal.pips(123456, :scale => 2)
decimal.to_s('F') #=> "1234.56"

decimal = Dmg::Decimal.real(123.456, :precision => 2)
decimal.to_s('F') #=> "120.0"

# some math
(decimal * 2).to_s('F') # => "240.0"

# all options example
%w[round truncate ceil floor].each do |approximation|
  number = 123.456
  
  decimal = Dmg::Decimal.real(number, 
    :scale => 2,
    :scale_approximation => approximation)

  puts "#{ number } approximated to 2 decimal places using #{ approximation } approximation is #{ decimal.to_s('F') }"
end

# 123.456 approximated to 2 decimal places using round approximation is 123.46
# 123.456 approximated to 2 decimal places using truncate approximation is 123.45
# 123.456 approximated to 2 decimal places using ceil approximation is 123.46
# 123.456 approximated to 2 decimal places using floor approximation is 123.45
```

See a spec file for more examples.