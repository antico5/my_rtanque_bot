require_relative 'coordinates'

class EnemyInfo
  attr_accessor :name, :headings, :distances, :last_updated, :bot, :coordinates

  def initialize bot, reflection
    @name = reflection.name
    @headings = []
    @distances = []
    @coordinates = []
    @last_updated = 0
    @bot = bot
  end

  def process reflection, ticks
    headings << reflection.heading
    distances << reflection.distance
    coordinates << enemy_coordinates(reflection)
    @last_updated = ticks
  end

  def enemy_coordinates reflection
    Coordinates.new_from_polars(reflection.heading.to_f, reflection.distance) + bot.sensors.position
  end
end
