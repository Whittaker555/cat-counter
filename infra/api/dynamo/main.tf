resource "aws_dynamodb_table" "counter" {	
  name         = "counter"	
  billing_mode = "PAY_PER_REQUEST"	
  hash_key     = "counterName"
  range_key = "person"
  attribute {	
    name = "counterName"	
    type = "S"	
  }	
  attribute {	
    name = "person"	
    type = "S"	
  }
  tags = {	
    Name = "db"	
  }	
}