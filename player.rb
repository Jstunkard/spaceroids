# Player Class

class Player
  attr_reader :x, :y, :angle, :image, :gameover
  attr_accessor :life, :score

  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @beep = Gosu::Sample.new(window, "media/Beep.wav")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
    @life = 10
    @gameover = "Game Over"
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
    if @angle <= -365
      @angle += 365
    end

  end
  
  def turn_right
    @angle += 4.5
    if @angle >= 365
      @angle -= 365
    end

  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= SCREEN_X
    @y %= SCREEN_Y
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, @angle)
  end
  
end


