ActiveAdmin.register Report do
  permit_params :message, :solved
  actions :all, except: [:new]

  index do
    selectable_column
    id_column
    column :message
    column :solved
    column 'Reporter', :user
    column :media_content

    actions
  end

  form do |f|
    f.inputs 'Details' do
      input :solved
    end

    actions
  end

  filter :solved
  filter :media_content
  filter :user

  show do
    attributes_table_for report do
      row :id
      row :message
      row :solved
      row ('Reporter') do
        user = report.user
        link_to user.username, admin_user_path(user)
      end
      row ('Content Owner') do
        user = report.media_content.user
        link_to user.username, admin_user_path(user)
      end
      row :media_content
    end
  end
end
