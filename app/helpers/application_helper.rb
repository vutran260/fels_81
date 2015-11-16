module ApplicationHelper
  def new_fields_template f, association
    new_object = f.object.class.reflect_on_association(association).klass.new
    tmpl = f.fields_for(association, new_object,
      child_index: "new_#{association}") do |b|
      render(partial: association.to_s.singularize + "_form", locals: {f: b})
    end
    tmpl = tmpl.gsub /(?<!\n)\n(?!\n)/, " "
    return "<script> var #{association.to_s}_form = '#{tmpl.to_s}' </script>"
      .html_safe
  end

  def add_child_button name, association, target
    content_tag(:spam, "<span class='btn btn-success'>#{name}</span>".html_safe,
      class: "add_child", "data-association"=> association, target: target)
  end

  def generate_activity activity, type
    result = link_to activity.user.name, activity.user
    result << " #{t "activity.#{activity.action_type}"}"
    case type
      when :follow
        result << "#{link_to activity.action_object_name(User).name, activity
          .action_object_name(User)}".html_safe
      when :learned
        result << " #{activity.action_object_name(Lesson).words_correct}"
        result << " #{t "words"} #{t "in"}
          #{link_to "#{t("lesson")} #{activity.action_object_name(Lesson).id}",
          activity.action_object_name(Lesson)} #{t "from"}
          #{link_to activity.action_object_name(Lesson).category.name,
          activity.action_object_name(Lesson).category}".html_safe
      when :learning
        result << " #{link_to "#{t("lesson")} #{activity.action_object_name(Lesson).id}",
          activity.action_object_name(Lesson)}
          #{t "from"} #{link_to activity.action_object_name(Lesson).category.name,
          activity.action_object_name(Lesson).category}".html_safe
    end
    result << " (#{time_ago_in_words activity.created_at} #{t "ago"}.)"
  end
end
