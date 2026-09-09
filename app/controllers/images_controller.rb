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
    return render :new, status: :forbidden unless Current.user.allowed_in

    @image = build_image
    if @image.save
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def build_image
    attrs = image_params
    attachment = attrs[:content]
    uuid = SecureRandom.uuid

    image = Current.user.images.build(
      name: attrs[:name],
      web_address: uuid,
      mimetype: attachment.content_type
    )
    image.content.attach(io: attachment.tempfile, filename: uuid, content_type: attachment.content_type)
    image
  end

  def image_params
    params.expect(image: [ :name, :content ])
  end
end
