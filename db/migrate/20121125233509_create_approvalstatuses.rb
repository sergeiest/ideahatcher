class CreateApprovalstatuses < ActiveRecord::Migration
  def change
    create_table :approvalstatuses do |t|
      t.integer :id
      t.string  :status

      t.timestamps
    end
  end
end
