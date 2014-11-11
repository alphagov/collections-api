# Collections API

This API sits between the [collections-frontend](http://github.com/alphagov/collections)
and our content stores, merging and inflating collections content.

## Technical documentation

This is a Ruby on Rails app which combines content from three different content
stores to provide a single, RESTful endpoint for a sub-topic
(eg. _[Business tax: PAYE](https://www.gov.uk/business-tax/paye)_).

### Dependencies

- [alphagov/content-store](https://github.com/alphagov/content-store) - to fetch
  the content item for the sub-topic, including its curated list
- [alphagov/govuk_content_api](https://github.com/alphagov/govuk_content_api) -
  to fetch all the content tagged with the sub-topic
- [alphagov/rummager](https://github.com/alphagov/rummager) - to fetch a list of
  recently changed documents

### Running the application

`bundle exec rails s`

If you're running the app in the GOV.UK development environment, start the app
on port 3084 in order to access it at <http://collections-api.dev.gov.uk>.

If you're using [Bowler](https://github.com/JordanHatch/bowler), you can start
the app with `bowl collections-api`.

### Running the test suite

`bundle exec rspec`

## Licence

[MIT Licence](LICENCE)
