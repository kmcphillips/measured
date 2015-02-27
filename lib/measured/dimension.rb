class Measured::Dimension < Measured::Measurable

  conversion.base :meter, :metre, :meters, :metres, :m
  conversion.add :inch, :inches, :in, value: "0.0254 meter"
  conversion.add :foot, :feet, :ft, value: "0.3048 meter"
  conversion.add :yard, :yards, :yd, value: "0.9144 meter"
  conversion.add :centimeter, :centimetre, :centimeters, :centimetres, :cm, value: "0.01 meter"
  conversion.add :milliimeter, :milliimetre, :milliimeters, :milliimetres, :mm, value: "0.001 meter"

end
