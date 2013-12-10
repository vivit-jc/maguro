class Game
  require 'fish'
  require 'ship'
  attr_reader :state,:money,:rate,:pause,:ranking,:new_rank,:score

  def initialize
    @state = :title
    @time = 0
    @money = 600
    @rate = 10
    @ranking = load_ranking
    @pause = true
    @ships = [Ship.new(1),Ship.new(0),Ship.new(0),Ship.new(0)]
    @fishes = []
  end

  def load_ranking
    File.open("rank.dat","w"){} unless(File.exist?("rank.dat"))
    array = []
    open("rank.dat") do |f|
      while l = f.gets
        array.push l.to_i
      end
    end
    array
  end

  def save_ranking
    File.open("rank.dat","w") do |f|
      @ranking.each{|r| f.write(r.to_s+"\n")}
    end
  end

  def toggle_pause
    @pause = !@pause
  end

  def start
    @state = :game
  end

  def rank_start
    @state = :ranking
  end

  def go_title
    @state = :title
  end

  def next
    @state = :next
  end

  def clock
    return if(@pause)
    hour = self.hour
    @time += 1
    timecount if(hour != self.hour)
  end

  def hour
    (@time/FRAME)%24
  end

  def day
    @time/(FRAME*24)+1
  end

  def timecount
    ending if(day == END_DAY)
    @rate += d6(2)-7 if(inbusiness?)
    @rate = 1 if(@rate < 1)
    @fishes.each do |f|
      f.rot
      @money -= f.amount*10 if(f.limit == 0)
    end
    @fishes.reject!{|f|f.limit == 0}
    @ships.each{|f|f.start_fishing} if(hour == 6)
    if(hour == 18)
      get_fish = @ships.map{|s| s.finish_fishing }
      get_fish.each{|f|@fishes.push(f) if(f)}
    end
  end

  def inbusiness?
    self.hour >= 11 && self.hour <= 15
  end

  def infishing?
    self.hour >= 6 && self.hour <= 18
  end

  def fishes
    @fishes
  end

  def ships
    @ships
  end

  def ending
    @state = :end
    @ranking.push @money
    del = @ranking.sort.reverse.pop if(@ranking.size > 5)
    @new_rank = true if(del != @money)
    @score = @money
    @ranking = @ranking.sort!.reverse![0..4]
    save_ranking
  end

  def sell_fish(n)
    return unless(inbusiness?)
    fish = @fishes.delete_at(n)
    @money += fish.amount*@rate
  end

  def sell_all_fish
    return unless(inbusiness?)
    fish = @fishes.inject(0){|sum,f|sum+f.amount}
    @money += fish*@rate
    @fishes.clear
  end

  def alt_ship(n)
    return if(@money < @ships[n].levelup_cost)
    return if(inbusiness?)
    @money -= @ships[n].levelup_cost
    @ships[n].levelup
  end

  def d6(n)
    Game.d6(n)
  end

  def self.d6(n)
    n.times.inject(0){|sum|sum+rand(6)+1}
  end
end