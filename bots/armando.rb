require_relative 'predictor'
require_relative 'maneuverer'

class Armando < RTanque::Bot::Brain

  include RTanque
  include Math
  include Bot::BrainHelper

  NAME = 'Armando'
  ONE_DEGREE = Heading::ONE_DEGREE

  def initialize params
    super
    @predictor ||= Predictor.new(self)
    @maneuverer ||= Maneuverer.new(self)
  end

  def tick!
    tick_predictor
    move_radar
    search_enemies do |enemy|
      @predictor.process_info enemy
      @aim_lock = enemy
    end
    shoot
    evade
  end

  def tick_predictor
    @predictor.tick
  end

  def evade
    @maneuverer.maneuver @aim_lock
  end

  def aim
    @predictor.predict_coordinates do |prediction|
      aiming_vector = prediction - sensors.position
      yield Heading.new(aiming_vector.angle)
    end
  end

  def shoot
    aim do |heading|
      command.turret_heading = heading
      angle_delta = sensors.turret_heading.delta(heading).abs
      if angle_delta < 0.05
        command.fire 5
      end
    end
  end

  def move_radar
    if @aim_lock
      command.radar_heading = @aim_lock.heading
    else
      command.radar_heading = sensors.radar_heading + ONE_DEGREE * 10
      command.turret_heading = sensors.radar_heading
    end
  end

  def search_enemies
    @aim_lock = nil
    sensors.radar.find {|r| yield r}
  end
end
