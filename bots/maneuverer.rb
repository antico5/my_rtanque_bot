require_relative 'coordinates'

class Maneuverer
  include Math
  include RTanque

  MAX_ROTATION = RTanque::Heading::ONE_DEGREE * 1.5
  MAX_SPEED = 3

  DIRECTION_CHANGE_INTERVAL = 20
  DESTINATION_CHANGE_INTERVAL = 120

  attr_accessor :bot

  def initialize bot
    @bot = bot
    @last_changed_destination = -9999
    @last_changed_direction = -9999
    @direction_modifier = 0
    @destination = Coordinates.new(0,0)
  end

  def maneuver enemy = nil
      generate_destination if should_change_destination?
      zigzag_direction if should_change_direction?
      command.heading = direction
      command.speed = MAX_SPEED
  end

  private

  def direction
    base_direction + @direction_modifier
  end

  def base_direction
    Heading.new((@destination - sensors.position).angle)
  end

  def sensors
    bot.sensors
  end

  def command
    bot.command
  end

  def zigzag_direction
    @cycler ||= [-1,2].cycle
    @direction_modifier = ((rand) * PI/8) * @cycler.next
  end

  def generate_destination
    width = bot.arena.width
    height = bot.arena.height
    @destination = Coordinates.new(rand * width, rand * height)
    while distance_to_destination < 500 do
      @destination = Coordinates.new(rand * width, rand * height)
    end
    puts "New destination: #{@destination.to_s}"
    puts distance_to_destination
  end

  def distance_to_destination
    (@destination - sensors.position).modulus
  end

  def should_change_direction?
    if sensors.ticks - @last_changed_direction > DIRECTION_CHANGE_INTERVAL
      @last_changed_direction = sensors.ticks
    end
  end

  def should_change_destination?
    if sensors.ticks - @last_changed_destination > DESTINATION_CHANGE_INTERVAL
      @last_changed_destination = sensors.ticks
    end
  end

end
