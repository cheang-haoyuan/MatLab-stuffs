using JuMP
using Cbc

# the code can be run with different number of compartments 
# and its capacities.
# it is currently set to run for 2 compartments.
# to test for the case with 1 compartment, 
# change C2 to C1 and B2 to B1 in the code :)
# (but NOT the defn so don't use ctrl+F ).

# Data
I = [1:10...] # items
w = [4 10 4 6 4 5 7 6 8 5] # weight 
u = [5 7 3 5 2 2 4 7 4 3] # utility
C1 = [1] # 1 compartment
C2 = [1:2...] # 2 compartments
B1 = [C1 30] # Bag 1 holding 1 30kg compartment
B2 = [C2 [15, 15]] # Bag 2 holding 2 compartments w/ 15kg each

# variable: x{I} : xij = item i is in compartment j
model = Model()
set_optimizer(model, Cbc.Optimizer);
@variable(model, x[i = I, j = C2], Bin)
# each item i can only be in 1 compartment
@constraint(model, unique[i in I] , sum(x[i, :]) <= 1 )
@constraint(model, compartment[j in C2] , sum(w[i]*x[i, j] for i in I) <= B2[j, 2] )
@objective(model, Max, sum(u*x))

optimize!(model)

utility = [0 0]
weight = [0 0]
for i in I
  for j in C2
    if value(x[i, j]) == 1 
        global utility[j] += u[i]
        global weight[j] += w[i]
        println("item $i in compartment $j: utility $(u[i]), weight $(w[i])" )
    end
  end
end
println("Total utilities in compartment 1: $(utility[1]), compartment 2: $(utility[2])")
println("Total utilities: $(sum(utility))")	
