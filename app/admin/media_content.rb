ActiveAdmin.register MediaContent do
  decorate_with MediaContentDecorator

  permit_params :name, :media_url, :links, :is_hidden
  actions :all, except: [:new]

  form do |f|
    f.inputs 'Details' do
      input :is_hidden, label: 'Is Hidden?'
    end

    actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :media_url
    column :links, :links_to_s
    column 'Is Hidden?', :is_hidden
    actions
  end

  filter :name
  filter :media_url
  filter :links
  filter :is_hidden, label: 'Is Hidden?'

  show do
    attributes_table do
      row :id
      row :name
      row :media_url
      row (:links) { media_content.links_to_s }
      row :user
      row ('Is Hidden?') { media_content.is_hidden }
    end

    panel 'Reports' do
      table_for media_content.reports do
        column :id do |report|
          link_to report.id, admin_report_path(report)
        end
        column 'Reporter', :user
        column :message
        column :solved
      end
    end


    panel 'Venues' do
      table_for media_content.arenas do
        column :id do |arena|
          link_to arena.id, admin_venue_path(arena)
        end
        column :name
      end
    end
  end
end
