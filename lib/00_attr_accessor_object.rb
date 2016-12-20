class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name)  { instance_variable_get("@"+name.to_s) }
      define_method(name.to_s + "=") { |arg| instance_variable_set("@"+name.to_s, arg) }
    end
  end
end
