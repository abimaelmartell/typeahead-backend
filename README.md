# Typeahead Backend

[![Ruby](https://github.com/abimaelmartell/typeahead-backend/workflows/Ruby/badge.svg)](https://github.com/abimaelmartell/typeahead-backend/actions)

This API is written using Sinatra, but the build system is using Docker.

## Install

### Prerequisites

- Docker
- Ruby 2.6.5 (for development only)

### Instructions

```sh
docker build . -t typeahead-challenge
docker run -p 4567:4567 -it typeahead-challenge
```

### Development

Install dependencies by running:

```sh
bundle install
```

To run locally you can use

```sh
bundle exec rackup -p 4567
```

This will start a web server at port `4567`, which you can configure using,


For running tests you can use

```sh
bundle exec rspec
```

### Configuration

This app gets configuration from environment variables.

| Env Variable | Description                  |
| ------------ | ---------------------------- |
| `PORT` | HTTP port for the API Server |
| `SUGGESTION_NUMBER` | Number of suggestions to return on search |

## API Documentation

### GET /typeahead/{query}

This will do a search for `query` and return the results as an array of objects

#### Example

```json
[
    { "name": "Jo", "times": 602 },
    { "name": "Johnna", "times": 996 },
    { "name": "Joby", "times": 987 }
]
```

### POST /typeahead/set

This increases the popularity on a result

#### Request

JSON Object with the name of the result on the `name` property.

```json
{
    "name": "annabelle"
}
```

#### Response

JSON Object with the entry updated

```json
{
    "name":"Annabelle",
    "times":535
}
```

For unexisting names the API will return HTTP code 400
