terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.63"
    
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 1.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 2.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.1"
    }
  }
}