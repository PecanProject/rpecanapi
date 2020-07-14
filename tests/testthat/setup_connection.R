set.server <- function(username="carya", password="illinois"){
  return(connect("http://localhost:8000", username, password))
}