# terraform-aws-url-shortener

Terraform module for a AWS URL shortener (No Lambda required)

Creates a url shortener using only ApiGateway and Dynamodb


## Usage
```
provider "aws" {
  region = "sa-east-1"
}

module "url-shortener" {
  source = "github.com/fernandomoraes/terraform-aws-url-shortener.git"
  tags = {
    application = "test"
  }
  stack_name = "url-shortener"
  api_stage_name = "test"
}
```

```
curl -X POST https://${url}/ --header 'content-type:application/json' --data '{ "id": "google", "url": "https://google.com" }'
```

Now, open `https://${url}/google`
