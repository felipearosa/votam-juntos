class Vote < ApplicationRecord
  belongs_to :senator
  belongs_to :bill
end
