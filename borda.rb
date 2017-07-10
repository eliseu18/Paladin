class Borda
  FRICCAO = 0.7
  ELASTICIDADE = 0.2
  def initialize(window, x, y, width, height)
    espaco = window.space
    # Coordenadas do centro do objeto
    @x = x
    @y = y
    # Largura e altura do objeto
    @width = width
    @height = height
    # Função para criar um corpo
    @corpo = CP::Body.new_static()
    # Defiinido a localização do corpo a partir de seu centro
    @corpo.p = CP::Vec2.new(x,y)
    # Definindo os limites do corpo.
    limites = [CP::Vec2.new(-width / 2, - height / 2),
              CP::Vec2.new(-width / 2, height / 2),
              CP::Vec2.new(width /2 , height / 2),
              CP::Vec2.new(width / 2, -height / 2)]
    # Criando uma forma a partir do corpo e de seus limites
    @forma = CP::Shape::Poly.new(@corpo, limites, CP::Vec2.new(0, 0))
    # Definido um atrito para o corpo
    @forma.u = FRICCAO
    # Definindo a elasticidade do corpo
    @forma.e = ELASTICIDADE
    # Adicionando o corpo ao espaco principal do jogo.
    espaco.add_shape(@forma)
  end
end
