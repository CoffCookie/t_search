class Search < ApplicationRecord
    validates :category, presence: true
    validates :url, presence: true
end
