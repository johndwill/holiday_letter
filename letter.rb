require 'sinatra'
if development?
	require "sinatra/reloader" 
	require 'pry'
end
require 'haml'
require 'httpclient'
require 'YAML'

# #####################################################
# Request handlers
# #####################################################
get '/' do
	logger.info request
	haml :index
end

post '/generate' do
	@name = params[:name]
	@details = YAML.load_file(File.dirname(__FILE__) + "/details.yaml")
	haml :letter
end

helpers do
	def cat_antics
		stories = []
		indices = (0..4).to_a.shuffle
		@details[:cats].each_with_index do |cat, index|
			antic = @details[:antics][indices[index]]
			antic = antic.gsub(/NAME/, cat[:name].capitalize)
			stories << antic.gsub(/PRONOUN/, cat[:pronoun])
		end

		"<p>"+stories.join("</p><p>")+"</p>"
	end
end
