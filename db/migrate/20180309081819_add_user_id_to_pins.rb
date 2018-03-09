class AddUserIdToPins < ActiveRecord::Migration[5.1]
  def change
    add_column :pins, :user_id, :integer
  end
end
