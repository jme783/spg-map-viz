class Order < ActiveRecord::Base
  belongs_to :hub
  scope :hub_id, -> (hub_id) {where hub_id: hub_id}
  scope :completed_before, -> (order_completed_at) {where(["order_completed_at < ?", DateTime.parse(order_completed_at)])}
  scope :completed_after, -> (order_completed_at) {where(["order_completed_at > ?", DateTime.parse(order_completed_at)])}
end

