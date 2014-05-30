class EnemyInfo
  attr_accessor :name, :headings, :distances, :last_updated, :bot, :positions

  def initialize bot, reflection
    @name = reflection.name
    @headings = []
    @distances = []
    @last_updated = 0
    @bot = bot
  end

  def process reflection
    headings << reflection.heading
    distances << reflection.distance
  end
end
