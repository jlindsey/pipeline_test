require 'bundler'
require 'pathname'
require 'logger'
require 'fileutils'
require 'rake/clean'
Bundler.require

CLEAN.include FileList['public/**/*.js', 'public/**/*.html', 'public/**/*.css']

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

@sprockets = Sprockets::Environment.new(ROOT) do |env|
	env.logger = LOGGER
end

[COFFEE_DIR, SASS_DIR].each { |path| @sprockets.append_path path.to_s }

task :default => ['app.js']

rule '.js' => lambda { |f| find_source(f) } do |t|
	assets = @sprockets.find_asset(t.source)
	prefix, basename = assets.pathname.to_s.split('/')[-2..-1]
	FileUtils.mkpath PUBLIC_DIR.join(prefix)
	assets.write_to PUBLIC_DIR.join(prefix, basename.sub(/\.coffee\Z/i, '.js'))
end

def find_source(file)
	base = File.basename file, '.js'
	COFFEE_SRC.find { |s| File.basename(s, '.coffee') == base }
end
