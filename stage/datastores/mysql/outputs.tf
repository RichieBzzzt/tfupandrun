output "address" {
    value = aws_db_instance.example.address
    description = "connect to the database aat this point"
}

output "port" {
    value = aws_db_instance.example.port
    description = "The port the database is listening on."
}