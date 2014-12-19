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

		block = "<select name='religion' class='pure-input-medium'>"
		@details[:religion].each do |religion|
			name = religion[:label]
			block += "<option value='#{religion[:key]}'>#{religion[:label]}</option>"
		end
		block += "</select>"
		block
	end

	def section(type)
		"<p>"+@details[type.to_sym].to_a.shuffle.first+"</p>"
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
		pronouns = { m: [ "he", "his" ], f: [ "she", "her" ]}

		stories = []
		#cat_i = 
		antics = @details[:antics].shuffle

		@details[:cats].to_a.shuffle.each_with_index do |cat, j|
			antic = antics[j]

			# Insert the cat's name in the placeholder
			antic = antic.gsub(/NAME/, cat[:name].capitalize)

			# Update the pronouns
			pnouns = pronouns[cat[:sex].to_sym]

			# Probably not the most efficient
			antic = antic.gsub(/\bShe\b/, pnouns[0].capitalize)
			antic = antic.gsub(/\bshe\b/, pnouns[0])
			antic = antic.gsub(/\bHer\b/, pnouns[1].capitalize)
			antic = antic.gsub(/\bher\b/, pnouns[1])

			# append to our collection of crazy antics
			stories << antic
		end

		"<p>"+stories.join("</p><p>")+"</p>"
	end
end
