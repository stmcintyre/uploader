class Photo < ActiveRecord::Base
  dragonfly_accessor :image do
    after_assign do |img|
     img.encode!('jpg', '-quality 80') if img.image?
    end
  end

  validates :title, presence: true, length: {minimum: 2, maximum: 20}
  validates :image, presence: true

  validates :image, presence: true
  validates_size_of :image, maximum: 2.megabytes,
                    message: "should be no more than 5 MB", if: :image_changed?

  validates_property :format, of: :image, in: [:jpeg, :jpg, :png, :bmp, :gif], case_sensitive: false,
                     message: "should be either .jpeg, .jpg, .png, .bmp, .gif", if: :image_changed?

  validates_property :width, of: :image, in: (0..3000),
                           message: proc{ |actual, model| "Sorry, #{model.title} - was #{actual}. Maximum width is 3000" }

end
