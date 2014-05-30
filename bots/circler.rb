class Circler < RTanque::Bot::Brain
  NAME = 'circler'
  include RTanque::Bot::BrainHelper
  ONE_DEGREE = RTanque::Heading::ONE_DEGREE

  def tick!
    @factor ||= rand + 0.5
    command.heading = sensors.heading + ONE_DEGREE * @factor
    command.speed = 3
  end
end
