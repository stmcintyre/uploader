class Photo < ActiveRecord::Base
  dragonfly_accessor :image do
    after_assign do |img|
     img.encode!('jpg', '-quality 80') if img.image?
    end
  end

  validates :title, presence: true, length: {minimum: 2, maximum: 20}
  validates :image, presence: true

  validates :image, presence: true
  validates_size_of :image, maximum: 500.kilobytes,
                    message: "should be no more than 500 KB", if: :image_changed?

  validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp], case_sensitive: false,
                     message: "should be either .jpeg, .jpg, .png, .bmp", if: :image_changed?

  validates_property :width, of: :image, in: (0..1000),
                           message: proc{ |actual, model| "Unlucky #{model.title} - was #{actual}" }

end
