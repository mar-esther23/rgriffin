# rgriffin : Gene Regulatory Interaction Formulator For Inquiring Networks

The rgriffin package is an R connector to griffin (http://turing.iimas.unam.mx/griffin/). Gene Regulatory Interaction Formulator For Inquiring Networks (griffin) is a java library for inference and analysis of Boolean Network models. Griffin takes as inputs biologically meaningful constraints and turns them into a symbolic representation. Using a SAT engine, griffin explores the Boolean Network search space, finding all satisfying assignments that are compatible with the specified constraints.
    The rgriffin package includes a number of functions to interact with the BoolNet package.
    See the Jupyter Tutorials for more examples.



# Installation

1. Install griffin and java
	Follow the griffin instalation instructions
	http://turing.iimas.unam.mx/griffin/guide.html#instal
	
	If you are using linux we recomend you install Oracle JDK 8
	https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-get-on-ubuntu-16-04
	
	Do not forget to configure your environmental variables


2. Install rJava
	rgriffin depends on rJava. However, installing rJava can be complicated, we recomend that you first install rJava and then rgriffin.
	```
	> install.packages(Rjava)
	```

	If you are using ubuntu it might help if you install it from repositories
	```
	$ apt-get install r-cran-rjava
	```


3. Install rgriffin
	You can install rgriffin from github using devtools
	```
	>
	```




