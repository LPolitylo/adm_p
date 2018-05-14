class CreateAcls < ActiveRecord::Migration[5.2]
  def change
    create_table :acls do |t|
      t.string :class_name
      t.string :method_name

      t.timestamps
    end
  end
end
