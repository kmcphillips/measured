# Measured

Encapsulates weights and dimensions with their units. Provides easy conversion between units.

Light weight and easily extensible to include other units and conversions. Conversions done with `BigDecimal` for precision.

## Installation

Using bundler, add to the Gemfile:

```ruby
gem 'measured'
```

Or stand alone:

    $ gem install measured

## Usage

Initialize a measurment:

```ruby
Measured::Weight.new("12", "g")
```

Convert to return a new measurment:

```ruby
Measured::Weight.new("12", "g").convert_to("kg")
```

Or convert inline:

```ruby
Measured::Weight.new("12", "g").convert_to!("kg")
```

Agnostic to symbols/strings:

```ruby
Measured::Weight.new(1, "kg") == Measured::Weight.new(1, :kg)
```

Seamlessly handles aliases:

```ruby
Measured::Weight.new(12, :oz) == Measured::Weight.new("12", :ounce)
```

Raises on unknown units:

```ruby
begin
  Measured::Weight.new(1, :stone)
rescue Measured::UnitError
  puts "Unknown unit"
end
```

Perform mathematical operations against other units, all represented internally as `BigDecimal`:

```ruby
Measured::Weight.new(1, :g) + Measured::Weight.new(2, :g)
> #<Measured::Weight 3 g>
Measured::Weight.new(2, :g) - Measured::Weight.new(1, :g)
> #<Measured::Weight 1 g>
Measured::Weight.new(10, :g) / Measured::Weight.new(2, :g)
> #<Measured::Weight 5 g>
Measured::Weight.new(2, :g) * Measured::Weight.new(3, :g)
> #<Measured::Weight 6 g>
```

In cases of differeing units, the left hand side takes precedence:

```ruby
Measured::Weight.new(1000, :g) + Measured::Weight.new(1, :kg)
> #<Measured::Weight 2000 g>
```

Also perform mathematical operations against `Numeric` things:

```ruby
Measured::Weight.new(3, :g) * 2
> #<Measured::Weight 6 g>
```

Extract the unit and the value:

```ruby
weight = Measured::Weight.new("1.2", "grams")
weight.value
> #<BigDecimal 1.2>
weight.unit
> "g"
```

See all valid units:

```ruby
Measured::Weight.units
> ["g", "kg", "lb", "oz"]
```

See all valid units with their aliases:

```ruby
Measured::Weight.units_with_aliases
> ["g", "gram", "grams", "kg", "kilogram", "kilograms", "lb", "lbs", "ounce", "ounces", "oz", "pound", "pounds"]
```

## Units and conversions

### Bundled unit conversion

* `Measured::Weight`
  * g, gram, grams
  * kg, kilogram, kilograms
  * lb, lbs, pound, pounds
  * oz, ounce, ounces
* `Measured::Dimension`
  * m, meter, metre, meters, metres
  * cm, centimeter, centimetre, centimeters, centimetres
  * mm, milliimeter, milliimetre, milliimeters, milliimetres
  * in, inch, inches
  * ft, foot, feet
  * yd, yard, yards

You can skip these and only define your own units by doing:

```ruby
gem 'measured', require: 'measured/base'
```

### Adding new units

Extending this library to support other untis is simple. To add a new conversion, subclass `Measured::Measurable`, define your base units, then add your conversion units.

```ruby
class Measured::Thing < Measured::Measurable
  conversion.set_base :base_unit,
    aliases: [:bu]

  conversion.add :another_unit,
    aliases: [:au],
    value: ["1.5 base_unit"]

  conversion.add :different_unit
    aliases: [:du],
    value: [Rational(2/3), "another_unit"]
end
```

The base unit takes no value. Values for conversion units can be defined as a string with two tokens `"number unit"` or as an array with two elements. The numbers must be `Rational` or `BigDecimal`, else they will be coerced to `BigDecimal`. Conversion paths don't have to be direct as a conversion table will be built for all possible conversions using tree traversal.

You can also open up the existing classes and add a new conversion:

```ruby
class Measured::Dimension
  conversion.add :dm,
    aliases: [:deciimeter, :deciimetre, :deciimeters, :deciimetres],
    value: "0.1 m"
end
```

### Namespaces

All units and classes are namespaced by default, but can be aliased in your application.

```ruby
Weight = Measured::Weight
Dimension = Measured::Dimension
```

## Alternatives

Exiting alternatives which were considered:

### Gem: [ruby-units](https://github.com/olbrich/ruby-units)
* **Pros**
  * Accurate math and conversion factors.
  * Includes nearly every unit you could ask for.
* **Cons**
  * Opens up and modifies `Array`, `Date`, `Fixnum`, `Math`, `Numeric`, `String`, `Time`, and `Object`, then depends on those changes internally.
  * Lots of code to solve a relatively simple problem.
  * No ActiveRecord adapter.

### Gem: [quantified](https://github.com/Shopify/quantified)
* **Pros**
  * Light weight.
  * Included with ActiveShipping/ActiveUtils.
* **Cons**
  * All math done with floats making it highly lossy.
  * All units assumed to be pluralized, meaning using unit abbreviations is not possible.
  * Not actively maintained.
  * No ActiveRecord adapter.

## Contributing

1. Fork it ( https://github.com/kmcphillips/measured/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Authors

[Kevin McPhillips](https://github.com/kmcphillips)
