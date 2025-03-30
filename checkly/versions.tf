terraform {
  required_providers {
    checkly = {
      source  = "checkly/checkly"
      version = "1.7.1"

    }
  }

  required_version = ">= 1.1.4"
}