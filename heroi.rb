class Heroi
  # Define constantes, aqui estao os valores das forças aplicadas a cada ação
  IMPULSO_CORRIDA = 600
  IMPULSO_NO_AR = 60
  IMPULSO_PULO = 36000
  IMPULSO_PULO_AR = 1200
  LIMITE_CORRIDA = 400
  FRICCAO = 0.7
  ELASTICIDADE = 0.2
  def initialize(window, x, y)
    @window = window
    espaco = window.space
    @imagens = Gosu::Image.load_tiles()
    # Cria o corpo e suas dimensoes
    @corpo = CP::Body.new(50, 50)
    # Define a localização do corpo
    @corpo.p = CP::Vec2.new(x, y)
    @corpo.v_limit = LIMITE_CORRIDA
    # Define os limites do corpo do heroi
    limites = [CP::Vec2.new(-10, -32),
                CP::Vec2.new(-10, 32),
                CP::Vec2.new(10, 32),
                CP::Vec2.new(10, -32)]
    forma = CP::Shape::Poly.new(@corpo, limites, CP::Vec2.new(0,0))
    forma.u = FRICCAO
    forma.e = ELASTICIDADE
    espaco.add_body(@corpo)
    espaco.add_shape(forma)
    # Variavel para definir a ação do heroi a cada tempo.
    @acao = :parado
    @imagem_index = 0
    # Variavel para verificar se o personagem esta no ar.
    @no_ar = true
  end
  # Metodo que desenha o heroi dependendo da acao dele
  def draw
    case @action
    when :corre_direita
      @imagens[@imagem_index].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
      @imagem_index = (@imagem_index + 0.2) % 7
    when :parado, :pula_direita
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
    when :corre_esquerda
      @imagens[@imagem_index].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
      @imagem_index = (@imagem_index + 0.2) % 7
    when :pula_esquerda
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
    else
      @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
    end
  end
  # Metodo que calcula a distancia entre o corpo e um objeto e retorna se estao
  # tocando ou não (true ou false)
  def tocando?(pes)
    x_diff = (@corpo.p.x - pes.body.p.x).abs
    y_diff = (@corpo.p.y - pes.body.p.y).abs
    x_diff < 12 + pes.width/2 and y_diff < 5 + pes.height / 2
  end
  # Metodo que verifica cada objeto se ele esta tocando o heroi.
  def checar_pes(objetos)
    @no_ar = true
    objetos.each do |objeto|
      @no_ar = false if tocando?(objeto)
    end
    if @corpo.p.y > 765
      @no_ar = false
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
      @corpo.apply_impulse(CP::Vec2.new(IMPULSO_CORRIDA), CP::Vec2.new(0, 0))
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
      if @action == :esquerda
        @action = :pula_esquerda
      else
        @action = :pula_direita
      end
    end
  end
  # Metodo que define a acao de ficar parado, caso ele esteja no ar, ele não ficar
  #parado.
  def parado
    @action = :parado unless no_ar
  end
end
