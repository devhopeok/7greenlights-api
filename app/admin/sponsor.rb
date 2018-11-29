ActiveAdmin.register Sponsor do
  decorate_with SponsorDecorator

  permit_params :name, :picture, :url

  jcropable

  filter :arenas, label: 'Venues'
  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :url
    column (:picture) { |sponsor| sponsor.decorate.picture_version_size(:small, 100) }
    actions
  end

  form do |f|
    f.inputs 'Details' do
      input :name
      input :url
      input :picture, as: :jcropable, hint: f.object.decorate.picture_version_size(:medium, 172), jcrop_options: { aspectRatio: 1.8 }
    end

    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :url
      row (:picture) { sponsor.decorate.picture_version_size(:medium, 172) || 'No image yet.'}
    end
  end
end
