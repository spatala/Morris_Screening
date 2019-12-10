# Code Structure

## Functions

### `morris.m`

1. Input parameters:
	+ `k` - Number of variables (dimensions).
	+ `r` - Number of paths.
	+ `delta` - Bin-size, i.e. discretization of scaled variable in the interval [0,1].
2. Output parameters:
	+ `xmat` - Array of size `r(k+1) x k`. 
		- There are `k+1` points in each path and there are `r` paths. Therefore, a total of `r(k+1)` rows. All the paths are concatenated.
		- Each point on the path is `k`-dimensional and, hence, `k` columns.
	+ `indmat` - Array of size `r(k+1) x 3`
		- This array is used to compute the derivatives along the path.
3. Also, saves `xvals.mat` with `xmat` and `indmat` that can be used in other codes.

## Codes

### `read_ode_vals.m`
1. Read the output files (obtained by solving Ostwald ODEs). There is one output file for every point along every path.
<!-- 2. Save mat file `calc_vals.mat` with variables `sig_vals` and `rmean_vals`
3. The post-processing includes assigning `NaN` values for any failed ode simulations (even for negative values)
4. **TODO: Write a routine for those statistics.**
	+ How many paths fail before reaching t = 500 increments.
	+ For the paths that fail, at what time steps do they fail?

### `calc_derivatives.m`
1. Calculates the derivatives along the path. There are two quantities of interest here: `rmean` and `rsig`
2. The output variables for the derivatives are `eei_rmean` and `eei_rsig`
3. The derivatives are also calculated for a given time instance. For example, `t1 = 100` -->