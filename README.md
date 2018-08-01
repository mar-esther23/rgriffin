# rgriffin : Gene Regulatory Interaction Formulator For Inquiring Networks

The rgriffin package is an R connector to griffin (http://turing.iimas.unam.mx/griffin/). Gene Regulatory Interaction Formulator For Inquiring Networks (griffin) is a java library for inference and analysis of Boolean Network models. Griffin takes as inputs biologically meaningful constraints and turns them into a symbolic representation. Using a SAT engine, griffin explores the Boolean Network search space, finding all satisfying assignments that are compatible with the specified constraints.
    The rgriffin package includes a number of functions to interact with the BoolNet package.
    See the Jupyter Tutorials for more examples.



# Installation


First, make sure to have java installed. 

rgriffin depends on Java and rJava. Make sure you have a working java version, for example Oracle JDK 8. Installing rJava can be complicated, we recomend that you first install rJava and then rgriffin.
	```
	> install.packages(Rjava)
	```

If you are using ubuntu it might help if you install it from repositories
	```
	$ apt-get install r-cran-rjava
	```

Then, install rgriffin from github using devtools
	```
	>devtools::install_github("mar-esther23/rgriffin")
	```




