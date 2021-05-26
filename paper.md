---
title: 'rGriffin : R Gene Regulatory Interaction Formulator For Inquiring Networks'
tags:
  - R
  - Java
  - Boolean networks
  - Regulatory networks
  - Network inference
  - SAT solver
authors:
  - name: Stalin Muñoz
    orcid: 0000-0001-6259-1609
    affiliation: "1, *"
  - name: Mariana Esther Martinez-Sanchez
    orcid: 0000-0002-6115-1449
    affiliation: "2, *"
  - name: Miguel Carrillo
    orcid: 0000-0003-2105-3075
    affiliation: 3
  - name: Eugenio Azpeitia
    orcid: 0000-0001-7841-5933
    affiliation: 4
  - name: David A. Rosenblueth
    orcid: 0000-0001-8933-8267
    affiliation: 5
affiliations:
 - name: These authors contributed equally
   index: *
 - name: Institute of Software Technology, Graz University of Technology
   index: 1
 - name: Laboratorio de Inmunobiología y Genética, Instituto Nacional de Enfermedades Respiratorias Ismael Cosío Villegas
   index: 2
 - name: Facultad de Ciencias. Universidad Nacional Autónoma de México
   index: 3
 - name: Centro de Ciencias Matemáticas, Universidad Nacional Autónoma de México
   index: 4
 - name: Instituto de Investigaciones en Matemáticas Aplicadas y en Sistemas, Universidad Nacional Autónoma de México
   index: 5
date: May 26, 2021
bibliography: paper.bib
---

# Summary

Boolean networks allow us to give a mechanistic explanation to how cell types emerge from regulatory networks (RN)[@Kauffman:1969]. In regulatory networks, nodes represent genes, proteins or biological processes, while the edges represent the regulatory interactions between them. The state of each node in a RN, active or inactive, may be modeled by a Boolean value, $0$ or $1$ respectively. In addition, the way in which a node depends on other nodes (regulators) can be modeled by using a Boolean network, that is, a function $f: {0,1}^n \rightarrow {0,1}^n$, where $n$ is the number of nodes. Then, the iterated application of a Boolean network $f$, leads to a dynamic system that models, in principle, the dynamics of the RN. The attractors of this dynamic system correspond to the cell types or biological processes represented by the RN. Therefore, modeling by Boolean networks requires the specific definition (inference) of a function $f: {0,1}^n \rightarrow {0,1}^n$. However, inference of Boolean networks (and regulatory networks) is a complex problem, as the available information is often incomplete[@Azpeitia:2013] and the number of all possible Boolean networks is very large. 

Griffin (Gene Regulatory Interaction Formulator For Inquiring Networks) treats the available experimental information as constraints over the space of all possible Boolean networks. A formal definition of regulation, for example, allows us to express these constraints as a formula in Boolean (propositional) logic. Other available information such as known cell types and mutants are similarly represented and incorporated in such a formula. The resulting formula is given to a “SAT solver’’, an off-the-shelf computer program that obtains truth values of the variables of a Boolean formula making such a formula true. Each such assignment of truth values represents a Boolean network satisfying the given constraints.

The rGriffin package is an R connector to Griffin[@Griffin]. rGriffin takes available biological information codified as data frames. These data frames are turned to Griffin and each network produced by Griffin is given back to rGriffin. rGriffin then returns the networks that satisfy the constraints either as plain text Boolean functions or as BoolNet objects. The package includes a number of functions to translate Boolean functions and state networks to topologies and tables and to interact with the BoolNet [@BoolNet] package. This integration allows the user to extend their analyses using BoolNet-compatible packages.

rGriffin was designed to be used by both biologists and computer scientists to infer and verify Boolean networks. rGriffin dramatically simplifies the Griffin user interface and allows the user to perform further analyses using BoolNet. Griffin has already been used in a number of scientific publications [@Griffin, @garcia:2017, @azpeitia:2017,@weinstein:2015,@rosenblueth:2014]. The source code for rGriffin has been archived in github: [@github].

# Acknowledgements

We acknowledge Nathan Weinstein, Elizabeth Ortiz, and the members of the “Seminario de Biología de Sistemas del Centro de Ciencias de la Complejidad” for their valuable feedback. We thank Martin Morgan and Benilton S Carvalho for their valuable guidance during TIB2018-BCDW. We also gratefully acknowledge support from CONACYT: 

# References

@article{Kauffman:1969,
  title={Metabolic stability and epigenesis in randomly constructed genetic nets},
  author={Kauffman, Stuart A},
  journal={Journal of theoretical biology},
  volume={22},
  number={3},
  pages={437--467},
  year={1969},
  publisher={Elsevier}
}

@article{Azpeitia:2013,
  title={Finding missing interactions of the Arabidopsis thaliana root stem cell niche gene regulatory network},
  author={Azpeitia, Eugenio and Weinstein, Nathan and Ben{\'\i}tez, Mariana and Mendoza, Luis and Alvarez-Buylla, Elena R},
  journal={Frontiers in plant science},
  volume={4},
  pages={110},
  year={2013},
  publisher={Frontiers}
}

@article{Griffin,
  title={Griffin: A Tool for Symbolic Inference of Synchronous Boolean Molecular Networks},
  author={Mu{\~n}oz, Stalin and Carrillo, Miguel and Azpeitia, Eugenio and Rosenblueth, David A},
  journal={Frontiers in genetics},
  volume={9},
  pages={39},
  year={2018},
  publisher={Frontiers}
}

@article{Boolnet,
  title={BoolNet - an R package for generation, reconstruction and analysis of Boolean networks},
  author={M{\"u}ssel, Christoph and Hopfensitz, Martin and Kestler, Hans A},
  journal={Bioinformatics},
  volume={26},
  number={10},
  pages={1378--1380},
  year={2010},
  publisher={Oxford University Press}
}

@article{azpeitia:2017,
  title={The combination of the functionalities of feedback circuits is determinant for the attractors’ number and size in pathway-like Boolean networks},
  author={Azpeitia, Eugenio and Mu{\~n}oz, Stalin and Gonz{\'a}lez-Tokman, Daniel and Mart{\'\i}nez-S{\'a}nchez, Mariana Esther and Weinstein, Nathan and Naldi, Aur{\'e}lien and {\'A}lvarez-Buylla, Elena R and Rosenblueth, David A and Mendoza, Luis},
  journal={Scientific Reports},
  volume={7},
  pages={42023},
  year={2017},
  publisher={Nature Publishing Group}
}

@article{garcia:2017,
  title={A dynamic genetic-hormonal regulatory network model explains multiple cellular behaviors of the root apical meristem of Arabidopsis thalian},
  author={Garc{\'\i}a-G{\'o}mez, M{\'o}nica L and Azpeitia, Eugenio and {\'A}lvarez-Buylla, Elena R},
  journal={PLoS computational biology},
  volume={13},
  number={4},
  pages={e1005488},
  year={2017},
  publisher={Public Library of Science}
}


@article{github,
    Abstractnote = {rGriffin : R Gene Regulatory Interaction Formulator For Inquiring Networks.},
    Author = {Adrian Price-Whelan and Brigitta Sipocz and Syrtis Major and Semyeong Oh},
    Date-Modified = {2018-12-05 14:14:18 +0000},
    Doi = {mar-esther23/rgriffin},
    Month = {Dec},
    Publisher = {github},
    Title = {rGriffin: v0.1.1},
    Year = {2018},
    Bdsk-Url-1 = {https://github.com/mar-esther23/rgriffin}
}

@article{weinstein:2015,
  author =        {Weinstein, Nathan and Ortiz-Guti{\'e}rrez, Elizabeth and 
                  Mu{\~n}oz, Stalin and Rosenblueth, David A and 
                  {\'A}lvarez-Buylla, Elena R and Mendoza, Luis},
  title =         {A model of the regulatory network involved in the control
                  of the cell cycle and cell differentiation in the {{\em C}}{\em aenorhabditis elegans} vulva},
  journal =       {BMC Bioinformatics},
  volume =        {16},
  number =        {1},
  pages =         {1},
  year =          {2015},
  publisher =     {BioMed Central}
}

@inproceedings{rosenblueth:2014,
  author =        {David A. Rosenblueth and Stalin Mu{\~n}oz and
                   Miguel Carrillo and Eugenio Azpeitia},
  booktitle =     {1st International Conference on Algorithms for
                   Computational Biology (AlCoB 2014)},
  pages =         {235--246},
  publisher =     {Springer},
  title =         {Inference of {B}oolean networks from gene interaction
                   graphs using a {SAT} Solver},
  year =          {2014}
}



