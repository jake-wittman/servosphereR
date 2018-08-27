#' Calculate (x, y) coordinates
#'
#' Calculates (x,y) coordinates from dx and dy values
#'
#' Use the dx and dy columns in the servosphere data frames to calculate the (x,
#' y) coordinate for each position recording. This function can be used before
#' or after thinning, but it will run faster on thinned data.
#'
#' @param list A list of data frame objects with columns dx and dy.
#' @return Converts dx and dy values to (x, y) coordinates
#' @export


xyCoordinates <- function(list) {
   map(list, function(.x) {
      mutate(.x,
             x = cumsum(.x$dx),
             y = cumsum(.x$dy))
   })
}

#' Calculate angle between a vector and y-axis
#'
#' Calculate the angle between a vector and y-axis, not the x-axis as in atan2
#'
#' This is a helper function. It is called in another function but is otherwise
#' not "outward facing".
#'
#' This function to calculate the angle between a vector
#' and the y-axis. The base function atan2 calculates the angle between a vector
#' and the x-axis, which is not desirable in this case.
#'
#' @param x The x coordinate from the (x, y) locations.
#' @param y The y coordinate from the (x, y) location for an organism

atan3 <- function(x, y) {
   atan2(x, y)
}

#' Calculate bearing
#'
#' Calculates the bearing (direction of movement) for each time step
#'
#' Calculate the direction moved by the organism between each time step in your
#' data frames. Requires that (x, y) coordinates have been previously calculated
#' and each occupies its own column (e.g. one column for the x coordinate, one
#' for the y coordinate).
#' @param list A list of data frames with separate columns for x and y coordinate values
#' @returns A list of data frames with a column for the bearing of the organism at each time step
#' @export

calcBearing <- function(list) {
   map(list, function(.x) {
      mutate(.x,
             ang = atan3(lead(.x$x, default = NA) - lag(.x$x, 0, default = NA),
                         lead(.x$y, default = NA) - lag(.x$y, 0, default = NA)))
   })
   map(list, function(.x) {
      mutate(.x, bearing = ifelse(.x$ang > 0,
                                  .x$ang * (180 / pi),
                                  ifelse(.x$ang < 0,
                                         ((.x$ang + 2 * pi) * (180 / pi)
                                         ),
                                         NA)))
   })
}
