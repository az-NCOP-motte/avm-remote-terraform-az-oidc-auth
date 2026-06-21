locals {
  projects = merge([
    for dc_key, dc in var.devcenters : (
      try(dc.projects, {}) != {} ?
      {
        for proj_key, proj in dc.projects :
        proj_key => merge(proj, {
          center_key = dc_key
        })
      }
      : {}
    )
  ]...)
}
