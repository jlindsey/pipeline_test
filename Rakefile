require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'
require 'rake/clean'
Bundler.require

CLEAN.include FileList['public/**/*.{js,html,css,png,gif}', 'tmp/*']
CLOBBER.include FileList['public/*']

LOGGER        = Logger.new($stdout)
ROOT          = Pathname(File.dirname __FILE__)
SRC_DIR       = ROOT.join('src')
COFFEE_DIR    = SRC_DIR.join('javascripts')
SASS_DIR      = SRC_DIR.join('stylesheets')
HAML_DIR      = SRC_DIR.join('views')
COFFEE_FILES  = FileList[COFFEE_DIR.join('*.coffee').to_s]
SASS_FILES    = FileList[SASS_DIR.join('*.sass').to_s]
HAML_FILES    = FileList[HAML_DIR.join('*.haml').to_s]
IMAGE_FILES   = FileList[SASS_DIR.join('images/*.png').to_s]
TEMPLATES     = FileList[HAML_DIR.join('templates/*.hamlbars').to_s]
PUBLIC_DIR    = ROOT.join('public')
PRODUCTS      = ['tmp/templates.js', 'public/javascripts/app.js', 'public/stylesheets/app.css', 'public/index.html']

@sprockets = Sprockets::Environment.new(ROOT) { |env| env.logger = LOGGER }
if ENV['MD_ENV'] == 'production'
  @sprockets.js_compressor = Uglifier.new(:mangle => true)
  @sprockets.css_compressor = YUI::CssCompressor.new
end
[COFFEE_DIR, SASS_DIR].each { |path| @sprockets.append_path path.to_s }
@sprockets.append_path 'tmp'

# Bad form, but otherwise the globals compiled in with app.js won't be available (eg. $, _, Backbone, etc)
Tilt::CoffeeScriptTemplate.default_bare = true

FileList['src/stylesheets/vendor/images/*'].each do |img|
  dest = PUBLIC_DIR.join('stylesheets/images').join(File.basename(img)).to_s
  PRODUCTS << dest
  file dest => [img] do |t|
    FileUtils.mkpath PUBLIC_DIR.join('stylesheets/images').to_s
    FileUtils.cp img, dest

    LOGGER.info "Copied #{img} => #{dest}"
  end
end

file 'tmp/templates.js' => TEMPLATES do |t|
  FileUtils.mkpath ROOT.join('tmp')

  TEMPLATES.each do |template|
    haml = Haml::Engine.new File.read(template), :format => :html5
    File.open("tmp/#{File.basename(template, '.hamlbars')}.handlebars", 'w') { |f| f.puts haml.render }
  end

  sh './node_modules/handlebars/bin/handlebars tmp/*.handlebars -f tmp/templates.js'
end

rule '.html' => lambda { |f| find_source(f, :haml) } do |t|
  haml = Haml::Engine.new File.read(t.source), :format => :html5, :ugly => true
  File.open(t.name, 'w') { |f| f.puts haml.render }

  LOGGER.info "Compiled #{File.basename t.name}"
end

rule '.js' => lambda { |f| find_source(f, :coffee) } do |t|
  sprockets_write t
end

rule '.css' => lambda { |f| find_source(f, :sass) } do |t|
  sprockets_write t
end

task :build_all => PRODUCTS
task :default => :build_all

def sprockets_write(t)
  assets = @sprockets.find_asset(t.source)
  prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
  FileUtils.mkpath PUBLIC_DIR.join(prefix)
  assets.write_to t.name
end

def find_source(file, type)
  ext_built = case type
              when :coffee then '.js'
              when :haml then '.html'
              when :sass then '.css'
              end
  ext_source = ('.' << type.to_s)

  base = File.basename file, ext_built
  ary = Object.const_get(type.to_s.upcase << '_FILES')
  ary.find { |s| File.basename(s, ext_source) == base }
end
