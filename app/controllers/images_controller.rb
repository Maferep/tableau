require "securerandom"

class ImagesController < ApplicationController
  layout "container"
  allow_unauthenticated_access only: %i[ show index ]

  # TODO: rails has a native way to do this.
  # Maps the browser-supplied MIME type to the symbol SafeImage.type returns
  # after actually inspecting the file's bytes.
  MIME_TO_SAFE_IMAGE_TYPE = {
    "image/jpeg" => :jpeg,
    "image/png"  => :png,
    "image/gif"  => :gif,
    "image/webp" => :webp,
    "image/avif" => :avif,
    "image/heic" => :heic,
    "image/heif" => :heic
  }.freeze

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

    attachment = image_params[:content]

    unless valid_image?(attachment)
      @image = Image.new(name: image_params[:name])
      @image.errors.add(:content, "is not a valid or supported image")
      return render :new, status: :unprocessable_entity
    end

    @image = build_image(attachment)
    if @image.save
      redirect_to @image
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def build_image(attachment)
    uuid = SecureRandom.uuid

    image = Current.user.images.build(
      name: image_params[:name],
      web_address: uuid,
      mimetype: attachment.content_type
    )
    image.content.attach(io: attachment.tempfile, filename: uuid, content_type: attachment.content_type)
    image
  end

  # Confirms the uploaded bytes are actually a decodable image, and that the
  # format SafeImage detects matches the content_type the client declared.
  def valid_image?(attachment)
    return false if attachment.blank?

    expected_type = MIME_TO_SAFE_IMAGE_TYPE[attachment.content_type]
    return false unless expected_type

    SafeImage.type(attachment.tempfile.path) == expected_type
  rescue SafeImage::LimitError, SafeImage::UnsupportedFormatError,
         SafeImage::InvalidImageError, SafeImage::NotConfiguredError => e
    Rails.logger.warn("Rejected image upload: #{e.class}: #{e.message}")
    false
  end

  def image_params
    params.expect(image: [ :name, :content ])
  end
end