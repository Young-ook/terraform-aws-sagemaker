notebook_instances = [
  {
    name          = "default"
    instance_type = "ml.t3.large"
  },
  {
    name = "with-lc"
    lifecycle_config = {
      on_create = "echo 'A notebook has been created'"
      on_start  = "echo 'Notebook started'"
    }
  },
  {
    name = "without-lc"
  },
]
studio = {}
