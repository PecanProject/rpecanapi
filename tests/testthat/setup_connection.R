set.server <- function(username="carya", password="illinois"){
  return(connect("http://pecan.localhost:80", username, password))
}