
library(tidyverse)

## Color planar graph

# https://github.com/datduong/simulated-annealing-to-color-a-planar-graph/blob/master/colorNodesInGraph.R
# https://github.com/jpmarindiaz/simulated-annealing-to-color-a-planar-graph


getPiValue = function (colors,graph){
  nodes = length(colors)
  score = 0 
  for ( n1 in 1:(nodes-1) ){
    for (n2 in (n1+1):nodes) {
      if ( (colors[n1]==colors[n2]) & are.connected(graph,n1,n2)){
        score = score+1 # add 1 if neighbors have same color 
      }
    }
  }
  return (exp(-1*score)) # low energy if too many nodes disagree on coloring 
}

library('igraph')

#nodes = 5
#graph = graph(edges=c(1,2,2,3,3,4,4,5,2,5,3,5,2,4),directed=F) ## !! able to change this input into any graph. 

edges <- read_csv("countries-neighbors.csv")

nodes <- length(unique(c(edges$country,edges$neighbor)))
graph <- graph_from_data_frame(edges)

# are.connected(graph,1,2)
#plot(graph) 

colors = 1:4 ## !! 4 colors allowed. ## also able to change this input into any number of colors
init = rep(1,nodes) # initial colors are all identical 

tau = 1
stop = 5000 
iter = 0
while (iter < stop){
  iter = iter + 1
  if (iter > 100 & iter%%10==0){
    tau = tau * .90 # update tau => cooling step 
  }
  pi_before = getPiValue(init,graph)
  pickNode = sample (1:nodes,size=1)
  pickColor = sample(colors[-init[pickNode]],size=1) ## 4-1 colors possible 
  propose = init # change the colors
  propose[pickNode] = pickColor # change the colors
  pi_after = getPiValue(propose,graph)
  a_ij = min (1, (pi_after/pi_before)^(1/tau) ) # jump probability 
  if ( runif(1,min=0,max=1) <= a_ij ) {
    init = propose # accept the updated the colors 
  }
}
print (init) ## final coloring 

nodes <- data_frame(id = V(graph)$name, color = init)

write_csv(nodes, "countries_color.csv")




