class AddAdminToReporters < ActiveRecord::Migration[5.2]
  def change
    add_column :reporters, :is_admin, :boolean, default: false
  end
end
