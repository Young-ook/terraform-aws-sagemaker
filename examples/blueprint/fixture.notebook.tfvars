notebook_instances = [
  {
    name = "with-lc"
    lifecycle_config = {
      on_create = "echo 'A notebook has been created'"
      on_start  = "echo 'Notebook started'"
    }
  },
  {
    name          = "without-lc"
    instance_type = "ml.t3.large"
  },
]
studio = null
