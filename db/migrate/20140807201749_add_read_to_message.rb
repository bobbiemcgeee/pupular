class AddReadToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :read, :bool, default: false
  end
end
