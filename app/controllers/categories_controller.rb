class CategoriesController < ApplicationController
    def new
        @category = Category.new
    end
    def create
        @category = Category.new(category_params)
        begin
            respond_to do |format|
                if @category.save!
                format.html { redirect_to @category, notice: 'Category was successfully created.' }
                format.json { render :show, status: :created, location: @category }
                else
                format.html { render :new }
                format.json { render json: @category.errors, status: :unprocessable_entity }
                end
            end
        rescue => e
            flash[:notice] = e
            redirect_to(new_category_path)
        end
    end
    def show
    end

    private
        def category_params
            params.require(:category).permit(:category)
        end
end
