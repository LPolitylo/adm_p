class CreateJoinTableRoleAcl < ActiveRecord::Migration[5.2]
  def change
    create_join_table :roles, :acls do |t|
      t.index [:role_id, :acl_id]
    end
  end
end
