class AddSentDateToMail < ActiveRecord::Migration
  def change
    add_column :mails, :sent_date, :datetime
  end
end
