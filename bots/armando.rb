require_relative 'predictor'

class Armando < RTanque::Bot::Brain
  NAME = 'Armando'
  include RTanque::Bot::BrainHelper
  include Math
  ONE_DEGREE = RTanque::Heading::ONE_DEGREE

  def tick!
    tick_predictor

    buscar_enemigos

    enemigos do |enemigo|
      @predictor.process_info enemigo
      @aim_lock = enemigo
      command.radar_heading = enemigo.heading
    end

    disparar
#    maniobras_evasivas

    clean_variables
  end

  def tick_predictor
    @predictor ||= Predictor.new(self)
    @predictor.tick
  end

  def maniobras_evasivas
    if @aim_lock and @aim_lock.distance > 50
      command.heading = @aim_lock.heading + PI
    else
      command.heading = sensors.heading + ONE_DEGREE * 1.5
    end
    command.speed = 3
  end

  def disparar
    @predictor.predict_heading do |predicted_heading|
      command.turret_heading = predicted_heading
      if sensors.turret_heading.delta(predicted_heading).abs < 0.05
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
