## Cache Inverse of a matrix

## creates a matrix which can cache Inverse of it

makeCacheMatrix <- function(x = matrix()) {
    
    ## Initialize the inverse matrix
    inv <- NULL
    
    ## Method to set the matrix and inverse of it to NULL (setter)
    set <- function(y) {
        x <<- y
        inv <<- NULL
    }
    
    ## Method the get the matrix (getter)
    get <- function() {
        ## Return the matrix
        x
    }
    
    ## Method to set the inverse of the matrix
    setInverse <- function(inverse) {
        inv <<- inverse
    }
    
    ## Method to get the inverse of the matrix
    getInverse <- function() {
        ## Return the inverse value
        inv
    }
    
    ## Return a list of the methods
    list(set = set, get = get,
         setInverse = setInverse,
         getInverse = getInverse)
    
}


## Gets the inverse of a matrix (if available in case, return it else calculates, stores in cace and then return it)
cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    
    m <- x$getInverse()
    # Check if present in cache, if yes return it
    if(!is.null(m)) {
        message("getting cached data")
        return(m)
    }
    # if not presentin cahce, get the data, calculate the inverse, stores in cache, returns the inverse
    data <- x$get()
    m <- solve(data, ...)
    x$setInverse(m)
    m
    
}


m1 <- makeCacheMatrix(matrix(1:4, 2, 2))
m1$get()
# [,1] [,2]
# [1,]    1    3
# [2,]    2    4
cacheSolve(m1)
# [,1] [,2]
# [1,]   -2  1.5
# [2,]    1 -0.5
cacheSolve(m1)
# getting cached data
# [,1] [,2]
# [1,]   -2  1.5
# [2,]    1 -0.5

m2 <- makeCacheMatrix(matrix(5:8, 2, 2))
m2$get()
# [,1] [,2]
# [1,]    5    7
# [2,]    6    8
cacheSolve(m2)
# [,1] [,2]
# [1,]   -4  3.5
# [2,]    3 -2.5
cacheSolve(m2)
# getting cached data
# [,1] [,2]
# [1,]   -4  3.5
# [2,]    3 -2.5
