require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'
require 'rake/clean'
Bundler.require

CLEAN.include FileList['public/**/*.js', 'public/**/*.html', 'public/**/*.css']
CLOBBER.include FileList['public/javascripts', 'public/stylesheets', 'public/views']

LOGGER 				= Logger.new($stdout)
ROOT 					= Pathname(File.dirname __FILE__)
SRC_DIR 			= ROOT.join('src')
COFFEE_DIR 		= SRC_DIR.join('javascripts')
SASS_DIR			= SRC_DIR.join('stylesheets')
HAML_DIR 			= SRC_DIR.join('views')
COFFEE_FILES 	= FileList[COFFEE_DIR.join('*.coffee').to_s]
SASS_FILES		= FileList[SASS_DIR.join('*.sass').to_s]
HAML_FILES 		= FileList[HAML_DIR.join('*.haml').to_s]
PUBLIC_DIR 		= ROOT.join('public')
PRODUCTS			= ['public/javascripts/app.js', 'public/index.html']

@sprockets = Sprockets::Environment.new(ROOT) { |env| env.logger = LOGGER }
[COFFEE_DIR, SASS_DIR].each { |path| @sprockets.append_path path.to_s }

task :default => PRODUCTS

rule '.html' => lambda { |f| find_source(f, :haml) } do |t|
	haml = Haml::Engine.new File.read(t.source), :format => :html5
	File.open(t.name, 'w') { |f| f.puts haml.render }

	LOGGER.info "Compiled #{File.basename t.name}"
end

rule '.js' => lambda { |f| find_source(f, :coffee) } do |t|
	assets = @sprockets.find_asset(t.source)
	prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
	FileUtils.mkpath PUBLIC_DIR.join(prefix)
	assets.write_to t.name
end

def find_source(file, type)
	ext_built = case type
							when :coffee then '.js'
							when :haml then '.html'
							end
	ext_source = ('.' << type.to_s)

	base = File.basename file, ext_built
	ary = Object.const_get(type.to_s.upcase << '_FILES')
	ary.find { |s| File.basename(s, ext_source) == base }
end
