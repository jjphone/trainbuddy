class AddInvitationToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :invitation_id, :integer
  end
end
