# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'coffeescript', :input => 'src/coffee', :output => 'public'

guard 'haml', :input => 'src/haml', :output => 'public', :haml_options => { :format => :html5 } do
  watch(/^.+(\.html\.haml)/)
end

guard 'rake', :task => 'build' do
  watch(%r{^my_file.rb})
end
