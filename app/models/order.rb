class Order < ActiveRecord::Base
  belongs_to :hub
  scope :hub_ids, -> (hub_ids) {
    hubs = hub_ids.split(',')
    where hub_id: hubs
  }
  scope :completed_before, -> (order_completed_at) {where(["order_completed_at < ?", DateTime.parse(order_completed_at)])}
  scope :completed_after, -> (order_completed_at) {where(["order_completed_at > ?", DateTime.parse(order_completed_at)])}
end

