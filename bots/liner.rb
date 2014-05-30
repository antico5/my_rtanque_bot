class Liner < RTanque::Bot::Brain
  NAME = 'liner'
  include RTanque::Bot::BrainHelper
  ONE_DEGREE = RTanque::Heading::ONE_DEGREE

  def tick!
    command.speed = @speed ? @speed : 3
    command.heading = 0
    y = sensors.position.y
    if y > 600
      @speed = -3
    elsif y < 100
      @speed = 3
    end
  end
end
