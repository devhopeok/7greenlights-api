class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include ActiveAdminJcrop::AssetEngine::CarrierWave

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :normal do
    process :active_admin_crop
  end

  version :large do
    process :active_admin_crop
    process resize_to_fit: [1000, 1000]
  end

  version :medium do
    process :active_admin_crop
    process resize_to_fit: [500, 500]
  end

  version :small do
    process :active_admin_crop
    process resize_to_fit: [250, 250]
  end

  version :thumbnail do
    process :active_admin_crop
    process resize_to_fit: [100, 100]
  end
end
