class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true

  def as_json(options = {})
    super(options.merge(
      only: %i[id name address phone opening_hours created_at],
    ))
  end
end
