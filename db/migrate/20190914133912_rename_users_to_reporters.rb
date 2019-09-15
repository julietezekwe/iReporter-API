class RenameUsersToReporters < ActiveRecord::Migration[5.2]
  def change
    rename_table :users, :reporters
  end
end
