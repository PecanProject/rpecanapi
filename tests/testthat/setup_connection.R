set.server <- function(username="carya", password="illinois"){
  return(connect("https://pecan-tezan.ncsa.illinois.edu", username, password))
}