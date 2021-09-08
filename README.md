# Poolside Hockey

## Description

This is a simple app demonstrating some different technologies. The main feature is the "Create new Export" functionality. 

### The problem
I came up with this idea when I was tasked with coming up with a more efficient way to generate pdf exports. There was a need to generate resource-intensive reports. The previous functionality relied on blocking requests. The client would make a fetch to the server to build a pdf, and wait for the fetch call to complete. Once completed, the server would stream the pdf directly to the user. 

The logic to build the pdfs became more and more intensive over time. Complex SQL queries, huge data sets, and concurrent requests started to pile up. An especially complex pdf could bog down the server for other users. 

### The solution
I decided to move away from blocking requests, and utilize background jobs to do the heavy lifting. Rather than having the controller run the pdf generation, it instead schedules a job to do so. 

The job runs the query, builds the csv file, uploads the file to S3, and then stores the S3 url in a database record (`PlayerExport`).

Once the job runs, it notifies the client about the new export via a websocket connection. Once the client knows the report is complete, it can do what it wishes with that information. It could send it to the user to download immediately. In the current implementation, it just displays it in a table. 

If there is a problem generating the pdf, the client is notified by the same websocket connection. 

## System Requirements
1. Ruby 2.6.7
1. Yarn
1. Bundler

## Setup
1. Install Ruby Dependencies via Bundler `bundle install`
1. Install JS dependencies via Yarn `yarn install`
1. Setup database with `rails db:create && rails db:migrate && rails db:seed`
1. Start the server with `bin/rails s`


## Test suite
This test suite uses Rspec. It will need a properly setup test database (created in [Setup](##Setup) ). 

`bundle exec rspec`

### TODOs
- [ ] Setup pagination for exports page
- [ ] Migrate to using sidekiq for background jobs
- [ ] Get Feature specs working properly with ActionCable
- [ ] Write Jest tests for React code
- [ ] Move to using ActiveStorage for S3 uploads