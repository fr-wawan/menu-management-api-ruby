class MenuItem < ApplicationRecord
  belongs_to :restaurant

  enum :category, {
    appetizer: "appetizer",
    main: "main",
    dessert: "dessert",
    drink: "drink"
  }

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_name, ->(search) { where("name LIKE ?", "%#{search}%") if search.present? }
end
