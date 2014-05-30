require 'rtanque'

class Coordinates < RTanque::Point
  def initialize x, y
    super(x.to_f, y.to_f)
  end

  def +(coord)
    Coordinates.new(x + coord.x, y + coord.y)
  end

  def -(coord)
    Coordinates.new(x - coord.x, y - coord.y)
  end

  def *(number)
    Coordinates.new(x * number, y * number)
  end

  def /(number)
    Coordinates.new(x/number, y/number)
  end

  def angle
    Math.atan2(x,y)
  end

  def self.new_from_polars angle, radius
    angle -= Math::PI/2
    angle *= -1
    self.new(radius * Math.cos(angle), radius * Math.sin(angle))
  end
end
