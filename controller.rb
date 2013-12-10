class Controller
  attr_reader :x,:y,:mx,:my

  def initialize(game)
    @game = game
  end

  def input
    @mx = Input.mousePosX
    @my = Input.mousePosY
    if Input.mouse_push?( M_LBUTTON )
      case @game.state
      when :title
        @game.start if(pos_menu == 0)
        @game.rank_start if(pos_menu == 1)
        exit if(pos_menu == 2)
      when :game
        @game.sell_fish(pos_fish) if(pos_fish != -1)
        #@game.ship(pos_ship) if(pos_ship != -1)
        @game.alt_ship(pos_ship_alt) if(pos_ship_alt != -1)
      when :ranking
        @game.go_title if(pos_return)
      when :end
        @game.next if(pos_return)
      end
    end
    if(Input.key_push?(K_Z))
      case @game.state
      when :game
        @game.sell_all_fish
      end
    end
    if(Input.key_push?(K_SPACE))
      case @game.state
      when :game
        @game.toggle_pause
      end
    end
    if(Input.key_push?(K_ESCAPE))
      exit
    end
  end

  def pos_menu
    3.times do |i|
      return i if(mcheck(MENU_X, MENU_X+Font32.get_width(MENU_TEXT[i]), MENU_Y[i], MENU_Y[i]+32))
    end
    return -1
  end

  def pos_fish
    @game.fishes.size.times do |i|
      return i if(mcheck(WAREHOUSE_X,WAREHOUSE_X+100,FISH_Y+i*20,FISH_Y+20+i*20))
    end
    return -1
  end

  def pos_ship
    4.times do |i|
      return i if(mcheck(SHIPS_X[i],SHIPS_X[i]+100,SHIPS_Y,SHIPS_Y+100))
    end
    return -1
  end

  def pos_ship_alt
    4.times do |i|
      return i if(mcheck(SHIPS_X[i],SHIPS_X[i]+100,SHIPS_ALT_Y,SHIPS_ALT_Y+30))
    end
    return -1
  end

  def pos_return
    mcheck(250,250+Font20.get_width("戻る"),400,420)
  end

  def mcheck(x1,x2,y1,y2)
    x1 < @mx && x2 > @mx && y1 < @my && y2 > @my
  end
end