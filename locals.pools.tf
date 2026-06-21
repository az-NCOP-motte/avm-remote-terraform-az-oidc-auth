locals {
  pools = merge([
    for dc_key, dc in var.devcenters : (
      try(dc.projects, {}) != {} ?
      merge([
        for proj_key, proj in dc.projects : (
          try(proj.pools, {}) != {} ?
          {
            for pool_key, pool in proj.pools :
            pool_key => merge(pool, {
              project_key = proj_key
              center_key  = dc_key
            })
          }
          : {}
        )
      ]...)
      : {}
    )
  ]...)
}
