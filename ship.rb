class Ship
  require 'game'
attr_reader :level

  def initialize(level)
    @level = level
    @status = false
  end

  def levelup
    @level += 1
  end

  def levelup_cost
    return 1000 if(@level == 0)
    return @level*200
  end

  def start_fishing
    @status = true if(@level > 0)
  end

  def finish_fishing
    return unless(@status)
    @status = false
    return Fish.new(Game::d6(@level*2))
  end


end