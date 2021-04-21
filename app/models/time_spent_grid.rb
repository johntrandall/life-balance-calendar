class TimeSpentGrid

  include Datagrid

  scope do
    User.includes(:group)
  end

  filter(:category, :enum, select: ["first", "second"])
  filter(:disabled, :xboolean)
  filter(:group_id, :integer, multiple: true)
  filter(:logins_count, :integer, range: true)
  filter(:group_name, :string, header: "Group") do |value|
    self.joins(:group).where(:groups => { :name => value })
  end

  column(:name)
  column(:group, order: -> { joins(:group).order(groups: :name) }) do |user|
    user.name
  end
  column(:active, header: "Activated") do |user|
    !user.disabled
  end
  
end
