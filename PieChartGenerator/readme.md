Hello! This is a readme for my plotly pie chart generator. 

This was made for a huge file consisting of factor columns and quantitative columns. This will 
make a pie chart for any choice of factor variables. You just need to input the names of those factors in ui.r (line 18)

**Note**: input the factor vectors/columns as Strings of the names (ie: "treatment" NOT "chart$treatment" or treatment)

It will also make table of the first 50 rows of the part of the pie chart that you click on (for simplicity's sake, it will only
include the original factor the pie chart is representing and a chosen quantitative variable. You will have to set this quanitative 
variable in server.r as well. (line 10)

**Note**: Of course, you will need to set your working directory and data file, which will be on lines 8 and 9.

The application by default makes a histogram of the entire distribution of your selected quantitative variable, and the distribution
will change to the distribution of the part of the pie chart once clicked on. 
