# Karimado

## Installation

Add following line to `Gemfile` file and execute `bundle install` to update dependencies:

```ruby
gem 'karimado'
```

Run following command to copy migrations into the application:

```console
$ rails karimado:install:migrations
Copied migration 20240217125602_create_karimado_users.karimado.rb from karimado
Copied migration 20240217125603_create_karimado_user_sessions.karimado.rb from karimado
Copied migration 20240217125604_create_karimado_user_authentications.karimado.rb from karimado

$ rails db:migrate
== 20240217130429 CreateKarimadoUsers: migrating ==============================
-- create_table(:karimado_users)
   -> 0.0440s
== 20240217130429 CreateKarimadoUsers: migrated (0.0441s) =====================
...
```

Add this line to `config/route.rb` file and restart rails server:

```ruby
mount Karimado::Engine => "/karimado"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [LGPL-3.0-only License](./LICENSE).
