class ApiController < ApplicationController

  def search

    results = all_params.to_h.map do |model_name, values|
      model = model_name.to_s.classify.constantize rescue nil
      if model.present?
        query_bits = values.map do |key, value|
          if model.column_names.include?(key)
            model.arel_table[key.to_sym].matches("%#{value}%")
          end
        end

        query = query_bits[0]
        query_bits[1..-1].each do |q|
          query = query.or(q)
        end

        result = model.where(query)

        order_by = params["order_by"][model_name] rescue {}
        order_by ||= {}
        result = result.order(order_by.to_h) unless order_by.empty?

        group_by = params["group_by"][model_name] rescue []
        group_by ||= []
        result = result.group(group_by.append(*order_by.keys)).select(group_by.append(*order_by.keys)) unless group_by.empty?

        count_on = params["count_on"][model_name] rescue false
        count_on ||= false
        result = result.count(group_by.append(*order_by.keys).uniq.join(',')) unless count_on == false

        [model_name, result]
      end
    end

    respond_to do |format|
      format.json { render json: results.compact.to_h}
    end
  end

  def article_sums
    params[:code]
  end

  def all_params
    params.permit!
  end
end
