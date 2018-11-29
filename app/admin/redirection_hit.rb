ActiveAdmin.register RedirectionHit do
  actions :index

  index do
    column :origin
    column :path
    column :created_at
  end
end
