require 'gosu'
require 'chipmunk'
require_relative 'heroi'
require_relative 'borda'
require_relative 'lobsomen'

class Game < Gosu::Window
  # Definindo dimensões da janela
  WIDTH = 800
  HEIGHT = 600
  # Definindo atrito e gravidade do espaco do jogo
  ATRITO = 0.90
  GRAVIDADE = 1000.0
  attr_reader :espaco, :direita
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Paladin'
    @level = :start
    @game_over = false
    # Criando espaco
    @espaco = CP::Space.new
    @background = 0
    # Atribuindo atrito e gravidade ao espaco.
    @espaco.damping = ATRITO
    @espaco.gravity = CP::Vec2.new(0.0, GRAVIDADE)
    # Cria o chão onde o heroi vai andar.
    @chao = Borda.new(self, WIDTH/2, HEIGHT, WIDTH, 50)
    @parede_esquerda = Borda.new(self, -10, HEIGHT/2, 20, HEIGHT)
    @parede_direita = Borda.new(self, WIDTH + 10, HEIGHT/2, 20, HEIGHT)
    # self, quer dizer na janela principal
    # 70, 700 são as coordenadas iniciais onde o objeto será iniciado
    @jogador = Heroi.new(self, 70, 300)
    @lobsomen = Lobsomen.new(self, 300, 300)
    @direita = true
    @font = Gosu::Font.new(30)
  end
  def update
    unless @game_over
      10.times do
        @espaco.step(1.0/600)
      end
      @jogador.checar_pes([@chao,@lobsomen])
      if button_down?(Gosu::KbRight)
        @jogador.mover_direita
      elsif button_down?(Gosu::KbLeft)
        @jogador.mover_esquerda
      elsif button_down?(Gosu::KbRightShift)
        @jogador.ataque
        @lobsomen.atingido(true,@direita) if colisao(@jogador, @lobsomen)
      else
        @jogador.parado
      end
      @lobsomen.mover
      @jogador.recebeu_ataque(true,@lobsomen.direcao) if colisao(@lobsomen, @jogador)
    end
  end
  def draw
    @jogador.draw
    @lobsomen.draw
    @font.draw(@jogador.life.to_s, 20, 20, 2)
    @font.draw(@lobsomen.life.to_s, 700, 20, 2)
  end
  def button_down(id)
    if id == Gosu::KbSpace
      @jogador.pulo
    end
    if id == Gosu::KbQ
      close
    end
  end
  def colisao(jogador, monstro)
      distancia = Gosu.distance(monstro.retorne_x, monstro.retorne_y, jogador.retorne_x, jogador.retorne_y)
      if distancia < jogador.width/2 + monstro.width/2
        return true
      else
        return false
      end
  end
end

window = Game.new
window.show
