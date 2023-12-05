# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :minitest do
  watch(%r{^test/(.*)/?test_(.*)\.rb$}) { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$})     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  watch(%r{^app/views/(.+)_mailer/.+}) { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^test/.+_test\.rb$})

  watch(%r{^app/controllers/(.*)\.rb$})                 { |m| "test/functional/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.*)\.rb$})                 { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/(.*)\.rb$})                 { |m| "test/integration/#{m[1]}_test.rb" }
  watch(%r{^app/helpers/(.*)\.rb$})                     { |m| "test/helpers/#{m[1]}_test.rb" }
  watch(%r{^app/mailers/(.*)\.rb$})                     { |m| "test/mailers/#{m[1]}_test.rb" }
  watch(%r{^app/models/(.*)\.rb$})                      { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^app/models/concerns/(.*)\.rb$})             { |m| "test/models/concerns/#{m[1]}_test.rb" }
  watch(%r{^app/models/concerns/xml_loaders/(.*)\.rb$}) { |m| "test/models/concerns/xml_loaders/#{m[1]}_test.rb" }
  watch(%r{^app/models/concerns/renderers/(.*)\.rb$})   { |m| "test/app/models/concerns/renderers/#{m[1]}_test.rb" }
  watch(%r{^app/models/concerns/definers/(.*)\.rb$})    { |m| "test/app/models/concerns/definers/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.*)\.rb$})                       { |m| "test/system/#{m[1]}_test.rb" }
end