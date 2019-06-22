#
#	NearestPoint
#
#	Given a point and a line, find the point on the line
#	which is nearest to the given point.
#

nearestPoint <- function(...) {
}

#
# **  Usage:
# **      point_line_distance(x1,y1,x2,y2,ptx,pty)
# **
# **  Arguments:
# **      intercept  intercept of line
# **      slope      slope of line
# **      ptx,pty    point to measuring from
# **
# **  Returns:
# **      the distance from the given point to a given line
# **
# **  GMLscripts.com
#
nearest_point <- function(ptx, pty, intercept, slope) {

    N <- length(ptx)
    stopifnot(length(pty) == N)

    # From the slope and intercept, identify two
    # points on the line
    #
    x1 <- 0
    y1 <- intercept
    x2 <- 1
    y2 <- intercept + slope

    dx = rep(x2 - x1, N)
    dy = rep(y2 - y1, N)

    # Must check here: Is point = a given point?
    #
    t <- ifelse(dx == 0 & dy == 0,
			0,
			((ptx - x1) * dx + (pty - y1) * dy) / (dx * dx + dy * dy) )

    x = x1 + t * dx;
    y = y1 + t * dy;

    nearest <- cbind(x,y)
    colnames(nearest) <- c("x", "y")
    return(nearest)
}

point_distance <- function(x0, y0, x1, y1) {
	sqrt((x1-x0)^2 + (y1-y0)^2)
}

point_line_distance <- function(ptx, pty, intercept, slope) {
	nearest <- nearest_point(ptx, pty, intercept, slope)
	point_distance(ptx, pty, nearest[,"x"], nearest[,"y"])
}
