module ApplicationHelper
  
  def link_to_submit(text, cls)
    link_to_function text, "$(this).closest('form').submit()", :class=> "button #{cls}"
  end
  
end
