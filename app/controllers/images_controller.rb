require "securerandom"

class ImagesController < ApplicationController
  layout "container"
  allow_unauthenticated_access only: %i[ show index ]
  def index
    @images = Image.all
  end
  def new
    @image = Image.new
  end
  def show
    @image = Image.find(params[:id])
  end
  def create
    unless Current.user.allowed_in
      render :new, status: :forbidden
      return
    end
    @image = image_model(image_params)
    if @image.save
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # @return [Image]
  def image_model(_params)
    # @type [ActionDispatch::Http::UploadedFile] attachment
    attachment = _params[:content]
    _params[:web_address] = SecureRandom.uuid
    _params[:mimetype] = attachment.content_type
    img = Image.new(_params)
    img.content.attach(io: attachment.tempfile, filename: _params[:web_address], content_type: _params[:mimetype])
    Current.user.images.push(img)
    img
  end

  # @return [ActionController::Parameters]
  def image_params
    params.expect(image: [ :name, :content ])
  end
end
