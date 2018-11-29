ActiveAdmin.register User do
  permit_params :email, :username, :birthday
  actions :all, except: [:new]

  form do |f|
    f.inputs 'Details' do
      input :active
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :birthday
    column :facebook_login do |p|
      p.facebook_id.present?
    end
    column :instagram_login do |p|
      p.instagram_id.present?
    end
    column :active
    column :created_at
    column :updated_at
    actions
  end

  filter :id
  filter :email
  filter :username
  filter :birthday
  filter :active
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :email
      row :username
      row :birthday
      row :active
      row :created_at
      row :updated_at
    end
  end
end
