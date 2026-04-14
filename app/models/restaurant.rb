class Restaurant < ApplicationRecord
  has_many :menu_items, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true

  after_commit :invalidate_cache

  scope :cached_index, ->(page) {
    Rails.cache.fetch("restaurants:index:page:#{page || 1}", expires_in: 5.minutes) do
      restaurants = order(:name).page(page).per(10)
      {
        data: restaurants.as_json,
        meta: {
          current_page: restaurants.current_page,
          total_pages: restaurants.total_pages,
          total_count: restaurants.total_count
        }
      }
    end
  }

  def cached_show
    Rails.cache.fetch("restaurant:#{id}", expires_in: 5.minutes) do
      as_json(include: :menu_items)
    end
  end

  private

  def invalidate_cache
    Rails.cache.delete("restaurant:#{id}")
    Rails.cache.delete_matched("restaurants:index:*")
  end
end
