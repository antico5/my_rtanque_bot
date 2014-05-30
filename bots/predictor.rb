require_relative 'enemy_info'
require_relative 'newton_calc'

class Predictor
  attr_accessor :ticks, :enemies, :bot

  def initialize bot
    @ticks = 0
    @enemies = {}
    @bot = bot
  end

  def predict_heading
    # do for only 1 robot
    return unless info = @enemies.values.last

    if info.headings.size <= 2
      yield info.headings.last
    else
      time = shell_time info.distances.last
      angle_degrees = NewtonCalc.cuadratic_approximation info.headings[-3..-1].map(&:to_degrees), time
      yield RTanque::Heading.new_from_degrees angle_degrees
    end
  end

  def process_info reflection
    info = enemy_info reflection
    info.process reflection
    info.last_updated = ticks
  end

  def tick
    @enemies.delete_if do |name,enemy_info|
      enemy_info.last_updated < @ticks
    end
    @ticks += 1
  end

  private

  def enemy_info reflection
    @enemies[reflection.name] ||= EnemyInfo.new(bot,reflection)
  end

  def shell_time distance
    shell_speed = fire_power*RTanque::Shell::SHELL_SPEED_FACTOR
    distance/shell_speed
  end

  def fire_power
    5
  end

  def position
    sensors.position
  end
end
