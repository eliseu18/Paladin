class Heroi
  # Define constantes, aqui estao os valores das forças aplicadas a cada ação
  IMPULSO_CORRIDA = 600
  IMPULSO_NO_AR = 60
  IMPULSO_PULO = 36000
  IMPULSO_PULO_AR = 1200
  LIMITE_CORRIDA = 400
  FRICCAO = 0.7
  ELASTICIDADE = 0.2
  attr_accessor :no_ar, :width, :corpo
  def initialize(window, x, y)
    @window = window
    espaco = window.espaco
    @imagens = Gosu::Image.load_tiles('./imagens/esqueleto.png', 90, 100)
    @ataque = Gosu::Image.load_tiles('./imagens/ataque_esqueleto.png', 100, 101)
    @width = 100
    # Cria o corpo e suas dimensoes
    @corpo = CP::Body.new(50, 100 /0.0)
    # Define a localização do corpo
    @corpo.p = CP::Vec2.new(x, y)
    @corpo.v_limit = LIMITE_CORRIDA
    # Define os limites do corpo do heroi
    limites = [CP::Vec2.new(-22.1, -37.4),
                CP::Vec2.new(-35.6, -17.4),
                CP::Vec2.new(-42.4, 9.2),
                CP::Vec2.new(-43.2, 19.1),
                CP::Vec2.new(-4.1, 48.1),
                CP::Vec2.new(37.2, 48),
                CP::Vec2.new(35, 10.4),
                CP::Vec2.new(2.8, -38.4),
                CP::Vec2.new(-21.1, -37.5)]
    forma = CP::Shape::Poly.new(@corpo, limites, CP::Vec2.new(0,0))
    forma.u = FRICCAO
    forma.e = ELASTICIDADE
    espaco.add_body(@corpo)
    espaco.add_shape(forma)
    # Variavel para definir a ação do heroi a cada tempo.
    @acao = :parado_direita
    @imagem_index = 0
    @ataque_index = 0
    @ataque_fim =
    # Variavel para verificar se o personagem esta no ar.
    @no_ar = true
    @direita = window.direita
    @life = 100
  end
  # Metodo que desenha o heroi dependendo da acao dele
  def draw
    case @acao
    when :corre_direita
      @imagens[Gosu.milliseconds / 100 % @imagens.size].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
      ##@imagem_index = (@imagem_index + 0.2) % 3
      @direita = true
    when :parado_direita, :pula_direita
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
      @direita = true
    when :corre_esquerda
      @imagens[Gosu.milliseconds / 100 % @imagens.size].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
      ##@imagem_index = (@imagem_index + 0.2) % 3
      @direita = false
    when :pula_esquerda
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
      @direita = false
    when :ataque_direita
        @ataque[Gosu.milliseconds / 100 % @ataque.size].draw_rot(@corpo.p.x,@corpo.p.y, 2,0, 0.5, 0.5, -1, 1)
        @ataque_index = (@imagem_index - 0.05) % 3
        @direita = true
    when :ataque_esquerda
      @ataque[Gosu.milliseconds / 100 % @ataque.size].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
        @direita = false
    else
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
    end
  end
  # Metodo que calcula a distancia entre o corpo e um objeto e retorna se estao
  # tocando ou não (true ou false)
  def tocando?(pes)
    x_diff = (@corpo.p.x - pes.corpo.p.x).abs
    y_diff = (@corpo.p.y + 50 - pes.corpo.p.y).abs
    x_diff < 12 + pes.width/2 and y_diff < 5 + pes.height / 2
  end
  # Metodo que verifica cada objeto se ele esta tocando o heroi.
  def checar_pes(objetos)
    @no_ar = true
    objetos.each do |objeto|
      @no_ar = false if tocando?(objeto)
    end
  end
  # metodo para mover o personagem a direita
  # verifica se ele esta no ar, se sim ele move o heroi de acordo com a constantes
  # IMPULSO_NO_AR, caso contrario promove um impulso de acordo com a constante
  # IMPULSO_CORRIDA
  def mover_direita
    if @no_ar
      @acao = :pula_direita
      @corpo.apply_impulse(CP::Vec2.new(IMPULSO_NO_AR, 0), CP::Vec2.new(0,0))
    else
      @acao = :corre_direita
      @corpo.apply_impulse(CP::Vec2.new(IMPULSO_CORRIDA, 0), CP::Vec2.new(0, 0))
    end
  end
  # Metodo para mover o personagem a esquerda
  # verifica se ele esta no ar, se sim move-o usando a constante IMPULSO_NO_AR
  # negativa, caso contrario move-o com a constante IMPULSO_CORRIDA negativa.
  # as constantes estao negativas pois o movimento precisa ir a esquerda no plano
  def mover_esquerda
    if @no_ar
      @acao = :pula_esquerda
      @corpo.apply_impulse(CP::Vec2.new(-IMPULSO_NO_AR, 0), CP::Vec2.new(0, 0))
    else
      @acao = :corre_esquerda
      @corpo.apply_impulse(CP::Vec2.new(-IMPULSO_CORRIDA, 0), CP::Vec2.new(0, 0))
    end
  end
  # Metodo para promover o pulo. Caso o heroi estaja no ar a constante IMPULSO_PULO_AR
  # aplica a forca, caso não a forca é aplicada pela constante IMPULSO_PULO
  def pulo
    if @no_ar
      @corpo.apply_impulse(CP::Vec2.new(0, -IMPULSO_PULO_AR),
                            CP::Vec2.new(0, 0))
    else
      @corpo.apply_impulse(CP::Vec2.new(0, -IMPULSO_PULO), CP::Vec2.new(0, 0))
      if @acao == :esquerda
        @acao = :pula_esquerda
      else
        @acao = :pula_direita
      end
    end
  end
  # Metodo que define a acao de ficar parado, caso ele esteja no ar, ele não ficar
  #parado.
  def parado
    if @direita
      @acao = :parado_direita unless no_ar
    else
      @acao = :parado_esquerda unless no_ar
    end
  end

  def ataque
    if !@direita
      @acao = :ataque_esquerda
    else
      @acao = :ataque_direita
    end
  end
  def retorne_x
    return @corpo.p.x
  end
  def retorne_y
    return @corpo.p.y
  end
  def recebeu_ataque(valor, direcao)
    if valor
      @life = @life - 10
      if @direita
        @corpo.apply_impulse(CP::Vec2.new(-6000, -3000), CP::Vec2.new(0,0))
      else
        @corpo.apply_impulse(CP::Vec2.new(6000, -3000), CP::Vec2.new(0,0))
      end
    end
  end
  def life
    return @life
  end
end
