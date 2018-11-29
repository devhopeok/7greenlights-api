ActiveAdmin.register Arena, as: 'Venues' do

  decorate_with ArenaDecorator

  permit_params :name, :description, :end_date, :image, :is_feature, :blast, sponsor_ids: []

  jcropable

  form do |f|
    f.inputs 'Details' do
      input :name
      input :description
      input :blast
      input :end_date, as: :date_time_picker
      input :is_feature, label: 'Is Feature?'
      input :image, as: :jcropable, hint: f.object.decorate.image_version_size(:small, 172), jcrop_options: { aspectRatio: 2.0 }
      input :sponsors, as: :select, input_html: {multiple: true}, collection: Sponsor.all.map{ |u| [u.name, u.id]}
    end

    actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :end_date
    column :blast
    column 'Is Feature?', :is_feature
    column(:image) { |arena| arena.image_version_size(:small, 100) }
    actions
  end

  filter :name
  filter :description
  filter :end_date
  filter :is_feature, label: 'Is Feature?'

  show do |venue|
    attributes_table do
      row :id
      row :name
      row :description
      row :blast
      row :end_date
      row ('Is Feature?') { venue.is_feature }
      row (:image) { venue.image_version_size(:medium, 172) || 'No image yet.' }
    end

    panel 'Sponsors' do
      table_for venue.sponsors do
        column :name
        column :url
        column (:image) { |sponsor| sponsor.decorate.picture_version_size(:small, 100) }
      end
    end
  end
end
