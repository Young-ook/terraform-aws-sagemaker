notebook_instances = [
  {
    name          = "with-lc"
    instance_type = "ml.m5.xlarge"
    lifecycle_config = {
      on_create = "echo 'A notebook has been created'"
      on_start  = "echo 'Notebook started'"
    }

    # code_repository config requires version 0.4.2 or higher
    # edit the below url to replace with you want use for your notebook instance
    # - amazon personalize example:  "https://github.com/aws-samples/amazon-personalize-samples.git"
    # - huggingface example:  "https://github.com/huggingface/notebooks.git"
    default_code_repository = "https://github.com/huggingface/notebooks.git"
  },
]
studio = null
