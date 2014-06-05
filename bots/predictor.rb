require_relative 'enemy_info'
require_relative 'newton_calc'

class Predictor
  attr_accessor :ticks, :enemies, :bot

  def initialize bot
    @ticks = 0
    @enemies = {}
    @bot = bot
  end

  def predict_coordinates &b
    pick_enemy do |info|
      time = shell_time info.distances.last
      yield NewtonCalc.cuadratic_approximation [-2,-1,0], info.coordinates[-3..-1], time
    end
  end

  def process_info reflection
    info = enemy_info reflection
    info.process reflection, ticks
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

  def pick_enemy &b
    info = @enemies.values.last #designed for only 1 enemy, so get the last EnemyInfo
    yield info if info and info.coordinates.count >= 3 # need at least 3 observations to make a cuadratic approx.
  end
end
