# Terraform Beginner Bootcamp 2023 - Week 2

⬅️ [Go Back](../README.md)

## Terratowns Mock Server

Clone the repo and then remove the `.git` folder.

```bash
git clone https://github.com/ExamProCo/terratowns_mock_server.git
cd terratowns_mock_server
rm -rf .git
```

Make sure to also add the `.gitpod` task to your root `.gitpod.yml` file (you can then delete the `.gitpod.yml` file in the `terratowns_mock_server` folder).

Move the `bin` folder inside the mock server to our root bin folder.

To make the mock server files executable, run chmod on the directory:

```bash
chmod u+x bin/terratowns/*
```

## Ruby Server with Sinatra

[Sinatra](https://sinatrarb.com/) is a lightweight web framework for Ruby. We use the bundle commanda to install the gems (check the `.gitpod` file). Bundle exec is used to run the server.

All of the code of our server is store in the `server.rb` file.

### Sending Requests

Use the bash scripts inside the `bin` folder to send requests to the server.

```bash
bin/terratowns/create
```

### Debugging

You can use `binding.pry` to debug your code. You can then run the server with `bundle exec ruby server.rb` and then send a request to the server.
