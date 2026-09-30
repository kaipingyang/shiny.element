#' Element UI Steps Component  
#'  
#' @param id Steps ID (auto-generated if NULL)  
#' @param steps List of step definitions, each with title, description, icon, status  
#' @param active Current active step index (0-based)  
#' @param space Step spacing (number or percentage string)  
#' @param direction Display direction ("horizontal" or "vertical")  
#' @param process_status Status of current step  
#' @param finish_status Status of finished steps  
#' @param align_center Center align title and description  
#' @param simple Apply simple style  
#' @param session Shiny session for module support  
#' @param width Component width, as a CSS unit -- `"200px"`, `"50%"`, or a
#'   number taken as pixels. Element's own markup carries it, so it behaves
#'   like the `width` argument of a Shiny input.
#' @return A Shiny UI element.
#' @export  
#' @examples  
#' # Basic usage  
#' el_steps(  
#'   id = "my_steps",  
#'   steps = list(  
#'     list(title = "Step 1"),  
#'     list(title = "Step 2"),  
#'     list(title = "Step 3")  
#'   )  
#' )  
#'  
#' # With descriptions and icons  
#' el_steps(  
#'   id = "my_steps",  
#'   active = 1,  
#'   finish_status = "success",  
#'   steps = list(  
#'     list(title = "Step 1", description = "Complete registration", icon = "el-icon-edit"),  
#'     list(title = "Step 2", description = "Upload documents", icon = "el-icon-upload"),  
#'     list(title = "Step 3", description = "Finish", icon = "el-icon-picture")  
#'   )  
#' )  
el_steps <- function(id = NULL,  
                     steps = list(),  
                     active = 0,  
                     space = NULL,  
                     direction = "horizontal",  
                     process_status = "process",  
                     finish_status = "finish",  
                     align_center = FALSE,  
                     simple = FALSE,  
                     width   = NULL,
                     session = getDefaultReactiveDomain()) {  
  if (is.null(id)) {  
    id <- paste0("el_steps_", uuid::UUIDgenerate())  
  }  
  ns_id <- if (!is.null(session)) session$ns(id) else id  
  container_id <- paste0(ns_id, "_container")  
    
  # Generate el-step tags from list  
  step_tags <- lapply(steps, function(step) {  
    attrs <- list()  
    if (!is.null(step$title)) attrs$title <- step$title  
    if (!is.null(step$description)) attrs$description <- step$description  
    if (!is.null(step$icon)) attrs$icon <- step$icon  
    if (!is.null(step$status)) attrs$status <- step$status  
      
    htmltools::tag("el-step", attrs)  
  })  
    
  # Build el-steps attributes  
  steps_attrs <- list(  
    ":active" = "active",  
    ":direction" = "direction",  
    ":process-status" = "processStatus",  
    ":finish-status" = "finishStatus",  
    ":align-center" = "alignCenter",  
    ":simple" = "simple"  
  )  
  steps_attrs[[":space"]] <- .el_optional_bind("space")
  # Build Vue data object  
  vue_data <- list(  
    active = active,  
    direction = direction,  
    processStatus = process_status,  
    finishStatus = finish_status,  
    alignCenter = align_center,  
    simple = simple  
  )  
  vue_data$space <- .el_or_na(space)
  # Create component UI  
  .el_widget(
    id     = ns_id,
    markup = htmltools::tag("el-steps", c(steps_attrs, step_tags)),
    data   = vue_data,
    watch  = list(
      active = htmlwidgets::JS(sprintf(
        "function(newVal) { Shiny.setInputValue('%s', newVal); }", ns_id
      ))
    ),
    mounted    = .el_mounted_init(stats::setNames("active", ns_id)),
    width      = width,
    dependency = el_steps_handler_dependency()
  )  
}  
  
#' Update Element UI Steps  
#' @param session Shiny session object  
#' @param id Steps ID  
#' @param active New active step index  
#' @param process_status New process status  
#' @param finish_status New finish status  
#' @return Called for its side effect; returns `NULL` invisibly.
#' @examples
#' if (interactive()) {
#'   # inside a server function
#'   observeEvent(input$go, {
#'     update_el_steps(session, "wizard", active = 2)
#'   })
#' }
#' @export  
update_el_steps <- function(session, id,   
                            active = NULL,  
                            process_status = NULL,  
                            finish_status = NULL) {  
  ns_id <- session$ns(id)  
  message <- list(id = ns_id)  
  if (!is.null(active)) message$active <- active  
  if (!is.null(process_status)) message$processStatus <- process_status  
  if (!is.null(finish_status)) message$finishStatus <- finish_status  
    
  session$sendCustomMessage('updateElSteps', message)
  invisible(NULL)
}  