# encoding: utf-8
module FormHelpers
  def form_for(obj, url, options = {})
    options = options.merge(:action => url)
    options[:method] ||= 'post'
    if options[:method] == 'put' or options[:method] == 'delete'
      real_method, options[:method] = options[:method], 'post'
    else
      real_method = nil
    end

    haml_tag :form, options do
      if real_method
        haml_tag :div do
          haml_tag :input, :type => 'hidden', :name => '_method', :value => real_method
        end
      end
      yield Builder.new(obj, self)
    end
  end

  def submit_tag(text = nil, options = {})
    options = options.merge(:value => text)
    options[:type] = 'submit'
    haml_tag :input, options
  end

  class Builder
    def initialize(object_name, obj, template, options, block)
      @object = obj
      @template = template
      @model = @object.class.name.underscore
    end

    def field(name, label, *args)
      tag :p do

        if name.to_s.ends_with? '_id'
          tag :label, label, :for => gen_id(name)
          select_tag(name, args.first)
        else if name.to_s == 'type'
          tag :label, label, :for => gen_id(name)
          type_select(name, args.first)
          else if name.to_s == 'budgeting_month'
            tag :label, label, :for => gen_id(name)
            budgeting_month(name, args.first)
            else
              prop = @object.class.properties.find { |p| p.name == name }
              value = @object.send(name)

              case prop.primitive.to_s
              when 'String'
                tag :label, label, :for => gen_id(name)
                tag :input, :name => gen_name(name), :type => 'text', :value => value, :id => gen_id(name)
              when 'Float'
                tag :label, label, :for => gen_id(name)
                tag :input, :name => gen_name(name), :type => 'text', :value => value, :id => gen_id(name)
              when 'TrueClass'
                tag :input, :name => gen_name(name), :type => 'hidden', :value => 'false'
                tag :label do
                  tag :input, :name => gen_name(name), :type => 'checkbox', :value => 'true', :checked => value
                  puts label
                end
              when 'DataMapper::Types::Text'
                tag :label, label, :for => gen_id(name)
                tag :textarea, value.to_s, :id => gen_id(name), :name => gen_name(name)
              else
                puts "Unrecognized type #{prop.primitive}"
              end
            end
          end
        end
      end
    end

    def text_area(name, label)
      tag :p do
        value = @object.send(name)
        tag :label, label, :for => gen_id(name)
        tag :textarea, value.to_s, :id => gen_id(name), :name => gen_name(name)
      end
    end

    def select_tag(name, records)
      records ||= []
      value = @object.send(name)

      tag :select, :name => gen_name(name), :id => gen_id(name) do
        tag :option, :value => ''
        for record in records
          tag :option, record, :value => record.id, :selected => (record.id == value)
        end
      end
    end

    def type_select(name, record)
      value = @object.send(name)
      list = ['financijska','materijalna','edukacija']

      tag :select, :name => gen_name(name), :id => gen_id(name) do
        tag :option, :value => ''
        for type in list
          tag :option, "#{type}", :value => "#{type}", :selected => ("#{type}" == value)
        end
      end
    end

    def budgeting_month(name, record)
      value = @object.send(name)
      list = ['siječanj','veljača','ožujak','travanj','svibanj','lipanj','srpanj','kolovoz','rujan','listopad','studeni','prosinac']

      tag :select, :name => gen_name(name), :id => gen_id(name) do
        tag :option, :value => ''
        for month in list
          tag :option, "#{month}", :value => "#{month}", :selected => ("#{month}" == value)
        end
      end
    end

    def validate_presence(name)
      puts((<<-HTML).html_safe)
        <script type='text/javascript'>
          var #{gen_id(name)} = new LiveValidation('#{gen_id(name)}');
          #{gen_id(name)}.add(Validate.Presence);
        </script>
      HTML
    end

    def validate_format(name)
      puts((<<-HTML).html_safe)
        <script type='text/javascript'>
          var #{gen_id(name)} = new LiveValidation('#{gen_id(name)}');
          #{gen_id(name)}.add(Validate.Presence).add(Validate.Format, { pattern: /^ +$/i, negate: true, failureMessage: '* required'});
        </script>
      HTML
    end

    def tag(*args, &block)
      @template.haml_tag(*args, &block)
    end

    def puts(text)
      @template.haml_concat text
    end

    def gen_id(name)
      "#{@model}_#{name}"
    end

    def gen_name(name)
      "#{@model}[#{name}]"
    end

    def self.model_name
      @model_name ||= Struct.new(:partial_path).new('form')
    end
  end
end

