class UsersModels < ActiveRecord::Migration
  def change
    create_table :creators_users, id: false do |t|
      t.belongs_to :creator, index: true
      t.belongs_to :user, index: true
    end
  end
end
