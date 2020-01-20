SimpleCrud
=============

[![Build Status](https://travis-ci.org/Wolox/simple-crud.svg?branch=master)](https://travis-ci.org/Wolox/simple-crud)
[![Gem Version](https://badge.fury.io/rb/simple-crud.svg)](https://badge.fury.io/rb/simple-crud)
[![Code Climate](https://codeclimate.com/github/Wolox/simple-crud/badges/gpa.svg)](https://codeclimate.com/github/Wolox/simple-crud)

# Table of contents
  - [Description](#description)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Setup](#setup)
      - [Application controller](#application-controller)
      - [Each controller](#each-controller)
      - [Options](#options)
        - [Paginate](#paginate)
        - [Authorize](#authorize)
        - [Serializer](#serializer)
      - [Shared examples](#shared-examples)
  - [Contributing](#contributing)
  - [Releases](#releases)
  - [About](#about)
  - [License](#license)

-----------------------

## Description

Simple Crud is a gem for Rails that simplifies writing standard CRUD actions, while also adding tools so it's not needed to write tests for them. Its main objective is replacing generally copy-pasted code like generic paginated, authenticated index methods for simple lines such as
```ruby
simple_crud_for :index
```
It includes support for index, create, destroy, update and show, and options to specify whether it should apply pagination, authorization and if a particular serializer should be used. Keep in mind, though, that the idea is not to replace writing methods in controllers altogether, but only to replace most standard cases.

## Installation
Add the following line to your application's Gemfile:

```ruby
gem 'simple_crud'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install simple_crud
```

## Usage
### Setup
#### Application controller
Before SimpleCrud can be used, some boilerplate is needed. Add the following to your ApplicationController (or every controller in case you don't want it included in all controllers)
```ruby
include Pundit
extend SimpleCrud

before_action :set_params

def set_params
  SimpleCrudController.params = params
end
```


### Each controller
In case you need either update or create, create a method with the valid input params using standard rails:
```ruby
def author_params
  params.permit(:first_name, :email, :last_name, :institution, :role)
end
```

For the actual crud methods, just use the lines you need
```ruby
simple_crud_for :update
simple_crud_for :show
simple_crud_for :index
simple_crud_for :create
simple_crud_for :destroy
```

Each method supports different options, as in:
```
simple_crud_for :index, paginate: false, authorize: false, serializer: CustomSerializer
```

- Paginate: whether it should paginate or not. `true` paginates using wor-paginate, `false` doesn't paginate
- Authorize: whether it should use Pundit to automatically check if the action is permitted
- Authenticate: whether it should use Devise to check for a current_user
- Serializer: specify a particular serializer you should use

You'll need a few things so they work correctly:

### Options
#### Paginate
No options are needed, but the pagination is done using [wor-paginate](https://github.com/Wolox/wor-paginate) so read the documentation in case you need to customize the output.

#### Authorize
The name of the policy should be the model followed by Policy, as in `AuthorPolicy`. Support for custom policies is upcoming. The policy should be a standard Pundit policy, for example:

```ruby
class AuthorPolicy
  attr_reader :user, :author

  def initialize(user, author)
    @user = user
    @author = author
  end

  def show?
    user.present?
  end
end

```

#### Authenticate
SimpleCrud will assume a current_user method. Future versions will support a custom model. Defining a current_user method in ApplicationController should work if you're using a different model, as of now.

#### Serializer
The name of the serializer, by default, is the name of the model followed by Serializer, as is the standard for [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers). It's possible to just pass a custom serializer class though. As for the serializer itself, it's a standard serializer, with the gotcha that you need to include `:id` for the SimpleCrud examples to work.

```ruby
class AuthorSerializer < ActiveModel::Serializer
  attributes :email, :first_name, :last_name, :institution, :role, :id
end
```

### Shared examples
While optional, using the included shared examples saves you from writing the standard test cases for the methods. You can even use them if you didn't use `simple_crud_for`, as a set of basic tests. To include them, just add `require 'simple_crud/rspec'` to your `rails_helper.rb` file and add the lines you need to your `*_spec.rb` files:
```ruby
require 'rails_helper'

describe V1::Backoffice::AuthorsController do
  include_examples 'simple crud for update'
  include_examples 'simple crud for show'
  include_examples 'simple crud for create'
  include_examples 'simple crud for index'
  include_examples 'simple crud for destroy'
end
```

It's not needed to specify paginate: true and such, since the shared examples will use the configuration that was originally passed to simple_crud_for

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run rubocop lint (`bundle exec rubocop -R --format simple`)
5. Run rspec tests (`bundle exec rspec`)
6. Push your branch (`git push origin my-new-feature`)
7. Create a new Pull Request to `master` branch

## Releases
📢 [See what's changed in a recent version](https://github.com/Wolox/simple-crud/releases)

## About ##

The current maintainers of this gem are :
* [Ignacio Coluccio](https://github.com/icoluccio)

This project was developed by:
* [Ignacio Coluccio](https://github.com/icoluccio)

At [Wolox](http://www.wolox.com.ar)

[![Wolox](https://raw.githubusercontent.com/Wolox/press-kit/master/logos/logo_banner.png)](http://www.wolox.com.ar)

## License

**simple-crud** is available under the MIT [license](https://raw.githubusercontent.com/Wolox/simple-crud/master/LICENSE.md).

    Copyright (c) 2017 Wolox

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
