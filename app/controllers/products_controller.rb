class ProductsController < ApplicationController

	def index
		@product = if params[:search]
			Product.where("LOWER(name) LIKE LOWER(?)", "%#{params[:search]}%").order('products.created_at DESC').page(params[:page])
		else
	 		Product.all.order('products.created_at DESC').page(params[:page])
	 	end

	 	if request.xhr?
	 		render @product
	 	end
	end

	def show
		@product = Product.find(params[:id])
		 	if current_user
    		@review = @product.reviews.build
  		end
	end 

	def new
		@product = Product.new

		respond_to do |format|
			format.html
			format.js
		end
		
	end

	def edit
		@product = Product.find(params[:id])
	end

	def create
		@product = Product.new(product_params)

		if @product.save
			redirect_to product_url
		else
			render :new
		end
	end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end



private
	def product_params
    params.require(:product).permit(:name, :description, :price_in_cents)
  end

end
