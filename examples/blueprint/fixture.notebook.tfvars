notebook_instances = [
  {
    name          = "with-lc"
    instance_type = "ml.t3.large"
    lifecycle_config = {
      on_create = "echo 'A notebook has been created'"
      on_start  = "echo 'Notebook started'"
    }
  },
]
studio = null
