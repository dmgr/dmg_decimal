# Decimal data type

## Introduction

This library aids one in handling decimals. It is very similar to how SQL decimal data type works.
See the example below. See a spec file for more examples.

## Example

``` ruby
require 'dmg_decimal'

decimal = Dmg::Decimal.real("123.456", :scale => 2)
decimal.to_s('F') #=> "123.46"

decimal = Dmg::Decimal.pips(123456, :scale => 2)
decimal.to_s('F') #=> "1234.56"

decimal = Dmg::Decimal.real("123.456", :precision => 2)
decimal.to_s('F') #=> "120.0"
(decimal * 2).to
```