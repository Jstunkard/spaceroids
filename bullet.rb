#Bullet Class

class Bullet
  attr_accessor :angle
  attr_reader :x, :y, :image

#  IMAGES = "bullet.png"
  IMAGES = "missle.png"

  def initialize(window, player)
    src = IMAGES
    @image = Gosu::Image.new(window, "media/#{src}")
    @x = player.x
    @y = player.y
    @vel_x = 3
    @vel_y = 3
    @angle = player.angle
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.9)
    @vel_y += Gosu::offset_y(@angle, 0.9)
 
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= SCREEN_X
    @y %= SCREEN_Y
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def collided_with(rock)
    @x + @image.width/2  >= rock.x - rock.image.width/2  and \
    @x - @image.width/2  <= rock.x + rock.image.width/2  and \
    @y + @image.height/2 >= rock.y - rock.image.height/2 and \
    @y - @image.height/2 <= rock.y + rock.image.height/2
  end
  
  def draw
    @image.draw_rot(@x, @y, ZOrder::Bullet, @angle)
  end
end


