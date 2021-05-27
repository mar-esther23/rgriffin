---
title 'rGriffin  R Gene Regulatory Interaction Formulator For Inquiring Networks'
tags
  - R
  - Java
  - Boolean networks
  - Regulatory networks
  - Network inference
  - SAT solver
authors
  - name Stalin Muñoz
    orcid 0000-0001-6259-1609
    affiliation "1, *"
  - name Mariana Esther Martinez-Sanchez
    orcid 0000-0002-6115-1449
    affiliation "2, *"
  - name Miguel Carrillo
    orcid 0000-0003-2105-3075
    affiliation 3
  - name Eugenio Azpeitia
    orcid 0000-0001-7841-5933
    affiliation 4
  - name David A. Rosenblueth
    orcid 0000-0001-8933-8267
    affiliation 5
affiliations
 - name These authors contributed equally
   index *
 - name Institute of Software Technology, Graz University of Technology
   index 1
 - name Laboratorio de Inmunobiología y Genética, Instituto Nacional de Enfermedades Respiratorias Ismael Cosío Villegas
   index 2
 - name Facultad de Ciencias. Universidad Nacional Autónoma de México
   index 3
 - name Centro de Ciencias Matemáticas, Universidad Nacional Autónoma de México
   index 4
 - name Instituto de Investigaciones en Matemáticas Aplicadas y en Sistemas, Universidad Nacional Autónoma de México
   index 5
date May 26, 2021
bibliography paper.bib


---


# Summary

rGriffin takes as inputs biologically information like proteins, known interactions, expected expression levels in the different cell types, codifies it as meaningful constraints and turns them into a symbolic representation. Using a SAT engine, Griffin explores the Boolean Network search space, finding all satisfying assignments that are compatible with the specified constraints, determining all the possible regulatory networks that could generate a given set of cell types. The rGriffin package is an R connector to Griffin and includes a number of functions to interact with the BoolNet package.

# Statement of need

Boolean networks allow us to give a mechanistic explanation to how cell types emerge from regulatory networks (RN) [@Kauffman1969]. In regulatory networks, nodes represent genes, proteins or biological processes, while the edges represent the regulatory interactions between them. The state of each node in a RN, active or inactive, may be modeled by a Boolean value, $0$ or $1$ respectively. In addition, the way in which a node depends on other nodes (regulators) can be modeled by using a Boolean network, that is, a function $f {0,1}^n \rightarrow {0,1}^n$, where $n$ is the number of nodes. Then, the iterated application of a Boolean network $f$, leads to a dynamic system that models, in principle, the dynamics of the RN. The attractors of this dynamic system correspond to the cell types or biological processes represented by the RN. Therefore, modeling by Boolean networks requires the specific definition (inference) of a function $f {0,1}^n \rightarrow {0,1}^n$. However, inference of Boolean networks (and regulatory networks) is a complex problem, as the available information is often incomplete[@Azpeitia2013] and the number of all possible Boolean networks is very large. 

Griffin (Gene Regulatory Interaction Formulator For Inquiring Networks) treats the available experimental information as constraints over the space of all possible Boolean networks. A formal definition of regulation, for example, allows us to express these constraints as a formula in Boolean (propositional) logic. Other available information such as known cell types and mutants are similarly represented and incorporated in such a formula. The resulting formula is given to a “SAT solver’’, an off-the-shelf computer program that obtains truth values of the variables of a Boolean formula making such a formula true. Each such assignment of truth values represents a Boolean network satisfying the given constraints.

The rGriffin package is an R connector to Griffin [@Griffin]. rGriffin takes available biological information codified as data frames. These data frames are turned to Griffin and each network produced by Griffin is given back to rGriffin. rGriffin then returns the networks that satisfy the constraints either as plain text Boolean functions or as BoolNet objects. The package includes a number of functions to translate Boolean functions and state networks to topologies and tables and to interact with the BoolNet [@BoolNet] package. This integration allows the user to extend their analyses using BoolNet-compatible packages.

rGriffin was designed to be used by both biologists and computer scientists to infer and verify Boolean networks. rGriffin dramatically simplifies the Griffin user interface and allows the user to perform further analyses using BoolNet. Griffin has already been used in a number of scientific publications [@Griffin; @garcia2017; @azpeitia2017; @weinstein2015; @rosenblueth2014]. The source code for rGriffin has been archived in github [@github].

# Acknowledgements

We acknowledge Nathan Weinstein, Elizabeth Ortiz, and the members of the “Seminario de Biología de Sistemas del Centro de Ciencias de la Complejidad” for their valuable feedback. We thank Martin Morgan and Benilton S Carvalho for their valuable guidance during TIB2018-BCDW. We also gratefully acknowledge support from CONACYT 

# References

