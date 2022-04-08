resource "random_pet" "name" {
  length    = 3
  separator = "-"
}

locals {
  name = random_pet.name.id
}
