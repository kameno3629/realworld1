class Tag < ApplicationRecord
    # タグ名は一意でなければならない
    validates :name, presence: true, uniqueness: true
end