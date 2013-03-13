library(shiny)

shiny::runGitHub(repo = "development", 
		  username = 'earlywarningtoolbox',
	 	    subdir = "RShiny_code/shiny-helloworld/")


# from gist
#shiny::runGist("5063316")
## See also
## http://rstudio.github.com/shiny/tutorial/#deployment-local
## in package pkg/inst/appdir/
#shiny::runApp(system.file('appdir', package='packagename'))
## in zip url or local
#runUrl('https://github.com/rstudio/shiny_example/archive/master.zip')
## in Github project
#shiny::runGitHub('shiny_example', 'rstudio')