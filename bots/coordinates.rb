class Coordinates < RTanque::Point
  def initialize x, y
    super
  end

  def +(coord)
    Coordinates.new(x + coord.x, y + coord.y)
  end

  def self.new_from_polars angle, radius
    angle -= Math::PI/2
    angle *= -1
    self.new(radius * Math.cos(angle), radius * Math.sin(angle))
  end
end
