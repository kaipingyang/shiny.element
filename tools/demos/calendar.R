## basic
el_calendar("cal", value = Sys.Date())

## controller-type
#' `controller_type` set in R; Element Plus's demo switches it with radio buttons.
el_calendar("cal_ctl", value = Sys.Date(), controller_type = "select")

## customize
el_calendar(
  "cal_cell",
  slots = list(
    `date-cell` = template(
      htmltools::HTML(paste0(
        "<p :class=\"data.isSelected ? 'is-selected' : ''\">",
        "{{ data.day.split('-').slice(1).join('-') }} ",
        "{{ data.isSelected ? '✔️' : '' }}</p>"
      )),
      slot = "date-cell",
      scope = "{ data }"
    )
  )
)

## range
el_calendar("cal_range", range = c("2019-03-04", "2019-03-24"))

## header
#' The header's buttons move the calendar with Element Plus's `selectDate()`,
#' called on the component's ref.
el_calendar(
  "cal_head",
  slots = list(
    header = template(
      htmltools::HTML(paste0(
        "<span>Custom header content</span><span>{{ date }}</span>",
        "<el-button-group>",
        "<el-button size=\"small\" @click=\"$refs.el.selectDate('prev-year')\">Previous Year</el-button>",
        "<el-button size=\"small\" @click=\"$refs.el.selectDate('prev-month')\">Previous Month</el-button>",
        "<el-button size=\"small\" @click=\"$refs.el.selectDate('today')\">Today</el-button>",
        "<el-button size=\"small\" @click=\"$refs.el.selectDate('next-month')\">Next Month</el-button>",
        "<el-button size=\"small\" @click=\"$refs.el.selectDate('next-year')\">Next Year</el-button>",
        "</el-button-group>"
      )),
      slot = "header",
      scope = "{ date }"
    )
  )
)
