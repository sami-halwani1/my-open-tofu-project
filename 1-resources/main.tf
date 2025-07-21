resource "local_file" "main" {
  content  = "${var.greeting}, World!"
  filename = "${path.module}/example.txt"
}

data "http" "this" {
    url="https://example.com"
}

resource "local_file" "example_html_body" {
    content = data.http.this.body
    filename = "${path.module}/${substr(var.html_file_name,0,8)}.html"
}

resource "local_file" "other"{
    depends_on = [ local_file.main ]
    content = local_file.main.content
    filename = "${path.module}/other.txt"
}