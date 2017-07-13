class Lobsomen
  IMPULSO_ANDAR = 700
  IMPULSO_CORRIDA = 1000
  IMPULSO_NO_AR = 60
  IMPULSO_PULO = 36000
  IMPULSO_PULO_AR = 1200
  LIMITE_CORRIDA = 400
  FRICCAO = 0.7
  ELASTICIDADE = 0.2
  attr_reader :corpo, :width, :height
  def initialize(window, x, y)
    @window = window
    espaco = window.espaco
    @width = 150
    @height = 188
    @x = x
    @y = y
    @imagens = Gosu::Image.load_tiles('./imagens/lobisomen.png', 150, 188)
    @movimento = Gosu::Image.load_tiles('./imagens/lobisomen_mover.png', 170, 188)
    @corpo = CP::Body.new(50, 100/0.0)
    @corpo.p = CP::Vec2.new(x,y)
    @corpo.v_limit = LIMITE_CORRIDA
    limites = [CP::Vec2.new(23,-46),
                CP::Vec2.new(-60,-46),
                CP::Vec2.new(-61, 103),
                CP::Vec2.new(24, 103)]
    forma = CP::Shape::Poly.new(@corpo, limites, CP::Vec2.new(0,0))
    forma.e = ELASTICIDADE
    forma.u = FRICCAO
    espaco.add_body(@corpo)
    espaco.add_shape(forma)
    @imagem_index = 0
    @acao = :andar
    @no_ar = true
    @direcao = 1
    @p_inicial = x
    @deslocamento = 0
    @life = 100
  end
  def mover
    if @acao == :andar
      @corpo.apply_impulse(CP::Vec2.new(@direcao*IMPULSO_ANDAR, 0), CP::Vec2.new(0,0))
    elsif @acao == :ataque
    end
    @acao = :andar if rand <0.01
    @acao = :parado if rand < 0.01
  end
  def draw
    if @acao == :andar
      if @direcao == 1
        @deslocamento = @corpo.p.x - @p_inicial
        @movimento[@imagem_index].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
        @imagem_index = (@imagem_index + 0.05) % 4
        @direcao = @direcao*-1 if @deslocamento > 100
      else
        @deslocamento = @corpo.p.x - @p_inicial
        @movimento[@imagem_index].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
        @imagem_index = (@imagem_index + 0.05) % 4
        @direcao = @direcao*-1 if @deslocamento < -100
      end
    elsif @acao == :ataque
      @movimento[@imagem_index].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
    else
      if @direcao == 1
        @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0, 0.5, 0.5, -1, 1)
      else
        @imagens[0].draw_rot(@corpo.p.x, @corpo.p.y, 2, 0)
      end
    end
  end
  def retorne_x
    return @corpo.p.x
  end
  def retorne_y
    return @corpo.p.y
  end
  def atingido(valor, direcao)
    if valor
      if direcao
        @corpo.apply_impulse(CP::Vec2.new(6000,-2000),CP::Vec2.new(0,0))
      else
        @corpo.apply_impulse(CP::Vec2.new(-6000,-2000),CP::Vec2.new(0,0))
      end
      @life = @life - 10
    end
  end
  def direcao
    return @direcao
  end
  def life
    return @life
  end
end
