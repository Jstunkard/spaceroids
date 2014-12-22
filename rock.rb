# Rock Class

class Rock
  attr_reader :vel_x, :vel_y
  IMAGES = (1..7).map { |i| "rock#{i}.png" }
  def initialize(window, player, x = nil, y = nil, vel_x = nil, vel_y = nil, scale = nil, angle = 1)
    src = IMAGES[rand(IMAGES.length)]
    @window = window
    @player = player
    @angle = angle
    @image = Gosu::Image.new(@window, "media/#{src}")

    if x and y and vel_x and vel_y 
      @x = x
      @y = y
      @vel_x = vel_x
      @vel_y = vel_y
      @scale = scale
    else 
      randomize(@player)
    end 
  end

  def randomize(player)
    @magnitude = 2
    @angle = rand(360)
    @vel_angle = (rand(200) - 100) / 100.0

    @vel_x = Gosu::offset_x(@angle, @magnitude)
    @vel_y = Gosu::offset_y(@angle, @magnitude)

    @scale = 2
    begin 
      @x = rand(SCREEN_X)
      @y = rand(SCREEN_Y)
    end while collided_with(player)
 
 
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= SCREEN_X
    @y %= SCREEN_Y
  end

  def collided_with(object)
    @x + @image.width*@scale/2  >= object.x - object.image.width*@scale/2  and \
    @x - @image.width*@scale/2  <= object.x + object.image.width*@scale/2  and \
    @y + @image.height*@scale/2 >= object.y - object.image.height*@scale/2 and \
    @y - @image.height*@scale/2 <= object.y + object.image.height*@scale/2
  end

  def explode
    if @scale == 2
      @scale = 1
      angle_1 = @angle + 45
      angle_2 = @angle - 45
      vel_x1 = Gosu::offset_x(angle_1, @magnitude)
      vel_y1 = Gosu::offset_y(angle_1, @magnitude)

      vel_x2 = Gosu::offset_x(angle_2, @magnitude)
      vel_y2 = Gosu::offset_y(angle_2, @magnitude)

      [Rock.new(@window, @player, @x , @y, vel_x1, vel_y1, @scale, angle_1), Rock.new(@window, @player, @x , @y, vel_x2, vel_y2, @scale, angle_2)]

    else
      []
    end


  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Rock, @angle, 0.5, 0.5, @scale, @scale)
  end
end

