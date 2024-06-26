# OpenSearch::Rails

The `opensearch-rails` library is a companion for the
the [`opensearch-model`](https://github.com/compliance-innovations/opensearch-rails/tree/main/opensearch-model)
library, providing features suitable for Ruby on Rails applications.

## Compatibility

This library is compatible with Ruby 1.9.3 and higher.

The library version numbers follow the OpenSearch major versions, and the `main` branch
is compatible with the OpenSearch `master` branch, therefore, with the next major version.

| Rubygem       |   | OpenSearch    |
|:-------------:|:-:| :-----------: |
| main          | → | master        |

## Installation

Install the package from [Rubygems](https://rubygems.org):

    gem install opensearch-rails

To use an unreleased version, either add it to your `Gemfile` for [Bundler](http://bundler.io):

    gem 'opensearch-rails', git: 'git://github.com/compliance-innovations/opensearch-rails.git', branch: '5.x'

or install it from a source code checkout:

    git clone https://github.com/compliance-innovations/opensearch-rails.git
    cd opensearch-rails/opensearch-rails
    bundle install
    rake install

## Features

### Rake Tasks

To facilitate importing data from your models into OpenSearch, require the task definition in your application,
eg. in the `lib/tasks/opensearch.rake` file:

```ruby
require 'opensearch/rails/tasks/import'
```

To import the records from your `Article` model, run:

```bash
$ bundle exec rake environment opensearch:import:model CLASS='Article'
```

To limit the imported records to a certain
ActiveRecord [scope](http://guides.rubyonrails.org/active_record_querying.html#scopes),
pass it to the task:

```bash
$ bundle exec rake environment opensearch:import:model CLASS='Article' SCOPE='published'
```

Run this command to display usage instructions:

```bash
$ bundle exec rake -D opensearch
```

### ActiveSupport Instrumentation

To display information about the search request (duration, search definition) during development,
and to include the information in the Rails log file, require the component in your `application.rb` file:

```ruby
require 'opensearch/rails/instrumentation'
```

You should see an output like this in your application log in development environment:

    Article Search (321.3ms) { index: "articles", body: { query: ... } }

Also, the total duration of the request to OpenSearch is displayed in the Rails request breakdown:

    Completed 200 OK in 615ms (Views: 230.9ms | ActiveRecord: 0.0ms | OpenSearch: 321.3ms)

There's a special component for the [Lograge](https://github.com/roidrage/lograge) logger.
Require the component in your `application.rb` file (and set `config.lograge.enabled`):

```ruby
require 'opensearch/rails/lograge'
```

You should see the duration of the request to OpenSearch as part of each log event:

    method=GET path=/search ... status=200 duration=380.89 view=99.64 db=0.00 es=279.37

### Rails Application Templates

You can generate a fully working example Ruby on Rails application, with an `Article` model and a search form,
to play with (it generates the application skeleton and leaves you with a _Git_ repository to explore the
steps and the code) with the
[`01-basic.rb`](https://github.com/compliance-innovations/opensearch-rails/blob/main/opensearch-rails/lib/rails/templates/01-basic.rb) template:

```bash
rails new searchapp --skip --skip-bundle --template https://raw.github.com/compliance-innovations/opensearch-rails/main/opensearch-rails/lib/rails/templates/01-basic.rb
```

Run the same command again, in the same folder, with the
[`02-pretty`](https://github.com/compliance-innovations/opensearch-rails/blob/main/opensearch-rails/lib/rails/templates/02-pretty.rb)
template to add features such as a custom `Article.search` method, result highlighting and
[_Bootstrap_](http://getbootstrap.com) integration:

```bash
rails new searchapp --skip --skip-bundle --template https://raw.github.com/compliance-innovations/opensearch-rails/main/opensearch-rails/lib/rails/templates/02-pretty.rb
```

Run the same command with the [`03-expert.rb`](https://github.com/compliance-innovations/opensearch-rails/blob/main/opensearch-rails/lib/rails/templates/03-expert.rb)
template to refactor the application into a more complex use case,
with couple of hundreds of The New York Times articles as the example content.
The template will extract the OpenSearch integration into a `Searchable` "concern" module,
define complex mapping, custom serialization, implement faceted navigation and suggestions as a part of
a complex query, and add a _Sidekiq_-based worker for updating the index in the background.

```bash
rails new searchapp --skip --skip-bundle --template https://raw.github.com/compliance-innovations/opensearch-rails/main/opensearch-rails/lib/rails/templates/03-expert.rb
```

## License

This software is licensed under the Apache 2 license, quoted below.

    Licensed to Elasticsearch B.V. under one or more contributor
    license agreements. See the NOTICE file distributed with
    this work for additional information regarding copyright
    ownership. Elasticsearch B.V. licenses this file to you under
    the Apache License, Version 2.0 (the "License"); you may
    not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
    	http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
