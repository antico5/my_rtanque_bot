module NewtonCalc
  def self.cuadratic_approximation array, t
    t += 2

    a1 = array[-3]
    a2 = array[-2]
    a3 = array[-1]
    b1 = a2 - a1
    b2 = a3 - a2
    b3 = (b2 - b1) / 2

    prediccion = a1 + b1 * t + b3 * t * (t - 1)
  end

  def self.linear_approximation array, t
    t += 1

    a1 = array[-2]
    a2 = array[-1]
    b1 = a2 - a1

    prediccion = a1 + b1 * t
  end
end
