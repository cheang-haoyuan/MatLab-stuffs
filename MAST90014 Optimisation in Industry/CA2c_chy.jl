using JuMP
using Cbc

# Data
D = [1:7...] # days
E = [136 104 120 152 112 128 88] # employees needed
H = [8*25, 4*15] # total pay for employees


# variables: xi : no. of full time employees starting work on day i
# variable yi: no. of part time employees starting on day i
model = Model()
set_optimizer(model, Cbc.Optimizer);
@variable(model, x[D], Int)
@variable(model, y[D], Int)
@constraint(model, signx[i in D], x[i] >= 0)
@constraint(model, signy[i in D], y[i] >= 0)
@constraint(model, hoursLimit[i in D] , 
  8*(sum(x[d] for d in D) - x[mod(i, 7) + 1] - x[mod(i + 1, 7) + 1])
  + 4*(sum(y[d] for d in D) - y[mod(i, 7) + 1] - y[mod(i + 1, 7) + 1]
  ) >= E[i])
@constraint(model, labourLimit, 20*(sum(y)) <= 0.25*sum(E) )
@objective(model, Min, sum([x y]*H))

optimize!(model)

fe = 0
pe = 0
for i in D
  global fe += x[i]
  global pe += y[i]
  println("Day $i: $(value(x[i])) fulltime and $(value(y[i])) part-time employees starting work today." )
end
println("Total: $(value(sum(x))) fulltime employees $(value(sum(y))) part-time employees" )	
println("Cost: AUD $(value(sum(x*H[1]))) for fulltime employees, AUD $(value(sum(y*H[2]))) part-time employees" )	
println("Total ost: AUD $(value(sum([x y]*H))) ")
