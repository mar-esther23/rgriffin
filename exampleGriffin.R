library("rGriffin")

genes = c('a','b','c')
inter = data.frame(source=c('a','b','b','c','c'), 
                  target=c('b','b','c','b','c'), 
                  type=c('+','+','-','-','+'),
                    stringsAsFactors = F )
q = createGqueryGraph(inter, genes)

attr = data.frame(a=c(0,'*',0), 
                 b=c(0,1,0), 
                 c=c(0,0,1),
                 stringsAsFactors = F )
q = addGqueryAttractors(q, attr)

# cycle = data.frame(a=c(0,0), b=c(0,1), c=c(1,0), stringsAsFactors = F )
# q = addGqueryCycle(q, cycle)

# attr.prohibited = data.frame(a=c('*'), b=c(1), c=c(1), stringsAsFactors = F )
# q = addGqueryProhibited.attractors(q, attr.prohibited)

# mutant.node = c('c')
# mutant.value = c(1) 
# mutant.attr = data.frame(a=c(0,1), b=c(0,0), c=c(1,1), stringsAsFactors = F )
# q = addGqueryMutant(q, mutant.node, mutant.value, mutant.attr)
# 
# mutant.nodes = c('a','b')
# mutant.values = c(0,0) 
# mutant.attrs = data.frame(a=c(0), b=c(0), c=c('*'), stringsAsFactors = F )
# q = addGqueryMutant(q, mutant.nodes, mutant.values, mutant.attrs)
# 
# transition = data.frame(a=c(1,1,1,1), b=c(0,1,1,1), c=c(1,1,0,0), 
#                         stringsAsFactors = F )
# q = addGqueryTransition(q, transition)
# 
# trap = data.frame(a=c(1), b=c('*'), c=c('*'), stringsAsFactors = F )
# q = addGqueryTrapspace(q, trap)

print( q )

nets = runGquery(q)
print(nets)

nets = runGquery(q,return = "BoolNet")
print( iterators::nextElem(nets) )




# #Tests
#
# #griffin=.jnew("mx/unam/iimas/griffin/grn/explorer/Griffin")
# #griffparams = c("-f","/home/stan/grn/eobm/data/g.grf","-o","/home/stan/grn/eobm/data/g.out")
# #x = .jarray(griffparams)
# #.jcall(griffin,returnSig="V","main",x)
# 
# query = .jnew("mx/unam/iimas/griffin/r/RGriffinQuery")
# genes = .jarray(c("A","B"))
# .jcall(query,returnSig = "V","setGenes",genes)
# .jcall(query,returnSig = "V","addRRegulation","A","B","OUSU")
# .jcall(query,returnSig = "V","addRRegulation","A","A","ONPA")
# fixed_point1 = "01"
# fixed_point2 = "11"
# partial_fixed_point1 = "*0"
# attractor1 = c("00","01","11")
# 
# .jcall(query,returnSig = "V","addAttractor",fixed_point1)
# .jcall(query,returnSig = "V","addAttractor",fixed_point2)
# .jcall(query,returnSig = "V","addAttractor",partial_fixed_point1)
# .jcall(query,returnSig = "V","addAttractor",attractor1)
# 
# prohibitedfixedPoint="00"
# prohibitedfixedPoints=c("01","1*")
# 
# .jcall(query,returnSig = "V","addFixedPointProhibition",prohibitedfixedPoint)
# .jcall(query,returnSig = "V","addFixedPointProhibition",prohibitedfixedPoints)
# 
# mutantFixedPoints=c("00","11")
# mutantGenes = c("A","B")
# mutantValues = c("1","0")
# 
# .jcall(query,returnSig = "V","addMutantFixedPoints",mutantGenes,mutantValues,mutantFixedPoints)
# 
# inputState = "00"
# outputState = "11"
# .jcall(query,returnSig="V", "addStateTransition",inputState,outputState)
# 
# subspace = "0*"
# .jcall(query,returnSig = "V","addSubspace",subspace)
# 
# 
# 
# 
# 
# #setting Griffin query options
# #activate or deactivate hypothetical regulations
# option_hypotheses = "allow.hypotheses"
# value_hypotheses = "true"
# .jcall(query,returnSig = "V","addOption",option_hypotheses,value_hypotheses)
# 
# #allows networks with additional cyclic attractors to those specified in the query
# option_cycles = "allow.additional.cycles"
# value_cycles = "false"
# .jcall(query,returnSig = "V","addOption",option_cycles,value_cycles)
# 
# #allows networks with additional fixed-point attractors to those specified in the query
# option_states = "allow.additional.states"
# value_states = "true"
# .jcall(query,returnSig = "V","addOption", option_states,value_states)
# 
# #allow ambiguous networks, if true ambiguous regulations may appear in the solutions
# option_ambiguity = "allow.ambiguity"
# value.ambiguity = "false"
# .jcall(query,returnSig = "V", "addOption",option_ambiguity,value.ambiguity)
# 
# #does not enforce fixed-point attractors in the query, it uses model checking and clause learning instead
# option_block_steady_a_posteriori = "block.steady.a.posteriori"
# value_block_steady_a_posteriori = "true"
# .jcall(query,returnSig = "V","addOption",option_block_steady_a_posteriori,value_block_steady_a_posteriori)
# 
# #if true divides the query into multiple queries by query splitting methods
# option_divide_query = "divide.query.by.topology"
# value_divide_query = "true"
# .jcall(query,returnSig = "V","addOption",option_divide_query,value_divide_query)
# #the type of query splitting method, options are: 
# #  radial: computes centres as regulation graphs with no hypotheses and explores adding combinations of the hypothetical regulations,
# #          the number of simultaneous regulations equals the radius
# option_topology_iterator_type = "topology.iterator.type"
# value_topology_iterator_type = "radial"
# .jcall(query,returnSig = "V","addOption",option_topology_iterator_type,value_topology_iterator_type)
# 
# # sets an interval for the exploration, regulation graphs are ennumerated in a lexicographic order, the range defines a constraint in
# # the exploration of those graphs.
# #for sequential only
# option_topology_range = "topology.range"
# value_topolgy_range = "1,3"
# .jcall(query,returnSig = "V","addOption",option_topology_range,value_topolgy_range)
# 
# # the number of simultaneous hypotheses that are used by Griffin when doing radial query splitting
# #for radial only
# option_radius = "topological.distance.radius"
# value_radius = "5"
# .jcall(query,returnSig = "V","addOption",option_radius,value_radius)
# 
# # the maximum number of Boolean networks return by Griffin
# option_limit = "limit.boolean.networks"
# value_limit = "1"
# .jcall(query,returnSig = "V","addOption",option_limit,value_limit)
# 
# q =.jcall(query,returnSig = "S","asString",evalString = TRUE)
# print(q)
# 
# #Akutsu, T., Miyano, S., & Kuhara, S. (1999, January). 
# #Identification of genetic networks from a small number of gene expression patterns 
# #under the Boolean network model. 
# #In Pacific symposium on biocomputing (Vol. 4, pp. 17-28).
# #Name and order of nodes
# print("Akutsu, Miyano and Kuhara 3 genes example")
# query = .jnew("mx/unam/iimas/griffin/r/RGriffinQuery")
# genes = .jarray(c("v1","v2","v3"))
# 
# .jcall(query,returnSig = "V","setGenes",genes)
# .jcall(query,returnSig = "V","addRRegulation","v1","v2","MPPA")
# .jcall(query,returnSig = "V","addRRegulation","v1","v2","MNPA")
# .jcall(query,returnSig = "V","addRRegulation","v2","v1","MPPA")
# .jcall(query,returnSig = "V","addRRegulation","v3","v2","MPPA")
# 
# #allow ambiguous networks
# option_ambiguity = "allow.ambiguity"
# value.ambiguity = "true"
# .jcall(query,returnSig = "V", "addOption",option_ambiguity,value.ambiguity)
# 
# #allows networks with additional cyclic attractors to those specified in the query
# option_cycles = "allow.additional.cycles"
# value_cycles = "true"
# .jcall(query,returnSig = "V","addOption",option_cycles,value_cycles)
# 
# #allows networks with additional fixed-point attractors to those specified in the query
# option_states = "allow.additional.states"
# value_states = "true"
# .jcall(query,returnSig = "V","addOption", option_states,value_states)
# 
# #creates the controller to interact with Griffin
# controller = query = .jnew("mx/unam/iimas/griffin/r/GriffinController",query)
# #requests a single network
# n = .jcall(controller,returnSig = "S","nextElement",evalString = TRUE)
# print("requests a single solution")
# print(n)
# #requests 3 networks at a time
# #the method will return less networks if no such number of solutions exist
# print("requests 5 more solutions")
# m = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(5))
# print(m)
# #requests 3 more networks 
# #the method will return less networks if no such number of solutions exist
# print("requests 3 more solutions, but only two are left")
# o = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(3))
# print(o)
# #subsequent requests give no answers 
# print("requesting more solutions gives no answer")
# p = .jcall(controller,returnSig = "[Ljava/lang/String;","nextElement",as.integer(3))
# print(p)
