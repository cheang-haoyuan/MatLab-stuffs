using JuMP
using Cbc

# Data
D = [1:7...] # days
E = [17 13 15 19 14 16 11] # employees needed


# variables: xi : no. of employees starting work on day i
model = Model()
set_optimizer(model, Cbc.Optimizer);
# to force the veriable to be integers, comment the line below and uncomment the one below it
@variable(model, x[D], Int)
# @variable(model, x[D], Int) # uncomment this :D
@constraint(model, con[i in D], x[i] >= 0)
@constraint(model, employeeLimit[i in D] , sum(x[d] for d in D) - x[mod(i, 7) + 1] - x[mod(i + 1, 7) + 1] >= E[i])
@objective(model, Min, sum(x))

optimize!(model)

e = 0
for i in D
  global e += x[i]
  println("Day $i: $(value(x[i])) employees starting work today." )
end
println("Total employees: $(value(sum(x)))" )	
