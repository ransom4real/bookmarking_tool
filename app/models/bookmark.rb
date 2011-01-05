require 'hpricot'
require 'net/https'
require_dependency "fulltextsearch"
require 'validates_uri_existence_of'


class Bookmark < ActiveRecord::Base
	belongs_to :site, :autosave => true
	
	validates_associated :site
	validates_presence_of :url, :tags
	validates_length_of :url, :minimum => 1, :too_short => "please enter at least {{count}} character"
	validates_length_of :tags, :minimum => 1, :too_short => "please enter at least {{count}} character"

	#This is the default configuration anyway for searching across all columns of the model. 
	#Specific columns could be defined using searches_on :column_name1, :column_name2
	searches_on :all
	validates_uri_existence_of :url,:with => /(^(http|https):\/\/[a-z0-9]+([-.]{1}[a-z0-9]*)+. [a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
	
	def self.extract_data_from_url(url="", domain="")
	  data = Hash.new()
	  metadata = ""
	  title = ""
	  domain_title = ""
	  
		  begin
			  #Get meta data for bookmark
			  doc = Hpricot(open(url, 10))
			  
			  (doc/"meta").each do |m|
				metadata += m.to_s
			  end
			  
			  (doc/"title").each do  |t|
				title += t.inner_html
			  end
		  rescue
		  end
		  
		  doc = nil
		  
			begin
				#Get page title data for domain
				doc = Hpricot(open(domain, 10))
				
				(doc/"title").each do  |ti|
				domain_title += ti.inner_html
				end
			rescue
			end		  
		  
		  
	  data["metadata"] = metadata
	  data["title"] = title
	  data["domain_title"] = domain_title
	  
	  return data
	  
	end
	
	def self.getdomain(url)
	#Gets the links domain
	 uri = URI.parse(url)
		 #If the depending on the protocol appends it to front of domain
		 if uri.scheme == "https"
			return uri.scheme + "://" + url.gsub(/^(https:\/\/)?(www\.)?/,'').gsub(/\/.*$/,'')
		 elsif uri.scheme == "http"
			return uri.scheme + "://" + url.gsub(/^(http:\/\/)?(www\.)?/,'').gsub(/\/.*$/,'')
		 else
			return "http://" + url.gsub(/^(http:\/\/)?(www\.)?/,'').gsub(/\/.*$/,'')
		 end
	
	end
	
	def self.open(url, limit)
	#Grabs page based on url or nothing if no url is supplied. Returns an empty response or a page
		response = ""
		
			# You should choose better exception.
		  raise ArgumentError, 'HTTP redirect too deep' if limit == 0
		  uri = URI.parse(url)
		  #If path is empty set path to root location of site
		  if uri.path == "" || uri.path == nil
			uri.path = "/"
		  end
		  #For https bookmarks url
		  if uri.scheme == "https"
			  http = Net::HTTP.new(uri.host, uri.port)
			  http.use_ssl = true  # enable SSL/TLS
			  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
				http.start {
				  http.request_get(uri.path) {|res|
					response += res.body
				  }
				}
		  #For http bookmarks url
		  else
			  res = Net::HTTP.get_response(URI.parse(url))
			  case res
			  when Net::HTTPSuccess   
				response = res.body
			  #If redirect and the url of the new location is available get location page
			  when Net::HTTPFound 
				response = open(res['location'], limit - 1)
			 #If page moved and the url of the new location is available get location page
			  when Net::HTTPMovedPermanently
				response = open(res['location'], limit - 1)
			  else

			  end
		  end
		
		return response
	end
end
