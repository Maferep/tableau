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
    if not Current.user.allowed_in
      render :new, status: :forbidden
      return
    end
    _params = image_params
    uuid = SecureRandom.uuid
    _params[:web_address] = uuid
    attachment = _params[:content]
    _params[:mimetype] = attachment.content_type
    logger.warn _params
    @image = Image.new(_params)
    @image.content.attach(io: attachment.tempfile, filename: uuid, content_type: _params[:mimetype])
    Current.user.images.push(@image)
    if @image.save
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def image_params
      params.expect(image: [ :name, :content ])
    end
end
