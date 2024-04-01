resource "aws_dynamodb_table" "counter" {	
  name         = "counter"	
  billing_mode = "PAY_PER_REQUEST"	
  hash_key     = "param"	
  attribute {	
    name = "param"	
    type = "S"	
  }	
  tags = {	
    Name = "db"	
  }	
}