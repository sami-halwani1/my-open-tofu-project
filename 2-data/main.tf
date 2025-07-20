variable "file_name" {
  type = string
}

data "http" "this" {
    url="https://example.com"
}

resource "local_file" "example_html_body" {
    content = data.http.this.body
    filename = "${var.file_name}.html"
}