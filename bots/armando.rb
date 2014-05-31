require_relative 'predictor'
require_relative 'maneuverer'

class Armando < RTanque::Bot::Brain

  include RTanque
  include Math
  include Bot::BrainHelper

  NAME = 'Armando'
  ONE_DEGREE = Heading::ONE_DEGREE

  def tick!
    tick_predictor
    buscar_enemigos
    enemigos do |enemigo|
      @predictor.process_info enemigo
      @aim_lock = enemigo
      command.radar_heading = enemigo.heading
    end
    disparar
    maniobras_evasivas
    clean_variables
  end

  def tick_predictor
    @predictor ||= Predictor.new(self)
    @predictor.tick
  end

  def maniobras_evasivas
    @maneuverer ||= Maneuverer.new(self)
    @maneuverer.maneuver @aim_lock
  end

  def disparar
    @predictor.predict_coordinates do |prediction|
      aiming_vector = prediction - sensors.position
      desired_heading = Heading.new(aiming_vector.angle)
      command.turret_heading = desired_heading
      angle_delta = sensors.turret_heading.delta(desired_heading).abs
      if angle_delta < 0.05
        command.fire 5
      end
    end
  end

  def buscar_enemigos
    command.radar_heading = sensors.radar_heading + ONE_DEGREE * 10 unless @aim_lock
    command.turret_heading = sensors.radar_heading
  end

  def enemigos
    sensors.radar.find {|r| yield r}
  end

  def clean_variables
    @aim_lock = nil
  end

end
