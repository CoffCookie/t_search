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
    @category_data = params[:category]
    @search_type = params[:search_type]
    @search_result = Array.new
    count = 0
  
    if @category_data.present?
      @searches = Search.where(category: @category_data)
    end

    if @search_data.present?
      @search_data = @search_data.split(/[[:blank:]]+/)

      # AND検索
      if @search_type == "AND"
        @searches.each do |search|
          count = 0
          @search_data.each do |search_word|
            if !search.title.match(/.*#{search_word}.*/i).nil? ||
                !search.description.match(/.*#{search_word}.*/i).nil?
              count = count + 1
            end
            if @search_data.count == count
              @search_result.push(search)
            end
          end
        end
        if @search_result.count == 0
          @unsearch_result = "見つかりませんでした。"
        end
      # OR検索
      elsif @search_type == "OR"
        @searches.each do |search|
          @search_data.each do |search_word|
            if !search.title.match(/.*#{search_word}.*/i).nil? ||
                !search.description.match(/.*#{search_word}.*/i).nil?
              @search_result.push(search)
              break
            else
              @unsearch_result = "見つかりませんでした。"
            end
          end
        end
      end

    else
      # 検索文字がない場合は、カテゴリによる絞り込みがされていたらカテゴリ。
      # 何もなければ全てのデータが表示される。
      @search_result = @searches
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
