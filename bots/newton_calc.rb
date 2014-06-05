module NewtonCalc

  #ts: valores de la variable independiente
  #ys: valores de la imagen en t
  #t: valor de la variable independiente para evaluar la aproximacion
  def self.cuadratic_approximation ts, ys, t
    t0,t1,t2 = ts
    y0,y1,y2 = ys

    b1 = (y1 - y0) / (t1 - t0)
    b2 = (y2 - y1) / (t2 - t1)
    b3 = (b2 - b1) / (t2 - t0)

    prediccion = y0 + b1 * (t - t0) + b3 * (t - t0) * (t - t1)
  end
end
