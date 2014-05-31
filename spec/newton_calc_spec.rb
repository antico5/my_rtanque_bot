require 'rspec'
require_relative "../bots/newton_calc"
require_relative "../bots/coordinates"

describe NewtonCalc do
  before do
    @tiempos = (0..2).to_a
    @tiempo_prediccion = 3
  end
  it "should do cuadratic approximation with coordinates" do
    puntos = [[4,0],[2,1],[1,3]].map{|p| Coordinates.new p[0], p[1]}
    prediction = NewtonCalc.cuadratic_approximation @tiempos, puntos, @tiempo_prediccion

    prediction.should eq(Coordinates.new(1,6))
  end

  it "should do cuadratic approximation with numbers" do
    imagenes = [47,50,51]
    prediction = NewtonCalc.cuadratic_approximation @tiempos, imagenes, @tiempo_prediccion

    prediction.should eq(50)
  end

end
