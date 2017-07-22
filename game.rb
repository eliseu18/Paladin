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
      if button_down?(Gosu::KbRight)
        @jogador.update("direita",@lobsomen,@chao)
      elsif button_down?(Gosu::KbLeft)
        @jogador.update("esquerda",@lobsomen,@chao)
      elsif button_down?(Gosu::KbRightShift)
        @jogador.update("ataque",@lobsomen,@chao)
      else
        @jogador.update("parado",@lobsomen,@chao)
      end
      @lobsomen.update
    end
  end
  def draw
    # Desenha o jogador, o monstro e as fontes.
    @jogador.draw
    if !@lobsomen.checar_morte
      @lobsomen.draw
    end
    @font.draw(@jogador.life.to_s, 20, 20, 2)
    @font.draw(@lobsomen.life.to_s, 700, 20, 2)
  end
  # Quando o botão pulo é apertado essa função é chamada. A diferença do Metodo
  # acima é que a acao desse so acontece uma vez por apertar de botao.
  def button_down(id)
    if id == Gosu::KbSpace
      @jogador.pulo
    end
    if id == Gosu::KbQ
      close
    end
  end
end

window = Game.new
window.show
