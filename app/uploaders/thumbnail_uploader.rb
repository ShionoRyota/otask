class ThumbnailUploader < CarrierWave::Uploader::Base


  include Cloudinary::CarrierWave
     include CarrierWave::RMagick
    process :convert => 'png'
     process :tags => ['image_name']

    version :standard do
       process :resize_and_pad=> [570, 852, background = :transparent, gravity = ::Magick::CenterGravity]
    end

    storage :file

    def store_dir
       "post_images/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    version :thumb do
      process :resize_to_fill=>[380, 568, background = :transparent, gravity = ::Magick::CenterGravity]
    end

     def extension_whitelist
       %w(jpg jpeg gif png)
     end

    def filename
     "#{secure_token}.png" if original_filename.present?
   end

   def public_id
    return model.id
  end

#   # Include RMagick or MiniMagick support:
#   include Cloudinary::CarrierWave if Rails.env.production?
#   include CarrierWave::RMagick
#   include CarrierWave::MiniMagick

#   # Choose what kind of storage to use for this uploader:
#   # storage :file
#   # storage :fog

#   # Override the directory where uploaded files will be stored.
#   # This is a sensible default for uploaders that are meant to be mounted:
#   def store_dir
#     "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
#   end

#     process :convert => 'jpg'

#   def filename
#     "#{secure_token}.#{file.extension}" + '.jpg' if original_filename.present?
#   end

#   # Provide a default URL as a default if there hasn't been a file uploaded:
#   # def default_url
#   #   # For Rails 3.1+ asset pipeline compatibility:
#   #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
#   #
#   #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
#   # end

#   # Process files as they are uploaded:
#   # process scale: [200, 300]
#   #
#   # def scale(width, height)
#   #   # do something
#   # end

#   # Create different versions of your uploaded files:
#   # version :thumb do
#   #   process resize_to_fit: [50, 50]
#   # end

#   # Add a white list of extensions which are allowed to be uploaded.
#   # For images you might use something like this:
#   def extension_whitelist
#    %w(jpg jpeg png pdf)
#   end

#   # Override the filename of the uploaded files:
#   # Avoid using model.id or version_name here, see uploader/store.rb for details.
#   # def filename
#   #   "something.jpg" if original_filename
#   # end

# protected
#   def secure_token
#     var = :"@#{mounted_as}_secure_token"
#     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
#   end
end
