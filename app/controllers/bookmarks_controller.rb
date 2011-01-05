class BookmarksController < ApplicationController
include ActsAsTinyURL

  def index
	if request.xhr?
		render :partial => "new", :layout => false
	else
		@new = params[:new]
		@sites = Site.find(:all)
		if @sites && !@sites.empty?
			@bookmarks = @sites[0].bookmarks.find(:all)
		else
			@bookmarks = nil
		end
	end
  end

  def new
	if request.get?
		redirect_to :controller => "bookmarks", :action => "index", :new => "1"
	else
		if params[:bookmarking] && !params[:bookmarking].empty? && params[:bookmarking][:url] != "" && params[:bookmarking][:tags] != ""
			@bookmark = Bookmark.new(params[:bookmarking])
			domain = Bookmark.getdomain(@bookmark.url)
			@site = Site.find(:first, :conditions => [ "domain = ?", domain ])
			@metadata = Bookmark.extract_data_from_url(@bookmark.url, domain)
			@new_site = 0
			if @site
				
			else
				@site = Site.new(:name => @metadata["domain_title"] == "" ? domain:@metadata["domain_title"] , :domain => domain)
				@new_site = 1
			end
			@bookmark.page_title = @metadata["title"]
			@bookmark.meta_data = @metadata["metadata"]
			begin
			@bookmark.tiny_url = tiny_url(@bookmark.url)
			rescue
			#TinyURL returned with an error so setting tiny URL to regular URL
			@bookmark.tiny_url = @bookmark.url
			end
			@bookmark.bookmark_date = Date.today
			@site.bookmarks << @bookmark
			if @site.save
				if request.xhr?
					@site_id = @site.id
					if @new_site != 1
						@bookmarks = @site.bookmarks.find(:all)
						render :partial => "bookmarks", :layout => false
					else
						@sites = Site.find(:all)
						render :partial => "sites", :layout => false
					end
				else
				flash[:notice] = "Bookmark has been created successfully"
				redirect_to :controller => "bookmarks", :action => "index"
				end
			else
				if request.xhr?
					render :text => "ERROR: Form entries returned errors: <br></br> Bookmarks Error: " + @site.bookmarks.to_s + "<br></br> Site Error: " + @site.errors.to_s, :layout => false
				else
				flash[:error] = "Form entries returned errors: <br></br> Bookmarks Error: " + @site.bookmarks.to_s + "<br></br> Site Error: " + @site.errors.to_s
				redirect_to :controller => "bookmarks", :action => "index", :new => "1"
				end
			end
		else
			if request.xhr?
				render :text => "ERROR: Incorrect parameters supplied. Check and try again",:layout => false
			else
				flash[:error] = "Incorrect parameters supplied. Check and try again"
				redirect_to :controller => "bookmarks", :action => "index", :new => "1"
			end
		end
	end
  end

  def list
	if params[:site]
	@sites = Site.find(:all, :conditions => ["id = ?", params[:site]])
	if @sites[0] == nil
		@sites = Site.find(:all)
		if @sites && !@sites.empty?
			@bookmarks = @sites[0].bookmarks.find(:all)
		else
			@bookmarks = nil
		end
	else
		if @sites && !@sites.empty?
			@bookmarks = @sites[0].bookmarks.find(:all)
		else
			@bookmarks = nil
		end
	end
	
	if request.xhr?
		render :partial => "bookmarks", :layout => false
	else
		render :action => "index"
	end
	else
	flash[:error] = "The page you requested does not exist or has moved"
	redirect_to :controller => "bookmarks", :action => "index"
	end
  end
  
  def search
	@query = ""
	if request.xhr?
		if params[:query]
			@query = params[:query]
		end
	else
		if params[:bookmark] && params[:bookmark][:query]
			@query = params[:bookmark][:query]
		end
	end
	@bookmarks = Bookmark.search @query
	if request.xhr?
		render :partial => "bookmarks", :layout => false
	else
		@sites = Site.find(:all)
		@search = 1
		render :action => "index"
	end
  end
  
  def no_route_error
	flash[:error] = "The page you requested does not exist or has moved"
	redirect_to :controller => "bookmarks", :action => "index"
  end

end
