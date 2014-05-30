require 'rspec'
require_relative "../bots/newton_calc"
require_relative "../bots/coordinates"

describe NewtonCalc do
  it "should do cuadratic approximation with coordinates" do
    p1 = Coordinates.new(4, 0)
    p2 = Coordinates.new(2, 1)
    p3 = Coordinates.new(1, 3)
    t0,t1,t2 = 0,1,2

    tf = 3
    prediction = NewtonCalc.cuadratic_approximation [t0,t1,t2], [p1,p2,p3], tf

    prediction.should eq(Coordinates.new(1,6))
  end

  it "should do cuadratic approximation with numbers" do
    p1,p2,p3 = 47,50,51
    t0,t1,t2 = 0,1,2

    tf = 3
    prediction = NewtonCalc.cuadratic_approximation [t0,t1,t2], [p1,p2,p3], tf

    prediction.should eq(50)
  end

end
