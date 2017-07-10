require 'gosu'
require 'chipmunk'
require_relative 'heroi'

class Game < Gosu::Window
  # Definindo dimensões da janela
  WIDTH = 1280
  HEIGHT = 768
  # Definindo atrito e gravidade do espaco do jogo
  ATRITO = 0.90
  GRAVIDADE = 400.0
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = 'Knight'
    @level = :start
    @game_over = false
    # Criando espaco
    @espaco = CP::Space.new
    @background = 0
    # Atribuindo atrito e gravidade ao espaco.
    @espaco.damping = ATRITO
    @espaco.gravity = CP::Vec2.new(0.0, GRAVIDADE)
    # Cria o chão onde o heroi vai andar.
    @chao = Borda.new(self, WIDTH/2, HEIGHT - 25, WIDHT, 50)
    @parede_esquerda = Borda.new(self, -10, HEIGHT/2, 20, HEIGHT)
    @parede_direita = Borda.new(self, WIDTH + 10, HEIGHT/2, 20, HEIGHT)
    # self, quer dizer na janela principal
    # 70, 700 são as coordenadas iniciais onde o objeto será iniciado
    @player = Heroi.new(self, 70, 700)
  end
  def update
    unless @game_over
      10.times do
        @space.step(1.0/600)
      end
  end
  def draw
    @background.draw(0,0,0)
  end
end
