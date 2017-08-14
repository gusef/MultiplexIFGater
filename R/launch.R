#' Launch the MultiplexIFGater
#'
#' Run the Shiny App MultiplexIFGater
#' @export
MultiplexIFGater <- function () {
    shiny::runApp(system.file('shiny',package="MultiplexIFGater"),launch.browser = T)
}
