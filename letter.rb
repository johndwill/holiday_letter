require 'sinatra'
if development?
	require "sinatra/reloader" 
	require 'pry'
end
require 'haml'
require 'httpclient'
require 'yaml'

# #####################################################
# Request handlers
# #####################################################
get '/' do
	logger.info request
	@details = YAML.load_file(File.dirname(__FILE__) + "/details.yaml")

	haml :index
end

post '/generate' do
	@name = params[:name]
	@religion = params[:religion]
	@details = YAML.load_file(File.dirname(__FILE__) + "/details.yaml")
	haml :letter
end

helpers do
	def religion_selector

		block = "<select name='religion'>"
		@details[:religion].each do |religion|
			name = religion[:label]
			block += "<option value='#{religion[:key]}'>#{religion[:label]}</option>"
		end
		block += "</select>"
		block
	end

	def greeting
		@details[:religion].each do |religion|
			if religion[:key] == @religion
				str = religion[:greeting]
				return str.gsub(/NAME/,@name)
			end
		end
		return "General Greeting To You"
	end

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
