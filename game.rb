require 'rubygems'
require 'gosu'
require_relative 'player'
require_relative 'rock'
require_relative 'bullet'


SCREEN_X = 640 * 2
SCREEN_Y = 480 * 2

module ZOrder
  Background, Rock, Bullet, Player, UI = *0..4
end

class GameWindow < Gosu::Window
  def initialize
    super(SCREEN_X, SCREEN_Y, false)
    self.caption = "Asteroids"
    @max = 2
    @background_image = Gosu::Image.new(self, "media/Space.png", true)
    
    @player = Player.new(self)
    @level = 0
    level
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def level
    @level += 1
    @max += 1
    
    @player.warp(320, 240)

    @rocks = (1..@max).map { Rock.new(self, @player) }
    @bullets = []
  end


  def update

    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    
    if @do_warp
      @player.warp(rand(SCREEN_X), rand(SCREEN_Y))
      @do_warp = false
    end
    
    @player.move
    @rocks.each do |rock|
      rock.move

      if rock.collided_with(@player)

        if @player.life >= 1
          @rocks.delete(rock)
          @player.life -= 1
          @rocks.push(Rock.new(self, @player))
        else 
          @player.life = 0
          @gameover = true
        end
      end

      @bullets.each do |bullet| 

        if bullet and rock.collided_with(bullet)
          #          if rock is big break it up
          #          if this
          @rocks.delete(rock)
          @bullets.delete(bullet)
          @player.score += 10
#          @rocks.push(Rock.new(self, @player))
          children = rock.explode
          @rocks += children
        end
      end
      if @rocks.empty?
        level
      end
    end 
  end
  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @rocks.each { |r| r.draw }

    @bullets.each do |bullet|  
#      @bullet.each { |b| b.draw }

      bullet.draw
      bullet.accelerate
      bullet.move
    end
    
    @font.draw("Lives Remaining: #{@player.life}", 10, 25, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)

    
    if @gameover
      @font.draw("#{@player.gameover}", 320, 240, ZOrder::UI, 1.0, 1.0, 0xffffff00)
      @rocks = []
      @bullet = nil 
     # TODO 
      # Go to start menu
    end

  
  end
  
  def button_up(id)
    if id == Gosu::KbR then
      @bullets << Bullet.new(self, @player)
    end
  end
    
  def button_down(id)
    if id == Gosu::KbEscape then
      close
    elsif id == Gosu::KbSpace
      @do_warp = true
    end
  end

  def start_menu
    @background_image.draw(0,0, ZOrder::Background)
    @player.draw

    @menu.draw


  end

end


window = GameWindow.new
window.show
