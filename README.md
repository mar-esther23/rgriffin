# rgriffin : Gene Regulatory Interaction Formulator For Inquiring Networks

The rgriffin package is an R connector to griffin (http://turing.iimas.unam.mx/griffin/). Gene Regulatory Interaction Formulator For Inquiring Networks (griffin) is a java library for inference and analysis of Boolean Network models. Griffin takes as inputs biologically meaningful constraints and turns them into a symbolic representation. Using a SAT engine, griffin explores the Boolean Network search space, finding all satisfying assignments that are compatible with the specified constraints.
    The rgriffin package includes a number of functions to interact with the BoolNet package.



# Installation

`rgriffin` depends on Java and rJava.

First, make sure you hva java installed, we recommend [Oracle JDK 8](https://docs.oracle.com/javase/8/docs/technotes/guides/install/install_overview.html).


Then install [rJava](https://cran.r-project.org/web/packages/rJava/index.html), this can be done from CRAN. While rJava should be authomatically instaled with rGriffin, the installation of rJava is succeptible to mistakes, so it is best to install it first.
	
```
> install.packages(Rjava)
```

Finally, install rgriffin from github using devtools

```
>devtools::install_github("mar-esther23/rgriffin")
```




