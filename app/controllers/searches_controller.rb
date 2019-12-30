class SearchesController < ApplicationController
  before_action :set_search, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :search

  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.all
  end

  def search_index
    @searches = Search.all
    @search_data = params[:search]
    @search_result = Array.new

    @searches.each do |search|
      if !search.title.match(/.*#{@search_data}.*/).nil? ||
          !search.description.match(/.*#{@search_data}.*/).nil?
        @search_result.push(search)
      else
        @unsearch_result = "見つかりませんでした。"
      end
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show

  end

  # GET /searches/new
  def new
    @search = Search.new
  end

  # GET /searches/1/edit
  def edit
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(search_params)

    begin
    data_acquisition

    respond_to do |format|
      if @search.save!
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
        format.json { render :show, status: :created, location: @search }
      else
        format.html { render :new }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
    rescue => e
      flash[:notice] = e
      puts e
      redirect_to(new_search_path)
    end
  end

  # PATCH/PUT /searches/1
  # PATCH/PUT /searches/1.json
  def update
    respond_to do |format|
      if @search.update(search_params)
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { render :show, status: :ok, location: @search }
      else
        format.html { render :edit }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search.destroy
    respond_to do |format|
      format.html { redirect_to searches_url, notice: 'Search was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_params
      params.require(:search).permit(:category, :title, :url, :description)
    end
    
    #title,description scraping
    def data_acquisition
      require 'open-uri'
      require 'nokogiri'

      charset = nil
      
        open(@search.url) { |io|
          charset = io.charset
        }
        doc = Nokogiri::HTML(open(@search.url),nil,charset)
        @search.title = doc.title
        @search.description = doc.xpath('/html/head/meta[@name="description"]/@content').to_s
    end
end
